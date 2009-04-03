#!/bin/sh

erlc server.erl
erl -noshell -s server start_echo_server -s init stop
