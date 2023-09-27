package com.xcurenet.onelogin.saml2;

import java.io.IOException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.SignatureException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.joda.time.DateTime;
import org.joda.time.Instant;

import com.onelogin.saml2.authn.AuthnRequest;
import com.onelogin.saml2.authn.SamlResponse;
import com.onelogin.saml2.exception.Error;
import com.onelogin.saml2.exception.SettingsException;
import com.onelogin.saml2.exception.XMLEntityException;
import com.onelogin.saml2.http.HttpRequest;
import com.onelogin.saml2.logout.LogoutRequest;
import com.onelogin.saml2.settings.Saml2Settings;
import com.onelogin.saml2.settings.SettingsBuilder;
import com.onelogin.saml2.util.Constants;
import com.onelogin.saml2.util.Util;
import com.xcurenet.common.util.Common;
import com.xcurenet.onelogin.saml2.servlet.ServletUtils;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class SamlSSOAuth {
	
	private static final String LOGIN_RETURN_URI = "loginSSOProcess.do";
	
	/**
	 * Settings data.
	 */	
	private Saml2Settings settings;

	/**
	 * HttpServletRequest object to be processed (Contains GET and POST parameters, session, ...).
	 */
	private HttpServletRequest request;

	/**
	 * HttpServletResponse object to be used (For example to execute the redirections).
	 */
	private HttpServletResponse response;

	/**
	 * NameID.
	 */
	private String nameid;

	/**
	 * NameIDFormat.
	 */
	private String nameidFormat;

	/**
	 * SessionIndex. When the user is logged, this stored it from the AuthnStatement of the SAML Response
	 */
	private String sessionIndex;

	/**
	 * SessionNotOnOrAfter. When the user is logged, this stored it from the AuthnStatement of the SAML Response
	 */
	private DateTime sessionExpiration;

	/**
	 * The ID of the last message processed
	 */
	private String lastMessageId;

	/**
	 * The ID of the last assertion processed
	 */
	private String lastAssertionId;

	/**
	 * The NotOnOrAfter values of the last assertion processed
	 */
	private List<Instant> lastAssertionNotOnOrAfter;

	/**
	 * User attributes data.
	 */
	private Map<String, List<String>> attributes = new HashMap<String, List<String>>();

	/**
	 * If user is authenticated.
	 */	
	private boolean authenticated = false;

	/**
	 * Stores any error.
	 */
	private List<String> errors = new ArrayList<String>();

	/**
	 * Reason of the last error.
	 */
	private String errorReason;

	/**
	 * The id of the last request (Authn or Logout) generated
	 */
	private String lastRequestId;

	/**
	 * The most recently-constructed/processed XML SAML request
	 * (AuthNRequest, LogoutRequest) 
	 */
	private String lastRequest;

	/**
	 * The most recently-constructed/processed XML SAML response
	 * (SAMLResponse, LogoutResponse). If the SAMLResponse was
	 * encrypted, by default tries to return the decrypted XML 
	 */
	private String lastResponse;
	
	/**
		Initializes the SP SAML instance.
		@param request : HttpServletRequest object to be processed
		@param response : HttpServletResponse object to be used
		@throws IOException
		@throws SettingsException 
		@throws Error
	*/
	public SamlSSOAuth(HttpServletRequest request, HttpServletResponse response) throws IOException, SettingsException, Error {
		this(new SettingsBuilder().fromFile("onelogin.saml.properties").build(), request, response);
	}

	/**
		Initializes the SP SAML instance.
		@param settings : Saml2Settings object. Setting data
		@param request : HttpServletRequest object to be processed
		@param response : HttpServletResponse object to be used 
		@throws SettingsException 
	*/
	public SamlSSOAuth(Saml2Settings settings, HttpServletRequest request, HttpServletResponse response) throws SettingsException {
		this.settings = settings;
		this.request = request;
		this.response = response;
		
		// Check settings
		List<String> settingsErrors = settings.checkSettings();
		if (!settingsErrors.isEmpty()) {
			errors.add("invalid_settings");
			String errorMsg = "Invalid settings: ";
			errorMsg += StringUtils.join(settingsErrors, ", ");
			throw new SettingsException(errorMsg, SettingsException.SETTINGS_INVALID);
		}
	}

	/**
		Initiates the SSO process.
		@param returnTo : The target URL the user should be returned to after login (relayState).
						  Will be a self-routed URL when null, or not be appended at all when an empty string is provided
		@param forceAuthn : When true the AuthNRequest will set the ForceAuthn='true'
		@param isPassive : When true the AuthNRequest will set the IsPassive='true'
		@param setNameIdPolicy : When true the AuthNRequest will set a nameIdPolicy
		@param stay : True if we want to stay (returns the url string) False to execute redirection
		@return the SSO URL with the AuthNRequest if stay = True
		@throws IOException
		@throws SettingsException
	*/
	public String login(String returnTo, Boolean forceAuthn, Boolean isPassive, Boolean setNameIdPolicy, Boolean stay) throws IOException, SettingsException {
		// Set parameter for ADFS authentication processing.
		Map<String, String> parameters = new HashMap<String, String>();
		AuthnRequest authnRequest = new AuthnRequest(settings, forceAuthn, isPassive, setNameIdPolicy);
		String samlRequest = authnRequest.getEncodedAuthnRequest();
		parameters.put("SAMLRequest", samlRequest);

		String relayState;
		if (returnTo == null) {
			relayState = ServletUtils.getSelfRoutedURLNoQuery(request);
		} else {
			relayState = returnTo;
		}

		if (settings.getAuthnRequestsSigned()) {
			String sigAlg = settings.getSignatureAlgorithm();
			String signature = this.buildRequestSignature(samlRequest, relayState, sigAlg);

			parameters.put("SigAlg", sigAlg);
			parameters.put("Signature", signature);
		}

		String ssoUrl = getSSOurl();
		lastRequestId = authnRequest.getId();
		lastRequest = authnRequest.getAuthnRequestXml();

		if (!stay) {
			log.debug("AuthNRequest sent to " + ssoUrl + " --> " + samlRequest);
		}
		
		// Request ADFS authentication for ADFS authentication.
		return ServletUtils.sendRedirect(response, ssoUrl, parameters, stay);
	}

	/**
		Initiates the SSO process.
		@throws IOException
		@throws SettingsException
	*/
	public void login() throws IOException, SettingsException {
		login(makeReturnUrl(LOGIN_RETURN_URI), false, false, true, false);
	}

	/**
	 * Initiates the SLO process.
	 *
	 * @param returnTo 
	 *				The target URL the user should be returned to after logout (relayState).
	 *				Will be a self-routed URL when null, or not be appended at all when an empty string is provided
	 * @param nameId 
	 *				The NameID that will be set in the LogoutRequest.
	 * @param sessionIndex 
	 *				The SessionIndex (taken from the SAML Response in the SSO process).
	 * @param stay
	 *            	True if we want to stay (returns the url string) False to execute redirection
	 * @param nameidFormat
	 *            	The NameID Format will be set in the LogoutRequest.
	 *
	 * @return the SLO URL with the LogoutRequest if stay = True
	 *
	 * @throws IOException
	 * @throws XMLEntityException
	 * @throws SettingsException
	 */
	public String logout(String returnTo, String nameId, String sessionIndex, Boolean stay, String nameidFormat, Boolean keepLocalSession) throws IOException, XMLEntityException, SettingsException {
		Map<String, String> parameters = new HashMap<String, String>();

		LogoutRequest logoutRequest = new LogoutRequest(settings, null, nameId, sessionIndex, nameidFormat);
		String samlLogoutRequest = logoutRequest.getEncodedLogoutRequest();
		parameters.put("SAMLRequest", samlLogoutRequest);

		// returnTo is not null
		String relayState;
		if (returnTo == null) {
			relayState = StringUtils.EMPTY;
		} else {
			relayState = returnTo;
		}
		
		// If there is 'relayState', forwarding to that URL after logout.
		if (!relayState.isEmpty()) {
			parameters.put("wreply", relayState);
		}

		if (settings.getLogoutRequestSigned()) {
			String sigAlg = settings.getSignatureAlgorithm();
			String signature = this.buildRequestSignature(samlLogoutRequest, relayState, sigAlg);

			parameters.put("SigAlg", sigAlg);
			parameters.put("Signature", signature);
		}

		String sloUrl = getSLOurl();
		lastRequestId = logoutRequest.getId();
		lastRequest = logoutRequest.getLogoutRequestXml();

		// local session kill
		if (!keepLocalSession) {
			request.getSession().invalidate();
		}
		
		if (!stay) {
			log.debug("Logout request sent to " + sloUrl + " --> " + samlLogoutRequest);
		}

		return ServletUtils.sendRedirect(response, sloUrl, parameters, stay);
	}
	
	/**
	 * Initiates the SLO process.
	 * 
	 * @param  returnTo
	 * 				The target URL the user should be returned to after logout (relayState).
	 * 				Will be a self-routed URL when null, or not be appended at all when an empty string is provided
	 * @throws IOException
	 * @throws XMLEntityException
	 * @throws SettingsException
	 */
	public void logout(String returnTo) throws IOException, XMLEntityException, SettingsException {
		logout(returnTo, null, null, false, null, false);
	}
	
	/**
	 * Initiates the SLO process.
	 * 
	 * @param  keepLocalSession
	 * 				When false will destroy the local session, otherwise will destroy it
	 * @throws IOException
	 * @throws XMLEntityException
	 * @throws SettingsException
	 */
	public void logout(Boolean keepLocalSession) throws IOException, XMLEntityException, SettingsException {
		logout(null, null, null, false, null, keepLocalSession);
	}
	
	/**
	 * Initiates the SLO process.
	 * 
	 * @param  returnTo
	 * 				The target URL the user should be returned to after logout (relayState).
	 * 				Will be a self-routed URL when null, or not be appended at all when an empty string is provided
	 * @param  keepLocalSession
	 * 				When false will destroy the local session, otherwise will destroy it
	 * @throws IOException
	 * @throws XMLEntityException
	 * @throws SettingsException
	 */
	public void logout(String returnTo, Boolean keepLocalSession) throws IOException, XMLEntityException, SettingsException {
		logout(returnTo, null, null, false, null, keepLocalSession);
	}
	
	/**
	 * Initiates the SLO process.
	 * 
	 * @throws IOException
	 * @throws XMLEntityException
	 * @throws SettingsException
	 */
	public void logout() throws IOException, XMLEntityException, SettingsException {
		logout(null, null, null, false, null, false);
	}

	/**
	 * @return The url of the Single Sign On Service
	 */
	public String getSSOurl() {
		return settings.getIdpSingleSignOnServiceUrl().toString();
	}

	/**
	 * @return The url of the Single Logout Service
	 */
	public String getSLOurl() {
		return settings.getIdpSingleLogoutServiceUrl().toString();
	}

	/**
	 * @return The url of the Single Logout Service Response.
	 */
	public String getSLOResponseUrl() {
		return settings.getIdpSingleLogoutServiceResponseUrl().toString();
	}

	/**
	 * Process the SAML Response sent by the IdP.
	 *
	 * @throws Exception 
	 */
	public void processResponse() throws Exception {
		//processResponse(settings.getIdpSingleSignOnServiceUrl().toString());
		processResponse(null);
	}

	/**
	 * Process the SAML Response sent by the IdP.
	 *
	 * @param requestId
	 *				The ID of the AuthNRequest sent by this SP to the IdP
	 *
	 * @throws Exception 
	 */
	public void processResponse(String requestId) throws Exception {
		authenticated = false;
		// Search the forwarding variable of the authentication request (SAMLResponse)
		final HttpRequest httpRequest = ServletUtils.makeHttpRequest(this.request);
		final String samlResponseParameter = httpRequest.getParameter("SAMLResponse");
		// When the result parameter information of the authentication request exists
		if (samlResponseParameter != null) {
			SamlResponse samlResponse = new SamlResponse(settings, httpRequest);
			lastResponse = samlResponse.getSAMLResponseXml();
			log.info("[SSO] lastResponse : {}", lastResponse);
			// Confirm that the response to the request is normal
			if (samlResponse.isValid(requestId)) {
				// In the case of successful authentication processing, the value of the state of the authentication processing is changed,
				// and Set the value passed to Response to the 'attributes' variable
				authenticated = true;											// Change the authentication result flag to true (auth success)
				attributes = samlResponse.getAttributes();						// Get auth info from ADFS

				sessionIndex = samlResponse.getSessionIndex();
				sessionExpiration = samlResponse.getSessionNotOnOrAfter();
				lastMessageId = samlResponse.getId();
				lastAssertionId = samlResponse.getAssertionId();
				lastAssertionNotOnOrAfter = samlResponse.getAssertionNotOnOrAfter();
				//nameid = samlResponse.getNameId();
				
				log.info("getNameId : {}", samlResponse.getNameId());
				request.getSession().setAttribute("uid", samlResponse.getNameId());
				request.getSession().setAttribute("sessionIndex", sessionIndex);
				request.getSession().setAttribute("nameidFormat", samlResponse.getNameIdFormat());
				
				HashMap<String, String> map = samlResponse.getNameIdData();
				Set<String> name_keys = map.keySet();
				for(String key : name_keys){
					log.info("[SSO] name_key : {}, name_value : {}", key, map.get(key));
				}
				
				// Get the Key of the authentication information received from ADFS as a List
				Collection<String> keys = attributes.keySet();
				for(String name : keys){
					log.info("[SSO] name : {}, value : {}", name, attributes.get(name).get(0));
					/*
					 * It searches for necessary values ​​for Session from authentication information received from ADFS and inserts it.
					 * Since there is only one Value in ADFS, List only get a Index 0 value
					 */
					if(name.contains("uid")) {
						List<String> values = attributes.get(name);
						request.getSession().setAttribute("uid", values.get(0));
					}
					
					if(name.contains("cn")) {
						List<String> values = attributes.get(name);
						request.getSession().setAttribute("cn", values.get(0));
					}
					
					if(name.contains("mail")) {
						List<String> values = attributes.get(name);
						request.getSession().setAttribute("mail", values.get(0));
					}
				}
				
				log.debug("processResponse success --> " + samlResponseParameter);
			} else {
				errors.add(samlResponse.getError());
				log.info("error : {}",samlResponse.getError());
			}
			
		} else {
			// If there is no parameter information for the authentication request
			errors.add("invalid_binding");
			String errorMsg = "SAML Response not found, Only supported HTTP_POST Binding";
			throw new Error(errorMsg, Error.SAML_RESPONSE_NOT_FOUND);
		}
		
	}

	/**
	 * @return the authenticated
	 */
	public final boolean isAuthenticated() {
		return authenticated;
	}

	/**
	 * @return the list of the names of the SAML attributes.
	 */
	public final List<String> getAttributesName() {
		return new ArrayList<String>(attributes.keySet());
	}

	/**
	 * @return the set of SAML attributes.
	 */
	public final Map<String, List<String>> getAttributes() {
		return attributes;
	}

	/**
	 * @param name
	 *				Name of the attribute
	 *
	 * @return the attribute value
	 */
	public final Collection<String> getAttribute(String name) {
		return attributes.get(name);
	}

	/**
	 * @return the nameID of the assertion
	 */
	public final String getNameId()
	{
		return nameid;
	}
	
	/**
	 * @return the nameID Format of the assertion
	 */
	public final String getNameIdFormat()
	{
		return nameidFormat;
	}

	/**
	 * @return the SessionIndex of the assertion
	 */
	public final String getSessionIndex()
	{
		return sessionIndex;
	}

	/**
	 * @return the SessionNotOnOrAfter of the assertion
	 */
	public final DateTime getSessionExpiration()
	{
		return sessionExpiration;
	}

	/**
	 * @return The ID of the last message processed
	 */
	public String getLastMessageId() {
		return lastMessageId;
	}

	/**
	 * @return The ID of the last assertion processed
	 */
	public String getLastAssertionId() {
		return lastAssertionId;
	}

	/**
	 * @return The NotOnOrAfter values of the last assertion processed
	 */
	public List<Instant> getLastAssertionNotOnOrAfter() {
		return lastAssertionNotOnOrAfter;
	}

	/**
	 * @return an array with the errors, the array is empty when the validation was successful
	 */
	public List<String> getErrors()
	{
		return errors;
	}

	/**
	 * @return the reason for the last error
	 */
	public String getLastErrorReason()
	{
		return errorReason;
	}

	/**
	 * @return the id of the last request generated (AuthnRequest or LogoutRequest), null if none
	 */
	public String getLastRequestId()
	{
		return lastRequestId;
	}

	/**
	 * @return the Saml2Settings object. The Settings data.
	 */
	public Saml2Settings getSettings()
	{
		return settings;
	}

	/**
	 * @return if debug mode is active
	 */
	public Boolean isDebugActive() {
		return settings.isDebugActive();
	}

	/**
	 * Generates the Signature for a SAML Request
	 *
	 * @param samlRequest
	 *				The SAML Request
	 * @param relayState
	 *				The RelayState
	 * @param signAlgorithm
	 *				Signature algorithm method
	 *
	 * @return a base64 encoded signature
	 *
	 * @throws SettingsException
	 */
	public String buildRequestSignature(String samlRequest, String relayState, String signAlgorithm) throws SettingsException
	{
		return buildSignature(samlRequest, relayState, signAlgorithm, "SAMLRequest");
	}

	/**
	 * Generates the Signature for a SAML Response
	 *
	 * @param samlResponse
	 *				The SAML Response
	 * @param relayState
	 *				The RelayState
	 * @param signAlgorithm
	 *				Signature algorithm method
	 *
	 * @return the base64 encoded signature
	 *
	 * @throws SettingsException
	 */
	public String buildResponseSignature(String samlResponse, String relayState, String signAlgorithm) throws SettingsException
	{
		return buildSignature(samlResponse, relayState, signAlgorithm, "SAMLResponse");
	}

	/**
	 * Generates the Signature for a SAML Response
	 *
	 * @param samlResponse
	 *				The SAML Response
	 * @param relayState
	 *				The RelayState
	 * @param signAlgorithm
	 *				Signature algorithm method
	 * @param type
	 *              The type of the message
	 *
	 * @return the base64 encoded signature
	 *
	 * @throws SettingsException
	 * @throws IllegalArgumentException
	 */
	private String buildSignature(String samlMessage, String relayState, String signAlgorithm, String type) throws SettingsException, IllegalArgumentException
	{
		 String signature = "";
		 
		 if (!settings.checkSPCerts()) {
			 String errorMsg = "Trying to sign the " + type + " but can't load the SP private key";
			 log.error("buildSignature error. " + errorMsg);
			 throw new SettingsException(errorMsg, SettingsException.PRIVATE_KEY_NOT_FOUND);
		 }

		 PrivateKey key = settings.getSPkey();
		 
		 String msg = type + "=" + Util.urlEncoder(samlMessage);
		 if (StringUtils.isNotEmpty(relayState)) {
			 msg += "&RelayState=" + Util.urlEncoder(relayState);
		 }
		 
		 if (StringUtils.isEmpty(signAlgorithm)) {
			 signAlgorithm = Constants.RSA_SHA1;
		 }
		 
		 msg += "&SigAlg=" + Util.urlEncoder(signAlgorithm);

		 try {
			signature = Util.base64encoder(Util.sign(msg, key, signAlgorithm));
		} catch (InvalidKeyException | NoSuchAlgorithmException | SignatureException e) {
			String errorMsg = "buildSignature error." + e.getMessage();
			log.error(errorMsg);
		}

		 if (signature.isEmpty()) {
			 String errorMsg = "There was a problem when calculating the Signature of the " + type;
			 log.error("buildSignature error. " + errorMsg);
			 throw new IllegalArgumentException(errorMsg);
		 }

		 log.debug("buildResponseSignature success. --> " + signature);
		 return signature;
	}

	/**
	 * Returns the most recently-constructed/processed
	 * XML SAML request (AuthNRequest, LogoutRequest)
	 *
	 * @return the last Request XML 
	 */
	public String getLastRequestXML()
	{
		return lastRequest;
	}

	/**
	 * Returns the most recently-constructed/processed
	 * XML SAML response (SAMLResponse, LogoutResponse).
	 * If the SAMLResponse was encrypted, by default tries
	 * to return the decrypted XML.
	 *
	 * @return the last Response XML 
	 */
	public String getLastResponseXML()
	{
		return lastResponse;
	}
	
	public String makeReturnUrl(String uri) {
		StringBuffer sb = new StringBuffer();
		if(request.isSecure()) sb.append("https://");
		else sb.append("http://");
		
		sb.append(request.getServerName());
		
		int port = request.getServerPort();
		if(port != 80 && port != 443) sb.append(":").append(request.getServerPort()).append("/");
		
		sb.append(request.getContextPath()).append("/");
		
		if(Common.isNotEmpty(uri))sb.append(uri);
		log.info("[ReturnUrl] {}", sb.toString());
		return sb.toString();
	}
}