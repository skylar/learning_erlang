#!/bin/sh

erlc server
erl -noshell -s server start_echo_server -s init stop
