FROM openjdk:11-jdk

WORKDIR /app

COPY target/retrohit-1.0-SNAPSHOT.jar /app/retrohit.jar

ENTRYPOINT ["java", "-jar", "retrohit.jar"]

EXPOSE 8081
