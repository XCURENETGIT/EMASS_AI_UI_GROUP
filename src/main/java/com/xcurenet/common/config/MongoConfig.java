package com.xcurenet.common.config;

import com.mongodb.ConnectionString;
import com.mongodb.MongoClientSettings;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.mapping.context.MappingContext;
import org.springframework.data.mongodb.MongoDatabaseFactory;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.ReactiveMongoTemplate;
import org.springframework.data.mongodb.core.SimpleMongoClientDatabaseFactory;
import org.springframework.data.mongodb.core.convert.DbRefResolver;
import org.springframework.data.mongodb.core.convert.DefaultDbRefResolver;
import org.springframework.data.mongodb.core.convert.DefaultMongoTypeMapper;
import org.springframework.data.mongodb.core.convert.MappingMongoConverter;
import org.springframework.data.mongodb.core.mapping.MongoMappingContext;
import org.springframework.data.mongodb.core.mapping.MongoPersistentEntity;
import org.springframework.data.mongodb.core.mapping.MongoPersistentProperty;

@Configuration
public class MongoConfig {

	@Value("${spring.datasource.mongodb.uri}")
	private String mongoUri;

	@Bean
	public MongoClient mongoClient() {
		ConnectionString connectionString = new ConnectionString(mongoUri);
		MongoClientSettings settings = MongoClientSettings.builder()
				.applyConnectionString(connectionString)
				.build();
		return MongoClients.create(settings);
	}

	@Bean
	public MongoDatabaseFactory mongoDbFactory(@Autowired MongoClient mongoClient) {
		return new SimpleMongoClientDatabaseFactory(mongoClient, "venus");
	}

	@Bean
	public MongoMappingContext mongoMappingContext() {
		MongoMappingContext context = new MongoMappingContext();
		context.setAutoIndexCreation(true); // Enable automatic index creation
		return context;
	}

	@Bean
	public MappingMongoConverter mappingMongoConverter(@Autowired MongoDatabaseFactory factory, @Autowired MongoMappingContext context) {
		DbRefResolver dbRefResolver = new DefaultDbRefResolver(factory);
		MappingMongoConverter converter = new MappingMongoConverter(dbRefResolver, context);
		converter.setTypeMapper(new DefaultMongoTypeMapper(null)); // Prevent _class field from being added
		return converter;
	}

	@Bean
	public MongoTemplate mongoTemplate(@Autowired MongoDatabaseFactory mongoDbFactory, @Autowired MappingMongoConverter converter) {
		return new MongoTemplate(mongoDbFactory, converter);
	}
}

