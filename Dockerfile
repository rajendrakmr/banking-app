####################################################
# Author: Rajendra
# Date: 12/07/2025
# Dockerfile for containerizing the Banking App.
####################################################

#-----------------------------
# Stage 1 - Build
#-----------------------------
FROM maven:3.8.3-openjdk-17 AS builder

LABEL maintainer="Rajendra <cloudwithrk@gmail.com>"
LABEL app="bankapp"

# Set working directory for build
WORKDIR /src

# Copy source code to the build container
COPY . .

# Build the application and skip tests case
RUN mvn clean install -DskipTests=true

#-----------------------------
# Stage 2 - Runtime
#-----------------------------
FROM openjdk:17-alpine AS deployer

LABEL maintainer="Rajendra <cloudwithrk@gmail.com>"
LABEL app="bankapp"

# Set working directory for runtime
WORKDIR /app

# Copy the built jar from the builder stage to the runtime image
COPY --from=builder /src/target/*.jar ./bankapp.jar

# Expose application port
EXPOSE 8080

# Command to run the application
CMD ["java", "-jar", "bankapp.jar"]
