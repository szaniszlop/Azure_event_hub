package com.ps.azure.demo.eventhub;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.messaging.Message;

import reactor.core.publisher.Flux;
import reactor.core.publisher.Sinks;

import java.util.function.Consumer;
import java.util.function.Supplier;

@SpringBootApplication
public class EventhubApplication {
	private static final Logger LOGGER = LoggerFactory.getLogger(EventhubApplication.class);

	public static void main(String[] args) {
		SpringApplication.run(EventhubApplication.class, args);
	}

	@Bean
    public Sinks.Many<Message<String>> many() {
        return Sinks.many().unicast().onBackpressureBuffer();
    }

    @Bean
    public Supplier<Flux<Message<String>>> supply(Sinks.Many<Message<String>> many) {
        return () -> many.asFlux()
                         .doOnNext(m -> LOGGER.info("Manually sending message {}", m))
                         .doOnError(t -> LOGGER.error("Error encountered", t));
    }

    @Bean
    public Consumer<Message<String>> consume() {
        return message -> LOGGER.info("New message received: '{}'", message.getPayload());
    }	

}
