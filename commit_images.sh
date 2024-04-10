#!/bin/bash

# Путь до папки с изображениями в репозитории
DIR="/Users/golubev/web3/nft-generator/output"

# Количество файлов для одного коммита
CHUNK_SIZE=50

# Переменная для подсчета номера коммита
COMMIT_NUM=1

# Папка, откуда вызывается скрипт
CALLING_DIR=$(pwd)

# Создание функции для коммита
function commit_files {
  git add .
  git commit -m "Adding images batch $COMMIT_NUM"
  git push origin main
  ((COMMIT_NUM++))
}

# Подсчет количества PNG файлов в папке
FILE_COUNT=$(find "$DIR" -maxdepth 1 -name "*.png" | wc -l)

# Проходим по всем PNG файлам в папке
for file in "$DIR"/*.png; do
  # Перемещаем файл в папку, откуда вызывается скрипт
  mv "$file" "$CALLING_DIR/"
  ((CHUNK_SIZE--))
  # Если достигнуто количество файлов для коммита или это последний файл
  if [[ $CHUNK_SIZE -eq 0 ]] || [[ $FILE_COUNT -eq 1 ]]; then
    cd "$CALLING_DIR" || exit
    # Вызываем функцию для создания коммита
    commit_files
    CHUNK_SIZE=50  # Сбрасываем счетчик для нового набора файлов
  fi
  ((FILE_COUNT--))
done
