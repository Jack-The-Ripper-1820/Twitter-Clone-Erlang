-module(login_handler).

-export([init/2]).
-export([websocket_init/1]).
-export([websocket_handle/2]).
-export([websocket_info/2]).

init(Req, Opts) ->
  register(login_user_handler, self()),
  {cowboy_websocket, Req, Opts}.

websocket_init(State) ->
  {[], State}.

websocket_handle({text, Payload}, State) ->

  {struct, JsonPayload} = mochijson2:decode(Payload),
  io:format("payload ~p ~n", [JsonPayload]),
  io:format("State ~p ~n", [State]),
  if State == "new call" ->
    do_nothing;
    true -> register(login_process, self())
  end,
  Username = binary_to_list(proplists:get_value(<<"username">>, JsonPayload)),
  Password = binary_to_list(proplists:get_value(<<"password">>, JsonPayload)),
  init_services ! {"login_user", Username , Password, self()},
  {[], "new call"}.

websocket_info({timeout, _Ref, Msg}, State) ->
  Msg,
  {[{text, []}], State};

websocket_info(_Info, State) ->
  io:format("Msg Received ~p ~n", [_Info]),
  Result = mochijson:encode({struct, [{result, _Info}]}),
  {[{text, Result}], State}.






