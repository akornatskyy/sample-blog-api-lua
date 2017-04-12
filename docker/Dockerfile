FROM akorn/lucid:dev-luajit2.1-alpine

MAINTAINER Andriy Kornatskyy <andriy.kornatskyy@live.com>

RUN set -ex \
    \
    && apk add --no-cache --virtual .build-deps \
        git \
    \
    && git clone --depth=1 https://github.com/akornatskyy/sample-blog-api-lua.git /src \
    \
    && rm -rf /app \
    && mv /src/src /app \
    \
    && rm -rf /src \
    && apk del .build-deps

COPY nginx.conf /usr/local/nginx/conf

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]