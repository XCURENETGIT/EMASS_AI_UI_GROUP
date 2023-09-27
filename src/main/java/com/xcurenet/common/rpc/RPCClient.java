package com.xcurenet.common.rpc;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.List;

import org.apache.xmlrpc.XmlRpcException;
import org.apache.xmlrpc.client.XmlRpcClient;
import org.apache.xmlrpc.client.XmlRpcClientConfigImpl;

public class RPCClient {

	protected XmlRpcClient client;

	public static RPCClient getClient(String url, int connectionTimeout, int replyTimeout) throws MalformedURLException {
		return new RPCClient(url, connectionTimeout, replyTimeout);
	}

	public RPCClient(String url, int connectionTimeout, int replyTimeout) throws MalformedURLException {
		XmlRpcClientConfigImpl config = new XmlRpcClientConfigImpl();
		config.setServerURL(new URL(url));
		config.setConnectionTimeout(connectionTimeout);
		config.setReplyTimeout(replyTimeout);
		config.setEnabledForExceptions(true);
		config.setEnabledForExtensions(true);

		this.client = new XmlRpcClient();

		this.client.setConfig(config);
	}

	public Object execute ( String method, List <?> list ) throws XmlRpcException
	{
		return this.client.execute ( method, list );
	}

	public Object execute ( String method, Object... obj ) throws XmlRpcException
	{
		return this.client.execute ( method, obj );
	}

	public Object executeArray ( String method, Object[] obj ) throws XmlRpcException
	{
		return this.client.execute ( method, obj );
	}

	public Object execute ( String method ) throws XmlRpcException
	{
		return this.client.execute ( method, new Object[0] );
	}
}
