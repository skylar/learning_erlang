%% a multi process, parallel listen server than can accept
%% multiple simultaneous connections (telnet localhost 50001)

-module(server).
-export([start_echo_server/0]).

%% main entry point into the program
start_echo_server() ->
   %% bind a listening socket to all interfaces, port 50001,
   %% {active, true} causes packets from the accepted socket
   %% to be delivered as messages
   {ok, Listen} = gen_tcp:listen(50007, [binary,
                                         {active, true},
                                         {reuseaddr, true}]),
   %% spawn a process which will block waiting for a connection
   accept_conns(Listen).

accept_conns(Listen) ->
   %% block and wait for an incoming connection  
   {ok, Socket} = gen_tcp:accept(Listen),
   io:format("got a connection!~n"),
   %% spawn another process which will accept the next connection
   spawn(fun() -> read_from_sock(Socket) end),
   %% enter a read loop with this process to echo from socket
   accept_conns(Listen).

read_from_sock(Socket) ->
   io:format("spawned proc to read from socket~n"),
   %% XXX: why isn't this little guy getting messages? we must
   %% transfer ownership?
   receive
       {tcp, Socket, Data} ->
	       io:format("echoing: ~p~n", [Data]),
		   gen_tcp:send(Socket, Data),
		   read_from_sock(Socket);
	   {tcp_closed, Socket} ->
	       io:format("sock closed!~n")	      
   end.   
