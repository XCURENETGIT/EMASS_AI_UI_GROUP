package com.xcurenet.common.util;

import lombok.extern.log4j.Log4j2;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.support.SendResult;
import org.springframework.stereotype.Service;
import org.springframework.util.concurrent.ListenableFuture;

import javax.annotation.Resource;
import java.util.concurrent.TimeUnit;

@Log4j2
@Service
public class KafkaProducerService {
    @Resource
    private KafkaTemplate<String, String> kafkaTemplate;

    public void send(final String topic, final String key, final String message) {
        this.kafkaTemplate.send(topic, key, message);
    }

    public void sendDebug(final String topic, final String key, final String message) {
        ListenableFuture<SendResult<String, String>> future = this.kafkaTemplate.send(topic, key, message);
        try {
            SendResult<String, String> sendResult = future.get(10, TimeUnit.SECONDS);
            log.info("sendResult:{}", sendResult);
        } catch (Exception e) {
            log.error("", e);
            Thread.currentThread().interrupt();
        }
    }

}
