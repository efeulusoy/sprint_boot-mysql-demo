FROM openjdk:11
VOLUME /tmp
ADD target/users_demo_backend-0.0.1-SNAPSHOT.jar users_demo_backend-0.0.1-SNAPSHOT.jar
ENTRYPOINT ["java", "-jar", "users_demo_backend-0.0.1-SNAPSHOT.jar"]

