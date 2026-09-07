FROM eclipse-temurin:8-jre-alpine
WORKDIR /app
COPY target/lab-reserve-server-1.0.0.jar app.jar
RUN addgroup -S labapp && adduser -S labapp -G labapp
USER labapp
EXPOSE 8080
ENTRYPOINT ["java","-XX:+UseContainerSupport","-jar","/app/app.jar","--spring.profiles.active=prod"]
