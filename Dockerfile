ARG DOCKER_REGISTRY=docker.io
ARG FROM_IMG_REPO=qnib
ARG FROM_IMG_NAME="uplain-init"
ARG FROM_IMG_TAG="xenial_2018-12-08.1"
ARG FROM_IMG_HASH=""
FROM ${DOCKER_REGISTRY}/${FROM_IMG_REPO}/${FROM_IMG_NAME}:${FROM_IMG_TAG}${DOCKER_IMG_HASH}
ENV DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true
RUN useradd -m -r user
RUN apt-get update \
 && apt-get install -y wget python python-setuptools git gcc libssl-dev unzip
RUN apt-get install -y lmod
ENV PATH=/usr/share/lmod/5.8/libexec:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN mkdir -p /usr/local/src/easybuild/ \
 && wget -qO- https://github.com/easybuilders/easybuild-framework/archive/easybuild-framework-v3.6.2.tar.gz |tar xfz - -C /usr/local/src/easybuild/ --strip-component=1
RUN apt-get install -y python-pip
USER user
WORKDIR /home/user/
RUN cd /usr/local/src/easybuild/ \
 && pip install --install-option "--prefix=${EASYBUILD_PREFIX}" .
ENV PATH=/usr/local/src/easybuild:/usr/share/lmod/5.8/libexec:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    MODULEPATH=/home/user/.local/easybuild/modules/all \
    LOADEDMODULES=EasyBuild/3.7.1 \
    EBROOTEASYBUILD=${EASYBUILD_PREFIX}/easybuild/software/EasyBuild/3.7.1 \
    EBDEVELEASYBUILD=${EASYBUILD_PREFIX}/easybuild/software/EasyBuild/3.7.1/easybuild/EasyBuild-3.7.1-easybuild-devel \
    LESSCLOSE="/usr/bin/lesspipe %s %s" \
    EBVERSIONEASYBUILD=3.7.1 \
    PYTHONPATH=${EASYBUILD_PREFIX}/easybuild/software/EasyBuild/3.7.1/lib/python2.7/site-packages
RUN alias module='modulecmd bash'
RUN eb --version
CMD ["eb", "--version"]
