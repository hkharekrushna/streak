# Spring Security

A Spring Boot project demonstrating Spring Security configuration with in-memory authentication.

## Features

- Spring Boot 3.3.10
- Spring Security with form-based login
- In-memory user store with BCrypt password encoding
- Public and secured endpoints
- Role-based access control (USER, ADMIN)

## Getting Started

### Prerequisites

- Java 17+
- Maven 3.6+

### Run the application

```bash
cd spring-security
mvn spring-boot:run
```

The application starts on `http://localhost:8080`.

## Endpoints

| Endpoint         | Access      | Description                        |
|------------------|-------------|------------------------------------|
| `/public/hello`  | Public      | Returns a public greeting message  |
| `/login`         | Public      | Spring Security default login page |
| `/home`          | Authenticated | Returns a welcome message with user info |

## Default Users

| Username | Password  | Roles        |
|----------|-----------|--------------|
| user     | password  | USER         |
| admin    | admin123  | ADMIN, USER  |

## Project Structure

```
spring-security/
├── pom.xml
└── src/
    └── main/
        ├── java/
        │   └── com/springsecurity/
        │       ├── SpringSecurityApplication.java
        │       ├── config/
        │       │   └── SecurityConfig.java
        │       └── controller/
        │           └── HomeController.java
        └── resources/
            └── application.properties
```
