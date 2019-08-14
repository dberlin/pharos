FROM ubuntu:latest

ARG NCPU=1
ENV NCPU=$NCPU

RUN apt-get -y update && apt-get -y install sudo build-essential wget flex ghostscript bzip2 git subversion automake libtool bison python libncurses-dev vim-common sqlite3 libsqlite3-0 libsqlite3-dev zlib1g-dev cmake ninja-build libyaml-cpp-dev libboost-all-dev libboost-dev libxml2-dev && rm -rf /var/lib/apt/lists/*

# Only add the build prerequisites script so they won't be rebuilt on pharos code change
RUN mkdir -p /root/pharos/scripts/
ADD scripts/build_prereqs.bash /root/pharos/scripts/
RUN /root/pharos/scripts/build_prereqs.bash -reclaim

ADD . /root/pharos

# Put everything in the same layer so it's much smaller
RUN /root/pharos/scripts/build.bash -reclaim && \
  find /usr/local/lib /usr/local/bin | xargs file | grep 'current ar archive' | awk -F':' '{print $1}' | xargs strip
