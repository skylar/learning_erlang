-module(server).
-export([start_echo_server/0]).

start_echo_server() ->
   {ok, Listen} = gen_tcp:listen(50001, [binary,
                                         {active, true},
                                         {reuseaddr, true}]),
   {ok, Socket} = gen_tcp:accept(Listen),
   gen_tcp:close(Listen),
   loop(Socket).

loop(Socket) ->
   receive
       {tcp, Socket, Data} ->
	       io:format("echoing: ~p~n", [Data]),
		   gen_tcp:send(Socket, Data),
		   loop(Socket);
	   {tcp_closed, Socket} ->
	       io:format("sock closed!~n")	      
   end.   
