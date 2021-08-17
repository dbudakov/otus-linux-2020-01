#! /bin/bash

# ID упавшего узла
FAILED_NODE=$1
# IP нового мастера
NEW_MASTER=$2
# Путь к триггерному файлу
TRIGGER_FILE=$3

if [ $FAILED_NODE = 1 ];
then
	echo "Ведомый сервер вышел из строя"
	exit 1
fi

echo "Ведущий сервер вышел из строя"
echo "Новый ведущий сервер: $NEW_MASTER"

ssh -T postgres@$NEW_MASTER touch $TRIGGER_FILE
exit 0
