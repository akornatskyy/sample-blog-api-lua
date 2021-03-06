.SILENT: clean env test qa run debian rm lua luajit luarocks nginx
.PHONY: clean env test qa run debian rm lua luajit luarocks nginx

ENV=$(shell pwd)/env
LUA_IMPL?=luajit
LUA_VERSION?=2.1
LUAROCKS_VERSION?=3.4.0
NGINX_VERSION?=1.18.0
NGINX_LUA_MODULE_VERSION?=0.10.13

ifeq (Darwin,$(shell uname -s))
  PLATFORM?=macosx
else
  PLATFORM?=linux
endif

clean:
	find src/ -name '*.o' -delete && \
	rm -rf luacov.* luac.out .luacheckcache *.so

env: luarocks
	for rock in lbase64 luaossl lua-cjson luasocket struct utf8 \
			busted cluacov luacheck ; do \
		$(ENV)/bin/luarocks install $$rock ; \
	done ; \
	$(ENV)/bin/luarocks install --server=http://luarocks.org/dev lucid

test:
	$(ENV)/bin/busted

qa:
	$(ENV)/bin/luacheck -q src/ spec/

run:
	$(ENV)/bin/nginx -c conf/nginx.conf

debian:
	apt-get install build-essential unzip libncurses5-dev libreadline6-dev \
		libssl-dev

rm: clean
	rm -rf $(ENV)

lua: rm
	wget -c https://www.lua.org/ftp/lua-$(LUA_VERSION).tar.gz \
		-O - | tar -xzf - && \
	cd lua-$(LUA_VERSION) && \
	sed -i.bak s%/usr/local%$(ENV)%g src/luaconf.h && \
	sed -i.bak s%./?.lua\;%./?.lua\;./src/?.lua\;%g src/luaconf.h && \
	unset LUA_PATH && unset LUA_CPATH && \
	make -s $(PLATFORM) install INSTALL_TOP=$(ENV) && \
	cd .. && rm -rf lua-$(LUA_VERSION)

luajit: rm
	mkdir luajit && cd luajit && \
	wget -c https://github.com/LuaJIT/LuaJIT/archive/v$(LUA_VERSION).tar.gz \
		-O - | tar -xzC . --strip-components=1 && \
	sed -i.bak s%/usr/local%$(ENV)%g src/luaconf.h && \
	sed -i.bak s%./?.lua\"%./?.lua\;./src/?.lua\"%g src/luaconf.h && \
	export MACOSX_DEPLOYMENT_TARGET=10.10 && \
	unset LUA_PATH && unset LUA_CPATH && \
	make -s install PREFIX=$(ENV) INSTALL_INC=$(ENV)/include && \
	ln -sf $(ENV)/bin/luajit-* $(ENV)/bin/lua && \
	cd .. && rm -rf luajit

luarocks: $(LUA_IMPL)
	wget -qc https://luarocks.org/releases/luarocks-$(LUAROCKS_VERSION).tar.gz \
		-O - | tar -xzf - && \
	cd luarocks-$(LUAROCKS_VERSION) && \
	./configure --prefix=$(ENV) --with-lua=$(ENV) --force-config && \
	make -s build install && \
	cd .. && rm -rf luarocks-$(LUAROCKS_VERSION)

nginx:
	WDIR=`pwd` && \
	cd $(ENV) && \
	rm -rf nginx && \
	mkdir -p conf logs nginx && \
	wget -c https://nginx.org/download/nginx-$(NGINX_VERSION).tar.gz \
		-O - | tar -xzC nginx --strip-components=1 && \
	\
	cd nginx && \
	mkdir -p lua-nginx-module && \
	wget -c https://github.com/openresty/lua-nginx-module/archive/v$(NGINX_LUA_MODULE_VERSION).tar.gz \
		-O - | tar -xzC lua-nginx-module --strip-components=1 && \
	\
	if [ "$(LUA_IMPL)" = "luajit" ] ; then \
		export LUAJIT_LIB=$(ENV)/lib && \
		export LUAJIT_INC=$(ENV)/include ; \
	else \
		export LUA_LIB=$(ENV)/lib && \
		export LUA_INC=$(ENV)/include ; \
	fi && \
	./configure --prefix=$(ENV) --without-http_rewrite_module --without-pcre \
		--add-module=./lua-nginx-module \
		--with-ld-opt="-Wl,-rpath,$$LUAJIT_LIB$$LUA_LIB" ; \
	make -j4 && \
	\
	cd .. && \
	cp nginx/objs/nginx bin/ && \
	cp nginx/conf/mime.types conf/ && \
	ln -sf $$WDIR/etc/nginx.conf conf/nginx.conf && \
	rm -rf nginx
