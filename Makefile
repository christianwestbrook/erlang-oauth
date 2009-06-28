SOURCE_FILES := $(wildcard src/*.erl)
LIBDIR=`erl -eval 'io:format("~s~n", [code:lib_dir()])' -s init stop -noshell`

all: ebin

ebin: ebin/oauth.app $(SOURCE_FILES:src/%.erl=ebin/%.beam)

ebin/oauth.app: src/oauth.app
	@test -d ebin || mkdir ebin
	cp src/oauth.app ebin/oauth.app

ebin/%.beam: src/%.erl
	@test -d ebin || mkdir ebin
	erlc -W +debug_info -o ebin $<

clean:
	@rm -rf ebin erl_crash.dump

install:
	mkdir -p $(prefix)/$(LIBDIR)/erlang-oauth/ebin/
	cp ebin/*beam $(prefix)/$(LIBDIR)/erlang-oauth/ebin/