FROM docker.io/ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
    apt-get install -y curl locales sudo && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m -U code
RUN echo "code ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
RUN dpkg-reconfigure --frontend=noninteractive locales && update-locale LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LOCALE_ARCHIVE=/usr/lib/locale/locale-archive

RUN curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
  sh -s -- install linux \
  --extra-conf "sandbox = false" \
  --extra-conf "filter-syscalls = false" \
  --init none \
  --no-confirm
ENV PATH="${PATH}:/nix/var/nix/profiles/default/bin"

# create non-root user and group and add it sudoers
ARG USERNAME=code
ARG USER_UID=1000
ARG USER_GID=${USER_UID}

USER ${USERNAME}
ENV USER=${USERNAME}

# In theory, this should not be necessary. We should be able to run home-manager
# below with sudo and have it populate our home directory. However, this appear
# to be broken.
RUN sudo chown -R ${USERNAME}: /nix

WORKDIR /home/${USERNAME}
COPY --chown=${USERNAME} ./dots dots

RUN nix run home-manager/release-24.05 -- switch --flake /home/${USERNAME}/dots#${USERNAME}

CMD ${HOME}/.nix-profile/bin/zsh -l
