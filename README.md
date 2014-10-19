# Docker container for creating a chromedriver server

Includes

* ChromeDriver (Latest)
* Google Chrome (Latest Stable)

## Building the Docker Image

You can build the image by either building from GitHub or cloning the repository.

To build from GitHub:

```
docker build -t "robcherry/docker-chromedriver:latest" github.com/robcherry/docker-chromedriver
```

If you choose to clone the repository locally, `cd` in to the repository's root directory and run:

```
docker build -t "robcherry/docker-chromedriver:local" .
```

You can also pull the final built image from docker:

```
docker pull -t "robcherry/docker-chromedriver:latest" robcherry/docker-chromedriver
```

## Usage

The most basic usage is to run the container and expose the ChromeDriver port on all interfaces.

```
docker run --name chromedriver -P -d robcherry/docker-chromedriver:latest
```

If you want to restrict the ports to your local environment, you can do so using `-p`.

```
docker run --name chromedriver -p 127.0.0.1::4444 robcherry/docker-chromedriver:latest
```
