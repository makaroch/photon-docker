FROM eclipse-temurin:21-jre

# Установка зависимостей
RUN apt-get update && apt-get install -y wget zstd && rm -rf /var/lib/apt/lists/*

WORKDIR /photon

# Скачиваем Photon
ENV PHOTON_VERSION=0.7.0
RUN wget -q https://github.com/komoot/photon/releases/download/${PHOTON_VERSION}/photon-${PHOTON_VERSION}.jar -O /photon/photon.jar

# Переменные окружения
ENV JAVA_OPTS="-Xms1g -Xmx2g"
ENV PHOTON_PORT=2322
ENV PHOTON_DATA_DIR=/photon_data/es_data

# Копируем скрипт запуска
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

VOLUME ["/photon_data"]
EXPOSE 2322

ENTRYPOINT ["/entrypoint.sh"]
