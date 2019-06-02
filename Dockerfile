FROM maven:3.6-jdk-8-slim AS maven

ADD . $MAVEN_HOME

RUN cd $MAVEN_HOME \
 && mvn -B clean package \
 && cp $MAVEN_HOME/skos-viewer/target/skos-viewer-*.jar /skos-viewer.jar


FROM openjdk:8u201-jre-alpine3.9

COPY --from=maven /skos-viewer.jar /skos-viewer.jar

VOLUME /src

WORKDIR /src

ENTRYPOINT ["java", "-jar", "/skos-viewer.jar"]
