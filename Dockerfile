# Use an OpenJDK runtime as the base image
FROM eclipse-temurin:17-jdk-jammy

# The JAR file built by Maven will be in the 'target' folder
# Change 'demo-0.0.1-SNAPSHOT.jar' to match your actual JAR name if different
COPY target/*.jar app.jar

# Run the application
ENTRYPOINT ["java", "-jar", "/app.jar"]