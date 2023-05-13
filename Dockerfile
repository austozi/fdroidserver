FROM debian:bookworm-slim
RUN apt-get update && \
  apt-get -y dist-upgrade && \
  apt-get -y install \
  android-sdk \
  fdroidserver
RUN mkdir -p /fdroid
WORKDIR /fdroid
ENTRYPOINT ["fdroid"]
