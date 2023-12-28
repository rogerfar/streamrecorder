docker compose down
docker compose build
docker compose up -d

$containerName = (docker compose ps -q streamrecorder)

Write-Output "Connecting to $containerName"

docker exec -it $containerName /bin/sh

# vlc "https://icecast.omroep.nl/radio2-bb-mp3" vlc://quit --run-time=1 --play-and-exit --intf dummy --no-audio --sout="#std{access=file,mux=mp3,dst=/out/radio.mp3}"
# ./record.sh "https://icecast.omroep.nl/radio2-bb-mp3" /out/Radio2 Radio2 10