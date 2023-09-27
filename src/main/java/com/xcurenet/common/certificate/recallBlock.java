package com.xcurenet.common.certificate;

import java.security.InvalidKeyException;
import java.security.Key;
import java.security.NoSuchAlgorithmException;
import java.security.SignatureException;
import java.util.Calendar;
import java.util.Formatter;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONObject;

@Slf4j
@Controller
public class recallBlock {

	/**
	 * Encryption of a given text using the provided secretKey
	 * 
	 * @param text
	 * @param secretKey
	 * @return the encoded string
	 * @throws SignatureException
	 */
	private static final String HASH_ALGORITHM = "HmacSHA256";

	private static final String HASH_ALGORITHM_STR = "696D697373796F7568616E6765656E61";

	private static final int MAX_TIME_OUT_SECOND = 60;

	
	@RequestMapping(value = "/getServerTime.xcn")
	@Description("인증정보 재사용 방지위한 서버시간 체크")
	@ResponseBody
	public JSONObject getServerTime (final HttpSession session, final HttpServletRequest request, final HttpServletResponse response) throws Exception {
		Calendar _cal = Calendar.getInstance();
		String timestamp = String.valueOf(_cal.getTimeInMillis());
		String hmac = hashMac(timestamp);
		
		JSONObject obj = new JSONObject();
		obj.put("timestamp", timestamp);
		obj.put("hmac", hmac);
		return obj;
	}
	
	public static String hashMac ( String text ) throws SignatureException
	{
		try
		{
			Key sk = new SecretKeySpec ( HASH_ALGORITHM_STR.getBytes ( ), HASH_ALGORITHM );
			Mac mac = Mac.getInstance ( sk.getAlgorithm ( ) );
			mac.init ( sk );
			final byte[] hmac = mac.doFinal ( text.getBytes ( ) );
			return toHexString ( hmac );
		}
		catch ( NoSuchAlgorithmException e1 )
		{
			throw new SignatureException ( "error building signature, no such algorithm in device " + HASH_ALGORITHM );
		}
		catch ( InvalidKeyException e )
		{
			throw new SignatureException ( "error building signature, invalid key " + HASH_ALGORITHM );
		}
	}
	
	private static String toHexString ( byte[] bytes )
	{
		StringBuilder sb = new StringBuilder ( bytes.length * 2 );
		
		Formatter formatter = new Formatter ( sb );
		for ( byte b : bytes )
		{
			formatter.format ( "%02x", b );
		}
		formatter.close ( );
		return sb.toString ( );
	}
	
	public static boolean diffTimeCheck ( long diffTime )
	{
		Calendar calendar = Calendar.getInstance ( );
		long nowDate = calendar.getTimeInMillis ( );

		long diffsecond = (nowDate/1000) - (diffTime/1000);
		if ( diffsecond > MAX_TIME_OUT_SECOND ) return false;
		else return true;
	}
}
