FROM ubuntu:14.04

# Distro's python3-pip is too old to understand environment markers in
# requirements.txt, therefore installing pip from PyPI too, using
# easy_install3 from python3-setuptools.

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get -y upgrade \
    && apt-get -y --no-install-recommends install \
        autoconf \
        automake \
        make \
        python3-setuptools \
        xvfb

# test/test-cmd-list.txt is a cache buster
ADD https://raw.githubusercontent.com/scop/bash-completion/master/test/test-cmd-list.txt \
    https://raw.githubusercontent.com/scop/bash-completion/master/test/requirements.txt \
    install-packages.sh \
    /tmp/

RUN easy_install3 --user pip==19.1.1 \
    && /root/.local/bin/pip install --user -Ir /tmp/requirements.txt \
    && echo '#!/bin/sh -e' >/usr/local/bin/pytest \
    && printf 'exec "%s/.local/bin/pytest" "$@"\n' "$HOME" \
        >>/usr/local/bin/pytest \
    && chmod +x /usr/local/bin/pytest

RUN /tmp/install-packages.sh \
    && rm -r /tmp/* /root/.cache/pip /var/lib/apt/lists/*
