# FROM ubuntu
### for Mac M1
FROM arm64v8/ubuntu

# prepare a user which runs everything locally! - required in child images!
RUN useradd --user-group --create-home --shell /bin/false app

ENV HOME=/home/app
WORKDIR $HOME

ENV DEBIAN_FRONTEND="noninteractive"
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    wget \
    context \
    && rm -rf /var/lib/apt/lists/*

# RUN wget https://github.com/jgm/pandoc/releases/download/2.2.1/pandoc-2.2.1-1-amd64.deb
# RUN dpkg -i pandoc-2.2.1-1-amd64.deb  && rm pandoc-*.deb
### for Mac M1
RUN wget https://github.com/jgm/pandoc/releases/download/3.1.1/pandoc-3.1.1-1-arm64.deb
RUN dpkg -i pandoc-3.1.1-1-arm64.deb  && rm pandoc-*.deb

#Cleanup to reduce container size
RUN apt-get remove -y wget && \ 
    apt-get autoclean && \
    apt-get clean

ENV APP_NAME=resume

# before switching to user we need to set permission properly
# copy all files, except the ignored files from .dockerignore
COPY . $HOME/$APP_NAME/
COPY ./Makefile $HOME/$APP_NAME/
RUN chown -R app:app $HOME/*

USER app
WORKDIR $HOME/$APP_NAME

