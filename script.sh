#!/bin/bash
nohup /etc/alternatives/jre_11/bin/java -jar demo-0.0.1-SNAPSHOT.jar > nohup.out &
# Without this sleep, the Jenkins SSH Steps plugin closes the connection before the nohup can take over?
sleep 5
