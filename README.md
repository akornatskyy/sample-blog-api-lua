# Sample Blog API

[![Build Status](https://travis-ci.org/akornatskyy/sample-blog-api-lua.svg?branch=master)](https://travis-ci.org/akornatskyy/sample-blog-api-lua)
[![Coverage Status](https://coveralls.io/repos/akornatskyy/sample-blog-api-lua/badge.svg?branch=master&service=github)](https://coveralls.io/github/akornatskyy/sample-blog-api-lua?branch=master)

A simple blog API written using [lua](http://lua.org/) and
[lucid]() web API toolkit.

# Setup

Install dependencies into virtual environment:

```sh
make env nginx
eval "$(env/bin/luarocks path --bin)"
```

# Prepare

The static content in
[sample-blog-react](https://github.com/akornatskyy/sample-blog-react)
need to be build with *web* api strategy:

```sh
cd ../sample-blog-react
gulp build --api=web
```

optionally:

```sh
gulp watch --debug --api=web
```

and linked to `content/static` directory:

```sh
cd ../sample-blog-api-lua
ln -s ../sample-blog-react/build static
```

# Run

Serve files with a web server:

```sh
make run
```

Open your browser at [http://localhost:8080](http://localhost:8080),
use *demo* / *password*.
