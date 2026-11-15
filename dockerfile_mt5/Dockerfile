#FROM ghcr.io/linuxserver/baseimage-kasmvnc:amd64-debianbullseye-8446af38-ls104
FROM  ghcr.io/linuxserver/baseimage-kasmvnc:amd64-debianbookworm

# set version label
ARG BUILD_DATE
ARG VERSION
# A new Wine version upgrades the /config/.wine prefix on the next start and blocks it on a
# GUI dialog (Wine Mono), so pin the version that is known to work with this prefix.
ARG WINE_VERSION=11.0.0.0~bookworm-1
LABEL build_version="Metatrader Docker:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="gmartin"

ENV TITLE=Metatrader5
ENV WINEPREFIX="/config/.wine"

# Update package lists and upgrade packages
RUN apt-get update && apt-get install -y \
    python3-pip \
    wget \
    vim \
    curl \
    git \
    pipx \
    software-properties-common \
    gnupg2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

#RUN pip3 install --upgrade pip

# Add WineHQ repository key and APT source
# && add-apt-repository 'deb https://dl.winehq.org/wine-builds/debian/ bullseye main' \
# apt-key is deprecated: pin the WineHQ key to its own repository with signed-by.
RUN mkdir -p /etc/apt/keyrings \
    && wget -qO- https://dl.winehq.org/wine-builds/winehq.key | gpg --dearmor -o /etc/apt/keyrings/winehq-archive.key \
    && echo "deb [arch=amd64,i386 signed-by=/etc/apt/keyrings/winehq-archive.key] https://dl.winehq.org/wine-builds/debian/ bookworm main" \
        > /etc/apt/sources.list.d/winehq.list

# Add i386 architecture and update package lists
RUN dpkg --add-architecture i386 \
    && apt-get update

# Install WineHQ stable package and dependencies
RUN apt-get install --install-recommends -y \
    winehq-stable=${WINE_VERSION} \
    wine-stable=${WINE_VERSION} \
    wine-stable-amd64=${WINE_VERSION} \
    wine-stable-i386=${WINE_VERSION} \
    winetricks \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY /Metatrader /Metatrader
RUN chmod +x /Metatrader/start.sh
COPY /root /

#EXPOSE 3000 8001
#VOLUME /config
