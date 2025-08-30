# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

ARTEMIS_HOME='/opt/apache-artemis'
ARTEMIS_INSTANCE='/var/lib/artemis-instance'
ARTEMIS_DATA_DIR='/var/lib/artemis-instance/data'
ARTEMIS_ETC_DIR='/var/lib/artemis-instance/etc'
ARTEMIS_OOME_DUMP='/var/lib/artemis-instance/log/oom_dump.hprof'
ARTEMIS_INSTANCE_URI='file:/var/lib/artemis-instance/'
ARTEMIS_INSTANCE_ETC_URI='file:/var/lib/artemis-instance/etc/'

# Cluster Properties: Used by the @ARTEMIS_INSTANCE_URI@ variable
ARTEMIS_CLUSTER_PROPS='-Dactivemq.remoting.default.port=61616 -Dactivemq.remoting.amqp.port=5672 -Dactivemq.remoting.stomp.port=61613 -Dactivemq.remoting.hornetq.port=5445'

# Java Opts
if [ -z "$ARTEMIS_MIN_MEMORY" ]; then
   ARTEMIS_MIN_MEMORY="512M"
fi

if [ -z "$ARTEMIS_MAX_MEMORY" ]; then
   ARTEMIS_MAX_MEMORY="2G"
fi

# Export some variables
export ARTEMIS_HOME ARTEMIS_INSTANCE ARTEMIS_DATA_DIR ARTEMIS_ETC_DIR ARTEMIS_OOME_DUMP ARTEMIS_INSTANCE_URI ARTEMIS_INSTANCE_ETC_URI ARTEMIS_CLUSTER_PROPS

# Set Debug options if ARTEMIS_DEBUG mode is set
if [ "$ARTEMIS_DEBUG" = "true" ]; then
   ARTEMIS_DEBUG_ARGS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005"
fi

JAVA_ARGS="-XX:+PrintClassHistogram -XX:+UseG1GC -XX:+UseStringDeduplication -Xms$ARTEMIS_MIN_MEMORY -Xmx$ARTEMIS_MAX_MEMORY -Dhawtio.disableProxy=true -Dhawtio.realm=activemq -Dhawtio.offline=true -Dhawtio.role=amq -Djolokia.policyLocation=file:$ARTEMIS_INSTANCE_ETC_URI/jolokia-access.xml $ARTEMIS_DEBUG_ARGS"
