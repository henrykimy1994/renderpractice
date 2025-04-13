FROM eclipse-temurin:17-jdk as build
WORKDIR /workspace/app

# Copy Maven or Gradle files
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
# If using Gradle, uncomment these instead
# COPY gradlew .
# COPY gradle gradle
# COPY build.gradle .
# COPY settings.gradle .

# Copy source code
COPY src src

# Build the application
RUN ./mvnw package -DskipTests
# If using Gradle, uncomment this instead
# RUN chmod +x ./gradlew && ./gradlew build -x test

# Create the runtime image
FROM eclipse-temurin:17-jre
WORKDIR /app
# Copy the jar file from the build stage
COPY --from=build /workspace/app/target/*.jar app.jar
# If using Gradle, uncomment this instead
# COPY --from=build /workspace/app/build/libs/*.jar app.jar

# Set environment variables
ENV PORT=8080

# Expose the port
EXPOSE ${PORT}

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]