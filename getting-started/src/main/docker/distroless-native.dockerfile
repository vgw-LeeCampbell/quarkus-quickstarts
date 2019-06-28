## Stage 1 : build with maven builder image with native capabilities
FROM quay.io/quarkus/centos-quarkus-maven:19.0.2 AS build

COPY src /usr/src/app/src
USER root
RUN mkdir -p /usr/src/app/target
COPY pom.xml /usr/src/app
RUN mvn -f /usr/src/app/pom.xml -Pnative clean package

## Stage 2 : create the docker final image
FROM cescoffier/native-base:latest
COPY --from=build /usr/src/app/target/*-runner /application
EXPOSE 8080
CMD ["./application", "-Dquarkus.http.host=0.0.0.0"]