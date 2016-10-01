FROM node:0.12

MAINTAINER Daniel E. Renfer <duck@kronkltd.net>

ENV APP_HOME /app
WORKDIR $APP_HOME

ARG user=pumpio
ARG group=pumpio
ARG uid=1000
ARG gid=1000

### Create docker group
RUN groupadd -g ${gid} ${group} \
    && useradd -u ${uid} -g ${gid} --create-home -s /bin/bash ${user}

### Install Sigil
ENV SIGIL_URL https://github.com/gliderlabs/sigil/releases/download/v0.4.0/sigil_0.4.0_Linux_x86_64.tgz
RUN set -ex \
    && wget -q $SIGIL_URL -O /tmp/sigil.tgz \
    && tar -zxv -C /usr/local/bin -f /tmp/sigil.tgz \
    && rm /tmp/sigil.tgz

RUN add-apt-repository ppa:ubuntu-toolchain-r/test \
    && apt-get update \
    && apt-get install -y \
       libstdc++6 \
       sudo

ADD test/hosts.sh $APP_HOME/test/hosts.sh
RUN test/hosts.sh

# RUN mkdir $APP_HOME
RUN chown -R ${uid}:${gid} ${APP_HOME}

USER $user

### Install Node Modules
ADD package.json $APP_HOME
ADD bin $APP_HOME/bin

RUN mkdir -p /app/node_modules
RUN ls -al /app/node_modules

RUN npm install
RUN npm install databank-mongodb

### Add Source
ADD . $APP_HOME

EXPOSE "8080"

CMD ["./bootstrap.sh"]
