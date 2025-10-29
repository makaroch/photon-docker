#!/bin/bash
set -euo pipefail

echo "Запуск Photon..."

if [ ! -d "$PHOTON_DATA_DIR" ]; then
  echo "➡️ Импортируем данные OpenStreetMap..."
  mkdir -p "$PHOTON_DATA_DIR"
  cd /photon_data

  DUMP_URL="https://download1.graphhopper.com/public/europe/austria/photon-dump-austria-0.7-latest.jsonl.zst"
  wget -q -O photon-dump.jsonl.zst "$DUMP_URL"

  echo "Распаковка дампа..."

  zstd --stdout -d photon-dump.jsonl.zst \
    | java $JAVA_OPTS -jar /photon/photon.jar \
        -data-dir "$PHOTON_DATA_DIR" \
        -nominatim-import \
        -languages en,de,fr,ru,local \
        -import-file -

  echo "Импорт завершён!"
else
  echo "Данные уже импортированы — пропуск загрузки."
fi

echo "Запуск сервера Photon..."

exec java $JAVA_OPTS -jar /photon/photon.jar \
  -data-dir "$PHOTON_DATA_DIR" \
  -listen-ip 0.0.0.0 \
  -listen-port $PHOTON_PORT
