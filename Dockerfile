# NetisDash SRTC (hm-dash) - Spring MVC WAR (Java 21, Jakarta, Tomcat 10.1, Maven 멀티모듈)
#
# DB 접속 정보는 WAR 안 hm-dash/src/main/resources/config/jdbc_maria.properties 를 그대로 쓴다
#   (환경변수로 바꾸는 경로 없음 — dataAccessContext.xml 이 PropertiesFactoryBean 으로 직접 읽음).
#
# 빌드 주의: hamon:metis, hamon:DelegateProtocol, com.hamon:KeyGenerator 는
#   레포 루트 repo/ (hm-dash/pom.xml 의 project-local 저장소)에서 받는다 — 사내 Nexus 접속 불필요.

# ---------- build stage ----------
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /build

COPY pom.xml ./
COPY repo repo
COPY hm-dash/pom.xml hm-dash/
COPY hm-dash/src hm-dash/src

# log.path 가 비어 있으면 파일 로그가 "/" 에 쓰이므로 컨테이너용 경로로 지정
RUN sed -i 's|^log.path=.*|log.path=/usr/local/tomcat/logs|' hm-dash/src/main/resources/config/system.properties \
 && mvn -B -DskipTests package \
 && cp hm-dash/target/hm-dash.war /build/ROOT.war

# ---------- runtime stage ----------
FROM tomcat:10.1-jre21-temurin-jammy

ENV TZ=Asia/Seoul \
    LANG=C.UTF-8 \
    CATALINA_OPTS="-Djava.awt.headless=true -Dfile.encoding=UTF-8 -Duser.timezone=Asia/Seoul"

# ping/traceroute: PingController 에서 사용, fontconfig: JFreeChart/POI 헤드리스 렌더링
RUN apt-get update \
 && apt-get install -y --no-install-recommends iputils-ping traceroute fontconfig \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /usr/local/tomcat/webapps/* /usr/local/tomcat/webapps.dist \
 && groupadd -r netis && useradd -r -g netis -d /usr/local/tomcat -s /usr/sbin/nologin netis \
 && chown -R netis:netis /usr/local/tomcat

# 컨텍스트 경로 "/" (cargo 설정과 동일)
COPY --chown=netis:netis --from=build /build/ROOT.war /usr/local/tomcat/webapps/ROOT.war

USER netis

EXPOSE 8080

CMD ["catalina.sh", "run"]
