# RabbitMQ server 
Updated: Jul 28, 2016

# Overview
* This RabbitMQ dockerfile is from the official RabbitMQ distribution.
the startup script will generate admin password under the folder  /etc/rabbitmq/rabbitmq.config of the docker container.

# How to create docker container
sudo docker run --hostname mq.audacy.space --name rmq01 -d -v /mnt/mq/mq01/log01:/data/log -v /mnt/mq/mq01:/data/mnesia -p 15672:15672 -p 32769:25672 -p 4369:4369 -p 5672:5672 rayymlai/rabbitmq

