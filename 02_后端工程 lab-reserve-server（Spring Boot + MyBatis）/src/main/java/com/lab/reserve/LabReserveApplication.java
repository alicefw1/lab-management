package com.lab.reserve;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.lab.reserve.mapper")
public class LabReserveApplication {
    public static void main(String[] args) {
        SpringApplication.run(LabReserveApplication.class, args);
    }
}
