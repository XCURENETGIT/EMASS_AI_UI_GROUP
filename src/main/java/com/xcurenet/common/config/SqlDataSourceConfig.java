package com.xcurenet.common.config;

import com.mongodb.ConnectionString;
import com.mongodb.MongoClientSettings;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.zaxxer.hikari.HikariDataSource;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.data.mongodb.MongoDatabaseFactory;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.ReactiveMongoTemplate;
import org.springframework.data.mongodb.core.SimpleMongoClientDatabaseFactory;
import org.springframework.data.mongodb.core.convert.DefaultMongoTypeMapper;
import org.springframework.data.mongodb.core.convert.MappingMongoConverter;
import org.springframework.data.mongodb.core.mapping.MongoMappingContext;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;

import javax.sql.DataSource;

@Configuration
public class SqlDataSourceConfig {
	private static final String MAPPER_PATH = "classpath:/com/xcurenet/sqlmap/mappers/mysql/*.xml";
	private static final String MYBATIS_CONFIG_PATH = "classpath:mybatis-config.xml";

	private final MongoMappingContext mongoMappingContext;
	public SqlDataSourceConfig(MongoMappingContext mongoMappingContext) {
		this.mongoMappingContext = mongoMappingContext;
	}

	@Value("${spring.datasource.mongodb.uri}")
	private String mongoUri;


	@Bean
	@Primary
	@ConfigurationProperties("spring.datasource.hikari")
	public DataSource basicDataSource() {
		return DataSourceBuilder.create().type(HikariDataSource.class).build();
	}

	@Bean
	@Primary
	public SqlSessionFactory basicSqlSessionFactory(@Autowired DataSource dataSource, ApplicationContext context) throws Exception {
		SqlSessionFactoryBean sqlSessionFactoryBean = new SqlSessionFactoryBean();
		sqlSessionFactoryBean.setDataSource(dataSource);
		sqlSessionFactoryBean.setMapperLocations(context.getResources(MAPPER_PATH));
		sqlSessionFactoryBean.setConfigLocation(context.getResource(MYBATIS_CONFIG_PATH));
		return sqlSessionFactoryBean.getObject();
	}

	@Bean
	@Primary
	public SqlSession basicSqlSession(@Autowired SqlSessionFactory factory) {
		return new SqlSessionTemplate(factory);
	}

	@Bean
	public PlatformTransactionManager txManager(@Autowired DataSource dataSource) throws Exception {
		return new DataSourceTransactionManager(dataSource);
	}

	@Bean
	@ConfigurationProperties("spring.datasource.mongodb")
	public MongoClient mongoDataSource() {
		ConnectionString con = new ConnectionString(mongoUri);
		MongoClientSettings mongClientSet = MongoClientSettings.builder().readPreference(com.mongodb.ReadPreference.primary()).applyConnectionString(con).build();
		return MongoClients.create(mongClientSet);
	}

	@Bean
	public MongoDatabaseFactory mongoDbFactory(@Autowired MongoClient mongoClient) {
		return new SimpleMongoClientDatabaseFactory(mongoClient, "venus");
	}

	@Bean
	public MongoTemplate mongoTemplate(@Autowired MongoDatabaseFactory mongoDatabaseFactory) {
		return new MongoTemplate(mongoDatabaseFactory);
	}

	// MongoMappingContext Bean
	@Bean
	public MongoMappingContext mongoMappingContext() {
		MongoMappingContext context = new MongoMappingContext();
		context.setAutoIndexCreation(true); // 자동 인덱스 생성 활성화
		return context;
	}

	@Bean
	public MappingMongoConverter reactiveMappingMongoConverter() {
		MappingMongoConverter converter = new MappingMongoConverter(ReactiveMongoTemplate.NO_OP_REF_RESOLVER,
				mongoMappingContext);

		converter.setTypeMapper(new DefaultMongoTypeMapper(null)); // mongo 내에 자동 저장되는 _class 삭제
		return converter;
	}
}