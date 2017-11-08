# Sample Blog API

[![Build Status](https://travis-ci.org/akornatskyy/sample-blog-api-lua.svg?branch=master)](https://travis-ci.org/akornatskyy/sample-blog-api-lua)
[![Coverage Status](https://coveralls.io/repos/akornatskyy/sample-blog-api-lua/badge.svg?branch=master&service=github)](https://coveralls.io/github/akornatskyy/sample-blog-api-lua?branch=master)

A simple blog API written using [lua](http://lua.org/) and
[lucid](https://github.com/akornatskyy/lucid) web API toolkit.

# Setup

Install dependencies into virtual environment:

```sh
make env nginx
eval "$(env/bin/luarocks path --bin)"
```

... or use docker [image](https://github.com/akornatskyy/sample-blog-api-lua/tree/master/docker).

# Prepare

The static content in
[sample-blog-react](https://github.com/akornatskyy/sample-blog-react)
need to be build with *web* api strategy:

```sh
cd ../sample-blog-react
API=web npm run build
```

in case API is served by another host:

```sh
API=web HOST=http://api.local:8080 npm start
```

and linked to `content/static` directory:

```sh
cd ../sample-blog-api-lua
ln -s ../sample-blog-react/dist static
```

# Run

Serve files with a web server:

```sh
make run
```

Open your browser at [http://localhost:8080](http://localhost:8080),
use *demo* / *password*.
