# Note: You can use any Debian/Ubuntu based image you want. 
# [Choice] Ubuntu version: bionic, focal
ARG VARIANT="focal"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

# [Option] Install zsh
ARG INSTALL_ZSH="true"
# [Option] Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="false"
# [Option] Enable non-root Docker access in container
ARG ENABLE_NONROOT_DOCKER="true"

# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
ARG SOURCE_SOCKET=/var/run/docker-host.sock
ARG TARGET_SOCKET=/var/run/docker.sock
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
COPY library-scripts/*.sh /tmp/library-scripts/
RUN apt-get update \
    && /bin/bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" \
    # Use Docker script from script library to set things up
    && /bin/bash /tmp/library-scripts/docker-debian.sh "${ENABLE_NONROOT_DOCKER}" "${SOURCE_SOCKET}" "${TARGET_SOCKET}" "${USERNAME}" \
    # Clean up
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts/

# Setting the ENTRYPOINT to docker-init.sh will configure non-root access to 
# the Docker socket if "overrideCommand": false is set in devcontainer.json. 
# The script will also execute CMD if you need to alter startup behaviors.
ENTRYPOINT [ "/usr/local/share/docker-init.sh" ]
CMD [ "sleep", "infinity" ]

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && apt-get -y install --no-install-recommends build-essential entr dos2unix apt-transport-https gnupg2 curl && \
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list && \
    sudo apt-get update && \
    sudo apt-get install -y kubectl \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts/

COPY --from=digitalocean/doctl:latest /app/doctl /usr/local/bin/doctl
#linkerd cli
RUN curl -sL https://run.linkerd.io/install | sh
ENV PATH=$PATH:$HOME/.linkerd2/bin


##kind
#RUN export DEBIAN_FRONTEND=noninteractive && sudo apt-get update && apt-get -y install --no-install-recommends golang && \
#    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts/
#RUN go env -w GOPATH=/usr/local/go
#RUN export PATH=$PATH:/usr/local/go/bin
#ENV GO111MODULE="on"
#RUN go get sigs.k8s.io/kind@v0.9.0 
#USER vscode
#ENV PATH=$PATH:/usr/local/go/bin



###lighthouselab ###
#using apt-get
USER root
SHELL ["/bin/bash", "-o", "pipefail", "-l", "-c"]
RUN apt-get update && \
    apt-get -y install --no-install-recommends \
    build-essential \
    entr \
    dos2unix \
    apt-transport-https \
    gnupg2 \
    curl \
    locales \
    mongodb && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* /tmp/library-scripts/ && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8
#install kubectl from upstream
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
    apt-get update && \
    apt-get install -y kubectl && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* /tmp/library-scripts/
#install doctl from upstream
COPY --from=digitalocean/doctl:latest /app/doctl /usr/local/bin/doctl
#install kompose from upstream
RUN curl -L https://github.com/kubernetes/kompose/releases/download/latest/kompose-linux-amd64 -o kompose && \
    chmod +x kompose && \
    mv ./kompose /usr/local/bin/kompose
##install nvm(node version manager) from upstream
USER vscode
ENV NVM_DIR /usr/local/nvm
USER root
RUN mkdir /usr/local/nvm
RUN chown vscode:vscode -R "${NVM_DIR}"
USER vscode
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.1/install.sh | bash
USER root
##install latest lts node
USER vscode
RUN nvm install --lts
USER root
##install other versions
USER vscode
RUN nvm install 8
RUN nvm install 10
RUN nvm install 12
RUN nvm install 14
RUN nvm install node
##use latest lts node
RUN nvm use --lts
RUN nvm alias default lts/*
USER root
#update npm
USER vscode
RUN npm install npm@latest -g
USER root
#install yarn v1
USER vscode
RUN npm install --global yarn
USER root
#install node-gyp
USER vscode
RUN npm install -g node-gyp
USER root
RUN apt-get update && \
    apt-get -y install --no-install-recommends \
    python3 && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* /tmp/library-scripts/
####install rvm(ruby version manager) from upstream
USER vscode
RUN gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
RUN curl -sSL https://get.rvm.io | bash -s stable
RUN echo "source $HOME/.rvm/scripts/rvm" >> ~/.bash_profile
RUN echo "source $HOME/.rvm/scripts/rvm" >> ~/.bashrc
USER root
#Install ruby
USER vscode
RUN rvm install ruby
RUN rvm install ruby-2.7
RUN rvm use --default ruby
USER root


# Setting the ENTRYPOINT to docker-init.sh will configure non-root access to 
# the Docker socket if "overrideCommand": false is set in devcontainer.json. 
# The script will also execute CMD if you need to alter startup behaviors.
SHELL ["/bin/bash", "-o", "pipefail", "-l", "-c"]
ENTRYPOINT [ "/usr/local/share/docker-init.sh" ]
CMD [ "sleep", "infinity" ]
USER vscode


##for prep for lighthouselabs
RUN npm i -g javascripting 
RUN npm i -g webpack webpack-cli webpack-dev-server webpack-dev-middleware