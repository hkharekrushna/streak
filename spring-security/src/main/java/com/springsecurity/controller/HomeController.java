package com.springsecurity.controller;

import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
public class HomeController {

    @GetMapping("/public/hello")
    public Map<String, String> publicHello() {
        return Map.of("message", "Hello, this is a public endpoint!");
    }

    @GetMapping("/home")
    public Map<String, String> home(Authentication authentication) {
        return Map.of(
            "message", "Welcome, " + authentication.getName() + "!",
            "roles", authentication.getAuthorities().toString()
        );
    }
}
