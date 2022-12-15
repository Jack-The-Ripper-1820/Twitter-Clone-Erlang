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
  Answer = proplists:get_value(<<"answer">>, JsonPayload),

  if Answer == undefined ->
    Num1 = round(rand:uniform(10)),
    Num2 = round(rand:uniform(10)),
    registration_question ! {put_question, Username, Num1, Num2},
    Question = integer_to_list(Num1) ++ " + " ++ integer_to_list(Num2) ++ " = ?",
    {[{text,  Question }], "new call"};

  true ->
    registration_question ! {get_question, Username, self()},
    receive
      {answer, Num1, Num2} ->
        if Num1 + Num2 == Answer ->
          init_services ! {"login_user", Username , Password, self()},
          {[], "new call"};
        true -> self() ! "Answer incorrect. User can't be logged in.",
                 {[], "new call"}
        end
    end
   end.

websocket_info({timeout, _Ref, Msg}, State) ->
  Msg,
  {[{text, []}], State};

websocket_info(_Info, State) ->
  io:format("Msg Received ~p ~n", [_Info]),
  Result = mochijson:encode({struct, [{result, _Info}]}),
  {[{text, Result}], State}.






