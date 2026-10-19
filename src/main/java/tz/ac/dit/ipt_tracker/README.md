# IPT Tracker

IPT Tracker is a Spring Boot application developed as part of a project to manage and track Industrial Practical Training (IPT) activities.

## Technologies Used

- Java 21
- Spring Boot
- Maven
- PostgreSQL
- Spring Data JPA
- Flyway Database Migrations
- Bean Validation
- Spring Boot Actuator

## Prerequisites

Before running the application, ensure you have installed:

- JDK 21
- Git
- PostgreSQL, or Docker to run PostgreSQL
- Maven Wrapper included in this repository

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/evaristolikiliwike-ctrl/ipt-tracker.git
cd ipt-tracker
```

### 2. Configure the Database

Create a PostgreSQL database named `ipt_tracker` and configure the database connection using environment variables.

The default database connection URL configured by the application is:

```text
jdbc:postgresql://localhost:5433/ipt_tracker
```

Configure these environment variables before starting the application:

| Variable | Purpose |
|---|---|
| `DB_URL` | PostgreSQL connection URL |
| `DB_USERNAME` | PostgreSQL username |
| `DB_PASSWORD` | PostgreSQL password |
| `JWT_SECRET` | Base64-encoded secret used for JWT signing |
| `JWT_EXPIRATION_SECONDS` | JWT expiration time in seconds |

Use a strong, private JWT secret that satisfies the application's security requirements. Do not commit real passwords or secrets to GitHub.

### 3. Run the Application

On Windows PowerShell:

```powershell
.\mvnw.cmd spring-boot:run
```

On Linux or macOS:

```bash
./mvnw spring-boot:run
```

The application is configured to use port `8081` by default.

### 4. Run Tests

On Windows:

```powershell
.\mvnw.cmd test
```

On Linux or macOS:

```bash
./mvnw test
```

### 5. API Documentation and Health Check

When the application is running, the following endpoints may be used to inspect the API and application health, subject to the application's configuration:

- Swagger UI: `http://localhost:8081/swagger-ui.html`
- OpenAPI specification: `http://localhost:8081/v3/api-docs`
- Health check: `http://localhost:8081/actuator/health`

## Database Migrations

Flyway is configured to manage database migrations stored under:

```text
src/main/resources/db/migration
```

Hibernate schema validation is enabled, so the database schema must match the application's entity mappings and migrations.

## Project Structure

```text
ipt-tracker/
├── src/
│   ├── main/
│   │   ├── java/
│   │   └── resources/
│   │       └── db/
│   │           └── migration/
│   └── test/
├── .gitignore
├── mvnw
├── mvnw.cmd
├── pom.xml
└── README.md
```

## Contributing

1. Create a branch for your changes.
2. Make and test your changes.
3. Commit your changes with a descriptive message.
4. Push your branch to GitHub and open a pull request if required.

## License

No license has been specified yet.