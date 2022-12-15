-module(retweet_handler).

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
  Username = binary_to_list(proplists:get_value(<<"username">>, JsonPayload)),
  Tweet_Id = binary_to_list(proplists:get_value(<<"tweet_id">>, JsonPayload)),
  init_services ! {"retweet", Username , Tweet_Id, self()},
  {[], State}.

websocket_info({timeout, _Ref, Msg}, State) ->
  Msg,
  {[{text, []}], State};

websocket_info(_Info, State) ->
  io:format("Msg Received ~p ~n", [_Info]),
  Result = mochijson:encode({struct, [{result, _Info}]}),
  {[{text, Result}], State}.






