FROM jruby:9-alpine

RUN apk add --no-cache libarchive-dev \
 && rm -rf /var/lib/apt/lists/*

ADD . /app

WORKDIR /app
RUN bundle install --without development

EXPOSE 80
CMD ["/usr/local/bin/ruby", "/usr/local/bundle/bin/kaf2json-server", "-p", "80"]
