package com.xcurenet.common.snmp.trap;

import java.io.IOException;
import java.net.UnknownHostException;
import java.util.Vector;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;

import org.snmp4j.CommandResponder;
import org.snmp4j.CommandResponderEvent;
import org.snmp4j.CommunityTarget;
import org.snmp4j.MessageDispatcherImpl;
import org.snmp4j.PDU;
import org.snmp4j.Snmp;
import org.snmp4j.TransportMapping;
import org.snmp4j.mp.MPv1;
import org.snmp4j.mp.MPv2c;
import org.snmp4j.mp.MPv3;
import org.snmp4j.security.SecurityModels;
import org.snmp4j.security.SecurityProtocols;
import org.snmp4j.security.USM;
import org.snmp4j.smi.Address;
import org.snmp4j.smi.GenericAddress;
import org.snmp4j.smi.OctetString;
import org.snmp4j.smi.TcpAddress;
import org.snmp4j.smi.UdpAddress;
import org.snmp4j.smi.VariableBinding;
import org.snmp4j.transport.DefaultTcpTransportMapping;
import org.snmp4j.transport.DefaultUdpTransportMapping;
import org.snmp4j.util.MultiThreadedMessageDispatcher;
import org.snmp4j.util.ThreadPool;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.xcurenet.common.auditMail.IntegrityMailSender;
import com.xcurenet.common.util.Common;

import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
@Slf4j
public class TrapReceiver implements CommandResponder {
	private static final String TRAP_MESSAGE_PREFIX = "|";
	private MultiThreadedMessageDispatcher dispatcher;
	private Snmp snmp = null;
	private Address listenAddress;
	private ThreadPool threadPool;

	@Autowired
	private TrapMessageProcessor tmp;
	
	/*@Autowired
	private IntegrityMailSender integrityMailSender;*/

	private void init() throws UnknownHostException, IOException {
		log.info("[SNMP TRAP] STARTUP..");
		threadPool = ThreadPool.create("Trap", 2);
		dispatcher = new MultiThreadedMessageDispatcher(threadPool, new MessageDispatcherImpl());
		listenAddress = GenericAddress.parse(System.getProperty("snmp4j.listenAddress", "udp:0.0.0.0/7792"));
		TransportMapping<?> transport;
		if (listenAddress instanceof UdpAddress) transport = new DefaultUdpTransportMapping((UdpAddress) listenAddress);
		else transport = new DefaultTcpTransportMapping((TcpAddress) listenAddress);

		CommunityTarget target = new CommunityTarget();
		target.setCommunity(new OctetString("xcn_lp"));

		snmp = new Snmp(dispatcher, transport);
		snmp.getMessageDispatcher().addMessageProcessingModel(new MPv1());
		snmp.getMessageDispatcher().addMessageProcessingModel(new MPv2c());
		snmp.getMessageDispatcher().addMessageProcessingModel(new MPv3());

		USM usm = new USM(SecurityProtocols.getInstance(), new OctetString(MPv3.createLocalEngineID()), 0);
		SecurityModels.getInstance().addSecurityModel(usm);
		snmp.listen();
	}

	/**
	 * Trap Startup
	 */
	@PostConstruct
	public void startup() {
		try {
			init();
			snmp.addCommandResponder(this);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	/**
	 * Trap Shutdown
	 *
	 * @throws IOException
	 */
	@PreDestroy
	public void shutdown() throws IOException {
		log.warn("[SNMP TRAP] SHUTDOWN..");
		threadPool.cancel();
		snmp.close();
	}

	/**
	 * 장비로 부터 Trap 요청을 받았을때
	 */
	@Override
	public void processPdu(CommandResponderEvent event) {
		if (PDU.V1TRAP == event.getPDU().getType()) return;

		String sourceIP = event.getPeerAddress().toString().split("/")[0];
		TrapMessageParser _tp = new TrapMessageParser(sourceIP, event.getPDU().getVariableBindings());

		debugMsg(event);

		String devision = _tp.getMessageType();
		log.info("[SNMP TRAP] " + sourceIP + " Check Devision ==> " + devision);
		/*if (Common.isEquals(devision, "ITG") ) {
			JSONObject integrityObj = _tp.getIntegrityMessage();
			try
			{
				log.info("[SNMP TRAP] Integrity Alarm Mail Send START...." + sourceIP );
				integrityMailSender.send(integrityObj);
				log.info("[SNMP TRAP] Integrity Alarm Mail Send END...." + sourceIP );
			}
			catch ( Exception e )
			{
				e.printStackTrace ( );
			}
		} else */
		if (checkDevision(devision)) {
			JSONObject obj = _tp.messageParser();
			JSONArray data = obj.getJSONArray("MSG_DATA");
			try {
				tmp.insertTrapMessage(_tp.messageRedefined(data.getJSONObject(0)), data.getJSONObject(0));
				log.info("[SNMP TRAP] Trap_IP : " + sourceIP + " Message_IP : " + Common.nvl(data.getJSONObject(0).get("ipAddr")));
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	/**
	 * Trap Receiver Debug Code
	 *
	 * @param event
	 */
	private void debugMsg(CommandResponderEvent event) {
		try {
			String sourceIP = event.getPeerAddress().toString().split("/")[0];
			Vector<?> vars = event.getPDU().getVariableBindings();
			StringBuffer msg = new StringBuffer();
			log.info("[SNMP TRAP] " + sourceIP + " PROCESSPDU DEBUG MESSAGE : RECEIVE COUNT : " + (vars.size() - 2));
			for (int i = 0; i < vars.size(); i++) {
				VariableBinding var = (VariableBinding) vars.get(i);
				String variable = var.getVariable().toString().trim();
				if (variable.indexOf(TRAP_MESSAGE_PREFIX) > -1) {
					log.info("[SNMP TRAP] " + sourceIP + " PROCESSPDU DEBUG MESSAGE : " + var.getVariable().toString().trim());
				}
				msg.append(variable);
				if (i < vars.size() - 1) {
					msg.append(",");
				}
			}
			log.info("[SNMP TRAP] " + sourceIP + " PROCESSPDU DEBUG ALL MESSAGE : " + msg.toString());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * Trap Message Check.....
	 *
	 * @param devision
	 * @return
	 */
	public boolean checkDevision(String devision) {
		log.info("check the trap message.");
		if (Common.isOrEquals(devision, "CPU", "MEM", "HDD", "CLR", "SVC", "LINK", "SNMP", "PROC", "TRA")) return true;
		log.warn("The trap message is not matched.");
		return false;
	}
}
