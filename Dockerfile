FROM eclipse-temurin:latest
WORKDIR /home/ubuntu/java-app
COPY . /home/ubuntu/java-app
RUN javac aplicacion.java
CMD ["java", "aplicacion"]
