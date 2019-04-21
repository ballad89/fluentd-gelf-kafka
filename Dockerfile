FROM fluent/fluentd-kubernetes-daemonset:v1.3.3-debian-kafka-1.3

RUN echo 'gem "fluent-plugin-gelf-hs"' >> /fluentd/Gemfile && \
    buildDeps="sudo make gcc g++ libc-dev ruby-dev libffi-dev build-essential autoconf automake libtool pkg-config" \
     && apt-get update \
     && apt-get upgrade -y \
     && apt-get install \
     -y --no-install-recommends \
     $buildDeps net-tools libjemalloc1 \
    && gem install bundler --version 1.16.2 \
    && bundle config silence_root_warning true \
    && bundle install --gemfile=/fluentd/Gemfile --path=/fluentd/vendor/bundle \
    && SUDO_FORCE_REMOVE=yes \
    apt-get purge -y --auto-remove \
                  -o APT::AutoRemove::RecommendsImportant=false \
                  $buildDeps \
    && rm -rf /var/lib/apt/lists/* \
    && gem sources --clear-all \
    && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem
