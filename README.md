# Docker container for creating a ChromeDriver server

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
docker pull robcherry/docker-chromedriver:latest
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

***Note:*** ChromeDriver restricts access to local connections by default.  To allow external connections, you can pass in a custom `CHROMEDRIVER_WHITELISTED_IPS` environment variable.  By default, this is set to `127.0.0.1`, but this can by any comma separated list of IP addresses.  Setting the value as empty will allow all remote connections.

```
docker run --name chromedriver -p 127.0.0.1::4444 -e CHROMEDRIVER_WHITELISTED_IPS='' robcherry/docker-chromedriver:latest
```
