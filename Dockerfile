FROM openjdk:11-jdk

WORKDIR /app
COPY target/retrohit.jar /app/retrohit.jar

ENTRYPOINT ["java", "-jar", "retrohit.jar"]

EXPOSE 8081
