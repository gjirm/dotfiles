# Custom Ubuntu docker for testing

## Build and run

```shell
docker build --tag my-ubuntu .

docker run -it -d --name test-ubuntu my-ubuntu
```

## Access terminal with 256 colors

```shell
docker exec -it -e "TERM=xterm-256color" test-ubuntu zsh
```
