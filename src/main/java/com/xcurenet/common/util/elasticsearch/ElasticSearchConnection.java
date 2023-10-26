package com.xcurenet.common.util.elasticsearch;


import lombok.extern.slf4j.Slf4j;
import org.apache.http.HttpHost;
import org.apache.http.impl.nio.reactor.IOReactorConfig;
import org.elasticsearch.client.RestClient;
import org.elasticsearch.client.RestClientBuilder;
import org.elasticsearch.client.RestHighLevelClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

@Slf4j
@Configuration
public class ElasticSearchConnection {

    @Value("${els.host}")
    private String host;
    @Value("${els.port}")
    private int port;
    private RestHighLevelClient elasticSearchClient;

    @Autowired
    public ElasticSearchConnection() {
        HttpHost httpHost = new HttpHost("xcn1", 9200, "http");
        RestClientBuilder builder = RestClient.builder(httpHost)
                .setRequestConfigCallback(
                        requestConfigBuilder -> requestConfigBuilder
                                .setConnectTimeout(30000)
                                .setSocketTimeout(300000))
                .setHttpClientConfigCallback(
                        httpClientBuilder -> httpClientBuilder
                                .setConnectionReuseStrategy((response, context) -> true)
                                .setKeepAliveStrategy(((response, context) -> 300000))
                                .setDefaultIOReactorConfig(IOReactorConfig.custom()
                                        .setIoThreadCount(4)
                                        .build())
                );

        elasticSearchClient = new RestHighLevelClient(builder);
    }

    public RestHighLevelClient getElasticSearchClient(){
        return this.elasticSearchClient;
    }


}