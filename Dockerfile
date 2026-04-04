FROM nvidia/cuda:12.4.1-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.11 \
    python3.11-venv \
    python3-pip \
    git \
    curl \
    sudo \
    && rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1 \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3.11 1

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

ENV NVM_DIR=/home/vscode/.nvm
RUN mkdir -p $NVM_DIR && chown $USERNAME:$USERNAME $NVM_DIR
USER $USERNAME
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash && \
    . "$NVM_DIR/nvm.sh" && \
    nvm install 24
ENV PATH="/home/vscode/.nvm/versions/node/v24.14.1/bin:${PATH}"

# Install pokemon showdown
WORKDIR /home/vscode/pokemon-showdown
COPY ./pokemon-showdown /home/vscode/pokemon-showdown
COPY ./pokemon-showdown/config/config-example.js /home/vscode/pokemon-showdown/config/config.js
RUN node build 

# Install python dependencies
WORKDIR /temp
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

WORKDIR /app
CMD ["bash"]
