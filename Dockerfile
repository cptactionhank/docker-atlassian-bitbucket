FROM openjdk:8

# Setup useful environment variables
ENV BITBUCKET_HOME     /var/atlassian/bitbucket
ENV BITBUCKET_INSTALL  /opt/atlassian/bitbucket
ENV BITBUCKET_VERSION  4.14.4

# Install Atlassian Bitbucket and helper tools and setup initial home
# directory structure.
RUN set -x \
    && echo "deb http://ftp.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list \
    && apt-get update --quiet \
    && apt-get install --quiet --yes --no-install-recommends git-core xmlstarlet \
    && apt-get install --quiet --yes --no-install-recommends -t jessie-backports libtcnative-1 \
    && apt-get clean \
    && mkdir -p               "${BITBUCKET_HOME}/lib" \
    && chmod -R 700           "${BITBUCKET_HOME}" \
    && chown -R daemon:daemon "${BITBUCKET_HOME}" \
    && mkdir -p               "${BITBUCKET_INSTALL}" \
    && curl -Ls               "https://www.atlassian.com/software/stash/downloads/binary/atlassian-bitbucket-${BITBUCKET_VERSION}.tar.gz" | tar -zx --directory  "${BITBUCKET_INSTALL}" --strip-components=1 --no-same-owner \
    && curl -Ls                "https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.38.tar.gz" | tar -xz --directory "${BITBUCKET_INSTALL}/lib" --strip-components=1 --no-same-owner "mysql-connector-java-5.1.38/mysql-connector-java-5.1.38-bin.jar" \
    && chmod -R 700           "${BITBUCKET_INSTALL}/conf" \
    && chmod -R 700           "${BITBUCKET_INSTALL}/logs" \
    && chmod -R 700           "${BITBUCKET_INSTALL}/temp" \
    && chmod -R 700           "${BITBUCKET_INSTALL}/work" \
    && chown -R daemon:daemon "${BITBUCKET_INSTALL}/conf" \
    && chown -R daemon:daemon "${BITBUCKET_INSTALL}/logs" \
    && chown -R daemon:daemon "${BITBUCKET_INSTALL}/temp" \
    && chown -R daemon:daemon "${BITBUCKET_INSTALL}/work" \
    && ln --symbolic          "/usr/lib/x86_64-linux-gnu/libtcnative-1.so" "${BITBUCKET_INSTALL}/lib/native/libtcnative-1.so" \
    && sed --in-place         's/^# umask 0027$/umask 0027/g' "${BITBUCKET_INSTALL}/bin/setenv.sh" \
    && xmlstarlet             ed --inplace \
        --delete              "Server/Service/Engine/Host/@xmlValidation" \
        --delete              "Server/Service/Engine/Host/@xmlNamespaceAware" \
                              "${BITBUCKET_INSTALL}/conf/server.xml" \
    && touch -d "@0"          "${BITBUCKET_INSTALL}/conf/server.xml"

# Use the default unprivileged account. This could be considered bad practice
# on systems where multiple processes end up being executed by 'daemon' but
# here we only ever run one process anyway.
# USER daemon:daemon

# Expose default HTTP and SSH ports.
EXPOSE 7990 7999

# Set volume mount points for installation and home directory. Changes to the
# home directory needs to be persisted as well as parts of the installation
# directory due to eg. logs.
VOLUME ["/var/atlassian/bitbucket","/opt/atlassian/bitbucket/logs"]

# Set the default working directory as the Bitbucket home directory.
WORKDIR /var/atlassian/bitbucket

COPY "docker-entrypoint.sh" "/"
ENTRYPOINT ["/docker-entrypoint.sh"]

# Run Atlassian Bitbucket as a foreground process by default.
CMD ["/opt/atlassian/bitbucket/bin/catalina.sh", "run"]
