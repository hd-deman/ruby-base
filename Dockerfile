FROM ruby:3.1.2-slim

RUN \
    apt-get update && \
    apt-get install -y \
    curl git gcc g++ make clang cmake \
    ## For PostgreSQL gems
    libpq-dev postgresql-client \
    # For imagemagik
    imagemagick libmagickcore-dev libmagickwand-dev \
    ## For Chrome (PDF)
    libnss3 libatk-bridge2.0-0 libcups2 libdrm2 \
    libxkbcommon-x11-0 libxcomposite1 libxdamage1 libxfixes3 libxrandr2 libgbm1 libasound2 screen && \
    apt-get clean && rm -rf /tmp/* /var/tmp/*

RUN \
    curl https://storage.yandexcloud.net/deployment-assets.yasno.live/min.io/mc.$MINIO_MC_RELEASE -o /usr/local/bin/mc && \
    chmod +x /usr/local/bin/mc

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
# install yarn
RUN apt-get install -y nodejs && npm i -g yarn
