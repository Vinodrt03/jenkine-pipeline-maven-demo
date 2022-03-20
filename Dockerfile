FROM maven:3.5.4-jdk-8-alpine as maven
COPY ./pom.xml ./pom.xml
COPY ./src ./src
RUN mvn dependency:go-offline -B
RUN mvn package
FROM openjdk:8u171-jre-alpine
WORKDIR /usr/local
COPY --from=maven target /usr/local/simple-java-maven-app-*.jar ./usr/local/simple-java-maven-app.jar
CMD ["java", "-jar", "./usr/local/simple-java-maven-app.jar"]
