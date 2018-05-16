FROM ubuntu:16.04

RUN useradd -m -r user
RUN apt-get update \
 && apt-get install -y wget python python-setuptools git
RUN apt-get install -y environment-modules
ENV PATH=/usr/share/lmod/5.8/libexec:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
USER user
WORKDIR /home/user/
ENV EASYBUILD_PREFIX=/home/user/.local/easybuild
RUN wget -q https://raw.githubusercontent.com/easybuilders/easybuild-framework/develop/easybuild/scripts/bootstrap_eb.py \
 && python bootstrap_eb.py $EASYBUILD_PREFIX
ENV PATH=/home/user/.local/easybuild/software/EasyBuild/3.6.0/bin:/usr/share/lmod/5.8/libexec:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    _LMFILES_=/home/user/.local/easybuild/modules/all/EasyBuild/3.6.0 \
    MODULEPATH=/home/user/.local/easybuild/modules/all \
    LOADEDMODULES=EasyBuild/3.6.0 \
    EBROOTEASYBUILD=/home/user/.local/easybuild/software/EasyBuild/3.6.0 \
    EBDEVELEASYBUILD=/home/user/.local/easybuild/software/EasyBuild/3.6.0/easybuild/EasyBuild-3.6.0-easybuild-devel \
    LESSCLOSE="/usr/bin/lesspipe %s %s" \
    EBVERSIONEASYBUILD=3.6.0 \
    PYTHONPATH=/home/user/.local/easybuild/software/EasyBuild/3.6.0/lib/python2.7/site-packages
RUN alias module='modulecmd bash'
RUN eb --version
USER root
RUN apt-get install -y lmod
RUN apt-get install -y gcc libssl-dev
