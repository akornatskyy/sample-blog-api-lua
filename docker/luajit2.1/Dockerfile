FROM akorn/lucid:dev-luajit2.1-alpine

MAINTAINER Andriy Kornatskyy <andriy.kornatskyy@live.com>

RUN set -ex \
    \
    && mkdir /src \
    && wget -c https://github.com/akornatskyy/sample-blog-api-lua/archive/master.tar.gz \
       -O - | tar -xzC /src --strip-components=1 \
    \
    && rm -rf /app \
    && mv /src/src /app \
    && rm -rf /src

COPY nginx.conf /usr/local/nginx/conf

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
