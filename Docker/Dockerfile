FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
        bash \
        sudo \
        ca-certificates \
        tmux \
        nload \
        iftop \
        htop \
        slurm-client \
        zip \
        unzip \
        p7zip-full \
        axel \
        wget \
        curl \
        git \
        net-tools \
        nmap \
        python3 \
        python3-pip \
        python-is-python3 \
        vim \
        nano \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash xerxes \
    && echo 'xerxes:P@ssw0rd' | chpasswd \
    && usermod -aG sudo xerxes \
    && echo 'xerxes ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/xerxes \
    && chmod 0440 /etc/sudoers.d/xerxes

USER xerxes
WORKDIR /home/xerxes

CMD ["/bin/bash"]
