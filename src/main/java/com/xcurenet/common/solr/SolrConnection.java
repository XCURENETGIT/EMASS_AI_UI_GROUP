package com.xcurenet.common.solr;

import java.net.MalformedURLException;
import java.util.Arrays;

import org.apache.solr.client.solrj.SolrClient;
import org.apache.solr.client.solrj.impl.CloudSolrClient;
import org.springframework.beans.factory.annotation.Autowired;

import com.xcurenet.common.util.Common;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class SolrConnection {

	private SolrClient solrServer;
	private String servers;
	private String collection;

	@Autowired
	public SolrConnection(String servers, String collection) throws MalformedURLException {
		if (Common.isEmpty(servers)) {
			servers = "http://127.0.0.1:8983/solr";
		}
		if (Common.isEmpty(collection)) {
			collection = "edc";
		}

		log.info("Apache Solr Connection start {}, {}", servers, collection);

		CloudSolrClient cloud = new CloudSolrClient.Builder(Arrays.asList(servers.split(","))).build();
		cloud.setDefaultCollection(collection);

		this.solrServer = cloud;
		this.servers = servers;
		this.collection = collection;
	}

	public void newConnection() {
		try {
			new SolrConnection(this.servers, this.collection);
		} catch (MalformedURLException e) {
			e.printStackTrace();
		}
	}

	public SolrClient getSolrServer() {
		return this.solrServer;
	}
}
