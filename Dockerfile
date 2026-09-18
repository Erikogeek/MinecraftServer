FROM eclipse-temurin:25-jre

WORKDIR /app

COPY . /app/

RUN chmod +x /app/entrypoint.sh
   
EXPOSE 25565

ENTRYPOINT [ "/bin/sh", "-c", "/app/entrypoint.sh"]