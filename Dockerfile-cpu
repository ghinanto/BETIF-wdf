FROM ghcr.io/betif-difaet/jlab:betif-alma9-cpu-v0.1.0
ARG HOST_UID

#RUN export ENV_ROOT="/opt/conda"

USER root
COPY ./scripts/* .
RUN ./install-dependencies.sh
#RUN ./install-FrameLib.sh
ENV ENV_ROOT="/opt/conda"
#ENV LD_LIBRARY_PATH=$ENV_ROOT/lib:$LD_LIBRARY_PATH
RUN /sbin/ldconfig
RUN ./install-pytsa.sh
RUN /sbin/ldconfig
RUN ./install-wdf.sh
RUN ./install-additionals.sh

## Create a user with the same UID as the host user
RUN useradd -m -u $HOST_UID gwuser
## Create app directory and set ownership
#RUN mkdir -p /app/data && chown -R gwuser:gwuser /app
RUN chown -R gwuser:gwuser /opt/workspace
## Set working directory
WORKDIR /opt/workspace

## Switch to appuser
USER gwuser


