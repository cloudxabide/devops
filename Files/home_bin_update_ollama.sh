#!/bin/bash

docker exec -it $(docker ps -a | grep "open-webui:ollama" | awk '{print $1}') bash -c 'for MODEL in $(ollama list | awk "{print \$1}"); do ollama pull $MODEL; done'

for IMAGE in $(docker images | awk '{ print $1 }'); do docker pull "$IMAGE"; done

exit

# Other exampes
docker exec -it $(docker ps -a | grep "open-webui:ollama" | awk '{print $1}') bash -c "for MODEL in \$(ollama list | awk '{print \$1}'); do ollama pull \$MODEL; done"

docker exec -it $(docker ps -a | grep "open-webui:ollama" | awk '{ print $1 }') /bin/bash
for MODEL in $(ollama list | awk '{ print $1 }'); do ollama pull $MODEL; done
exit
