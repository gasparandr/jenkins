#!/bin/bash


echo "***** Validating arguments *****"


SERVICE="scrumbs_mongo"
DB_NAME="scrumbs-app"
BACKUP_PATH="./backup"

echo "********* Getting container ID *********"

CONTAINER_ID=$(for f in $(docker service ps -q --filter desired-state=running $SERVICE); do docker inspect --format '{{.Status.ContainerStatus.ContainerID}}' $f; done)

echo "Container id is: $CONTAINER_ID"

DATE_AND_TIME=$(date '+%d-%m-%Y-%H:%M:%S')

echo "********* Executing mongo dump *********"

docker exec $CONTAINER_ID mongodump -d $DB_NAME


echo "******** Backing up data to $BACKUP_PATH/$DB_NAME/$DATE_AND_TIME ********"

OUTDIR=$BACKUP_PATH/$DB_NAME/$DATE_AND_TIME

mkdir -p $OUTDIR

docker cp $CONTAINER_ID:dump/$DB_NAME/. $OUTDIR

echo "******** Success, backup completed. *********"
