-module(user_follow_handler).

-export([init/2]).
-export([websocket_init/1]).
-export([websocket_handle/2]).
-export([websocket_info/2]).

init(Req, Opts) ->

  {cowboy_websocket, Req, Opts}.

websocket_init(State) ->
  {[], State}.

websocket_handle({text, Payload}, State) ->

  {struct, JsonPayload} = mochijson2:decode(Payload),
  io:format("payload ~p ~n", [JsonPayload]),
  Username1 = binary_to_list(proplists:get_value(<<"username1">>, JsonPayload)),
  Username2 = binary_to_list(proplists:get_value(<<"username2">>, JsonPayload)),
  init_services ! {"user_follow", Username1 , Username2,  self()},
  {[], State}.

websocket_info({timeout, _Ref, Msg}, State) ->
  Msg,
  {[{text, []}], State};

websocket_info(_Info, State) ->
  io:format("Msg Received ~p ~n", [_Info]),
  Result = mochijson:encode({struct, [{result, _Info}]}),
  {[{text, Result}], State}.






