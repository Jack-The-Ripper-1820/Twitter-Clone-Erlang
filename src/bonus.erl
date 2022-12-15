%%%-------------------------------------------------------------------
%%% @author akhil
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(bonus).

-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
  code_change/3, registration_question/ 0]).

-define(SERVER, ?MODULE).

-record(bonus_state, {}).

%%%===================================================================
%%% Spawning and gen_server implementation
%%%===================================================================

start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

init([]) ->
  ets:new(user_question, [set, named_table, public]),
  PID = spawn(?MODULE,registration_question, []),
  register(registration_question , PID),
  {ok, #bonus_state{}}.


registration_question() ->
  receive
    {put_question, Username, Num1, Num2} ->
      io:format("Username ~p, Num1 ~p, Num2 ~p ~n", [Username, Num1, Num2]),
      ets:insert(user_question, {Username,Num1, Num2}),
      registration_question();
    {get_question, Username, PID} ->
      {_,  Num1, Num2} = lists:nth(1,ets:lookup(user_question,Username)),
      PID ! {answer, Num1, Num2},
      registration_question()
  end.

handle_call(_Request, _From, State = #bonus_state{}) ->
  {reply, ok, State}.

handle_cast(_Request, State = #bonus_state{}) ->
  {noreply, State}.

handle_info(_Info, State = #bonus_state{}) ->
  {noreply, State}.

terminate(_Reason, _State = #bonus_state{}) ->
  ok.

code_change(_OldVsn, State = #bonus_state{}, _Extra) ->
  {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
