package com.xcurenet.common.elasticsearch;

import org.apache.http.HttpHost;
import org.elasticsearch.client.NodeSelector;
import org.elasticsearch.client.RestClient;
import org.elasticsearch.client.RestClientBuilder;
import org.elasticsearch.client.RestHighLevelClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.elasticsearch.core.ElasticsearchRestTemplate;

@Configuration
public class ElasticsearchConfig {

		@Value("${spring.elasticsearch.uris}")
		public String[] uris;

		@Bean
		public RestHighLevelClient elasticsearchClient() {
				HttpHost[] httpHosts = new HttpHost[uris.length];
				for (int i = 0; i < uris.length; i++) {
						String[] parts = uris[i].split(":");
						httpHosts[i] = new HttpHost(parts[0], Integer.parseInt(parts[1]), "http");
				}
				RestClientBuilder builder = RestClient.builder(httpHosts);
				return new RestHighLevelClient(builder);
		}

		@Bean
		public ElasticsearchRestTemplate elasticsearchTemplate() {
				return new ElasticsearchRestTemplate(elasticsearchClient());
		}

}
