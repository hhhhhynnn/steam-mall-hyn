package com.steam;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;

@SpringBootApplication
@EnableCaching
public class SteamMallApplication {

    public static void main(String[] args) {
        SpringApplication.run(SteamMallApplication.class, args);
    }
}
