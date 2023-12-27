package com.xcurenet.common.util.elasticsearch;


import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Configuration;

@Slf4j
@Configuration
public class ElasticSearchConnection {
//
//    @Value("${spring.elasticsearch.uris}")
//    private String[] host;
//    @Value("${spring.elasticsearch.port}")
//    private int port;
//    private RestHighLevelClient elasticSearchClient;
//
//    @Autowired
//    public ElasticSearchConnection() {
//        HttpHost httpHost = new HttpHost("xcn1", 9200, "http");
//        RestClientBuilder builder = RestClient.builder(httpHost)
//                .setRequestConfigCallback(
//                        requestConfigBuilder -> requestConfigBuilder
//                                .setConnectTimeout(30000)
//                                .setSocketTimeout(300000))
//                .setHttpClientConfigCallback(
//                        httpClientBuilder -> httpClientBuilder
//                                .setConnectionReuseStrategy((response, context) -> true)
//                                .setKeepAliveStrategy(((response, context) -> 300000))
//                                .setDefaultIOReactorConfig(IOReactorConfig.custom()
//                                        .setIoThreadCount(4)
//                                        .build())
//                );
//
//        elasticSearchClient = new RestHighLevelClient(builder);
//    }
//
//    public RestHighLevelClient getElasticSearchClient(){
//        return this.elasticSearchClient;
//    }

//
//    @Bean
//    public ElasticsearchClient elasticsearchClient() {
//
//        RestClient httpClient = RestClient.builder(new HttpHost(host[0], 9200)).build();
//
//        ElasticsearchTransport transport = new RestClientTransport(httpClient, new JacksonJsonpMapper());
//
//        ElasticsearchClient esClient = new ElasticsearchClient(transport);
//
//        return esClient;
//    }


}