-module(api_handler).

-export([init/2]).
-export([websocket_init/1]).
-export([websocket_handle/2]).
-export([websocket_info/2]).

init(Req, Opts) ->
	{cowboy_websocket, Req, Opts}.

websocket_init(State) ->
	io:format("arrived1"),
	register(handler, self()),
	erlang:start_timer(1000, self(), init),
	{[], State}.

websocket_handle(_Data, State) ->
	{[], State}.

websocket_info({timeout, _Ref, Msg}, State) ->
	Msg,
	Res = mochijson:encode({struct, [{strKey, <<"strVal">>}]}),
  self() ! "Close connection",
	{[{text, Res}], State};


websocket_info(_Info, State) ->
	io:format("Closing ~n"),
	{stop, State}.



