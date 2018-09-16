FROM haskell:8

RUN git clone https://github.com/facebook/duckling.git

WORKDIR /duckling

RUN git checkout tags/v0.1.6.1

RUN apt-get update && apt-get install -qq -y --fix-missing --no-install-recommends \
    libpcre3-dev \    
    build-essential

RUN stack setup

RUN stack build --copy-bins --local-bin-path /usr/local/bin

FROM debian:stretch-slim

RUN apt-get update && apt-get install -y \
   libpcre3 \
   zlib1g \
   libgmp10 \
   tzdata

COPY --from=0 /usr/local/bin/duckling-example-exe /usr/local/bin/duckling

# NOTE: very important, otherwise PCRE fails for whatever reason
ENV LANG C.UTF-8

CMD exec duckling

EXPOSE 8000
