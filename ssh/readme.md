Readme.md
Updated: Feb 19, 2016

example how to create docker
sudo docker run --name gmat02 -d -p 8902:22 -p 8908:8080 -v /home/ray/dev/gmat:/opt/gmat -v /home/ray/dev/julia:/opt/julia rayymlai/ssh2
