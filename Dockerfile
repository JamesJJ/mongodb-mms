ARG BASE_IMAGE=debian:buster-slim

FROM $BASE_IMAGE as base

ARG BASE_IMAGE

LABEL base_image=$BASE_IMAGE

LABEL owner_team OPS

ARG GIT_COMMIT

ENV GIT_COMMIT=$GIT_COMMIT

ENV TINI_VERSION=v0.18.0
ENV MMSUSER=mongodb
ENV APP_UID=1000
ENV APP_GID=1000
ENV DEBIAN_FRONTEND=noninteractive

RUN set -x \
    && addgroup --system --gid "${APP_GID}" "${MMSUSER}"  \
    && adduser --system --disabled-login --ingroup "${MMSUSER}"  --no-create-home --home /nonexistent --gecos "app user" --shell /bin/false --uid "${APP_UID}" "${MMSUSER}"  \
    && apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install --no-install-recommends --no-install-suggests -y \
      bash \
      bsdtar \
      curl \
      ca-certificates \
      gnupg1 \
      gosu \
      jq \
      lsof \
      net-tools \
      openssl \
      procps \
      screen \
      snmp \
      unzip \
      vim \
      libcurl4 \
      libgssapi-krb5-2 \
      libkrb5-dbg \
      libldap-2.4-2 \
      libpci3 \
      libwrap0 \
      libsasl2-2 \
      libsensors5 \
      liblzma5 \
  && curl -sSfL -o /usr/bin/tini "https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static" \
  && chmod 755 /usr/bin/tini

COPY ./bin /opt/bin

CMD ["tini","-g","--","bash","-c","/opt/bin/run.bash"]

