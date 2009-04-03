%% A simple program to parse CSV input from stdin
-module(parse_csv).
-export([main/0]).

%% main entry point into the program
main() ->
   %% enter into tail recursive read func
   read([]).

read(Toks) ->
   case io:get_line('') of
     eof ->
       at eof we're print all we've parsed 
       io:format("~p~n", [Toks]);	 
     L ->
       %% parse the line 
       NewToks = csv_parse( L ),	   
       %% recurse, parsing more toks 
	   read(Toks ++ NewToks)
   end.

%% list comprehension.  TODO: strip \n too?
csv_parse(S) -> [ string:strip(X) || X <- string:tokens(S, ",")].
