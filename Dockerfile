FROM debian:wheezy
MAINTAINER Rob Cherry

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

# Set timezone
ENV TZ "US/Eastern"
RUN echo $TZ > /etc/timezone && \
    dpkg-reconfigure --frontend noninteractive tzdata

# Create a default user
RUN useradd automation --shell /bin/bash --create-home

# Update the repositories
# Upgrade packages
# Install utilities
# Install XVFB
# Install fonts
# Install Fluxbox (window manager)
# Install Python
RUN apt-get -yqq update && \
    apt-get -yqq upgrade && \
    apt-get -yqq install curl unzip && \
    apt-get -yqq install xvfb && \
    apt-get -yqq install fonts-ipafont-gothic xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic && \
    apt-get -yqq install fluxbox && \
    apt-get -yqq install python && \
    rm -rf /var/lib/apt/lists/*

# Install Supervisor
RUN curl -sS -o - https://bootstrap.pypa.io/ez_setup.py | python && \
    easy_install -q supervisor

# Install Chrome WebDriver
RUN CHROMEDRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
    mkdir -p /opt/chromedriver-$CHROMEDRIVER_VERSION && \
    curl -sS -o /tmp/chromedriver_linux64.zip http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip && \
    unzip -qq /tmp/chromedriver_linux64.zip -d /opt/chromedriver-$CHROMEDRIVER_VERSION && \
    rm /tmp/chromedriver_linux64.zip && \
    chmod +x /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver && \
    ln -fs /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver /usr/local/bin/chromedriver    

# Install Google Chrome
RUN curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    apt-get -yqq update && \
    apt-get -yqq install google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*

# Disable the SUID sandbox so that Chrome can launch without being in a privileged container.
# One unfortunate side effect is that `google-chrome --help` will no longer work.
RUN dpkg-divert --add --rename --divert /opt/google/chrome/google-chrome.real /opt/google/chrome/google-chrome && \
    echo "#!/bin/bash\nexec /opt/google/chrome/google-chrome.real --disable-setuid-sandbox \"\$@\"" > /opt/google/chrome/google-chrome && \
    chmod 755 /opt/google/chrome/google-chrome

# Configure Supervisor 
ADD ./etc/supervisor /etc/supervisor

# Default configuration
ENV DISPLAY :20.0
ENV SCREEN_GEOMETRY "1440x900x24"
ENV CHROMEDRIVER_PORT 4444

EXPOSE 4444

VOLUME [ "/var/log/supervisor" ]

CMD ["/usr/local/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
