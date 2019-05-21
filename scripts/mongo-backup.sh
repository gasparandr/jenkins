#!/bin/bash

echo "***** Validating arguments *****"

if [ $# -eq 3 ]
    then
        echo "Number of arguments is valid."
    else
          echo "Invalid number of arguments provided!"
                echo "Expected: 3"
                echo "SERVICE"
                echo "DB_NAME"
                echo "BACKUP_PATH"
          echo "Provided: $#"
          exit 1
fi


SERVICE=$1
DB_NAME=$2
BACKUP_PATH=$3

echo "********* Getting container ID *********"

CONTAINER_ID=$(for f in $(docker service ps -q --filter desired-state=running $SERVICE); do docker inspect --format '{{.Status.ContainerStatus.ContainerID}}' $f; done)

echo "Container id is: $CONTAINER_ID"

DATE_AND_TIME=$(date '+%d-%m-%Y-%H:%M:%S')

echo "********* Executing mongo dump *********"

docker exec -it $CONTAINER_ID mongodump -d $DB_NAME


echo "******** Backing up data to $BACKUP_PATH/$DB_NAME/$DATE_AND_TIME ********"

OUTDIR=$BACKUP_PATH/$DB_NAME/$DATE_AND_TIME

mkdir -p $OUTDIR

docker cp $CONTAINER_ID:dump/$DB_NAME/. $OUTDIR

echo "******** Success, backup completed. *********"
