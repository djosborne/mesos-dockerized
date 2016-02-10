# Copyright 2015 Metaswitch Networks
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# For details and docs - see https://github.com/phusion/baseimage-docker#getting_started

FROM ubuntu:14.04.2
CMD ["/sbin/my_init"]

ENV HOME /root
###############
##   Mesos   ##
###############
# CAUTION: To minify builds, Mesos clones are done within the install.sh step.
# Docker builds will cache the clone during first build. 
# Changes made to Mesos upstream will not be included in subsequent builds unless
# images are built with the `--no-cache` flag.
ENV MESOS_BRANCH 0.27.0
ADD /dockerized-mesos/mesos /build/mesos/
RUN  /build/mesos/install.sh && /build/mesos/cleanup.sh

ADD runagent /root/runagent
