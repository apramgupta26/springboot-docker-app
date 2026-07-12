# Stage 1: Build the application
FROM maven:3.9.9-eclipse-temurin-17 AS builder

WORKDIR /app

# Copy pom.xml and download dependencies
COPY pom.xml .
COPY .mvn .mvn
COPY mvnw .
COPY mvnw.cmd .

RUN chmod +x mvnw
RUN ./mvnw dependency:go-offline

# Copy source code
COPY src ./src

# Build the application
RUN ./mvnw clean package -DskipTests

# Stage 2: Runtime image with Nginx
FROM nginx:alpine

RUN apk add --no-cache openjdk17-jre

WORKDIR /app

COPY --from=builder /app/target/*.jar app.jar

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD sh -c "java -jar app.jar & nginx -g 'daemon off;'"