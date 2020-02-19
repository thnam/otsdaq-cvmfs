FROM centos:centos7.7.1908

ENV container docker

ARG MYUID
ARG MYGID
ARG USER

RUN yum install -y epel-release && yum -y update 
RUN yum install -y libuuid-devel openssl-devel python-devel openssh rsync git \
  wget centos-release-scl bzip2 vim redhat-lsb-core lsb unzip numactl-libs \
  libicu-devel the_silver_searcher screen

RUN yum install -y https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm
RUN yum install -y cvmfs cvmfs-config-default

# Set locale
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8 

RUN echo 'ZONE="America/Chicago"' > /etc/sysconfig/clock
RUN rm -rf /etc/localtime
RUN ln -s /usr/share/zoneinfo/America/Chicago /etc/localtime

# ADD dots/uname /opt/bin/uname
#RUN chmod +w /opt && chown -R stm:stm /opt && chmod +x /opt/bin/uname

RUN mkdir -p /cvmfs/fermilab.opensciencegrid.org
COPY dots/cvmfs.default /etc/cvmfs/default.local

RUN yum clean all && rm -rf /var/cache/yum/*

# Set up a user
RUN useradd --uid ${MYUID} --groups wheel --system --create-home stm
RUN echo "stm:stm" | chpasswd
RUN echo "root:otsdaq_stm" | chpasswd

ADD dots/vimrc /home/stm/.vimrc
ADD dots/bashrc /home/stm/.bashrc
ADD dots/gitconfig /home/stm/.gitconfig
RUN chown stm:stm /home/stm/.bashrc /home/stm/.vimrc /home/stm/.gitconfig

RUN mkdir -p /opt/ots /opt/db
RUN chown -R stm:stm /opt/db /opt/ots
WORKDIR /opt/ots

# define entry point
ENTRYPOINT chmod o+rw /dev/fuse && \
  mount -t cvmfs fermilab.opensciencegrid.org /cvmfs/fermilab.opensciencegrid.org && \
	su stm && /bin/bash
