-module(dosp_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
	Register_Dispatcher = cowboy_router:compile([
		{'_', [
			{"/register_user", register_handler, []}
		]}
	]),
	{ok, _} = cowboy:start_clear(register_listener,
		[{port, 8080}],
		#{env => #{dispatch => Register_Dispatcher}}
	),

	Login_Dispatcher  = cowboy_router:compile([
		{'_', [
			{"/login_user", login_handler, []}
		]}
	]),
	{ok, _} = cowboy:start_clear(login_listener,
		[{port, 8081}],
		#{env => #{dispatch => Login_Dispatcher}}
	),

	Logoff_Dispatcher  = cowboy_router:compile([
		{'_', [
			{"/logoff_user", logoff_handler, []}
		]}
	]),
	{ok, _} = cowboy:start_clear(logoff_listener,
		[{port, 8082}],
		#{env => #{dispatch => Logoff_Dispatcher}}
	),

	User_Follow_Dispatcher  = cowboy_router:compile([
		{'_', [
			{"/user_follow", user_follow_handler, []}
		]}
	]),
	{ok, _} = cowboy:start_clear(user_follow_listener,
		[{port, 8083}],
		#{env => #{dispatch => User_Follow_Dispatcher}}
	),

	Tweet_Dispatcher  = cowboy_router:compile([
		{'_', [
			{"/send_tweets", send_tweet_handler, []}
		]}
	]),
	{ok, _} = cowboy:start_clear(send_tweet_listener,
		[{port, 8084}],
		#{env => #{dispatch => Tweet_Dispatcher}}
	),


	Get_Mentions_Dispatcher  = cowboy_router:compile([
		{'_', [
			{"/get_mentions", get_mentions_handler, []}
		]}
	]),
	{ok, _} = cowboy:start_clear(get_mentions_listener,
		[{port, 8085}],
		#{env => #{dispatch => Get_Mentions_Dispatcher}}
	),

	Get_Hashtags_Dispatcher  = cowboy_router:compile([
		{'_', [
			{"/get_hashtags", get_hashtags_handler, []}
		]}
	]),
	{ok, _} = cowboy:start_clear(get_hashtags_listener,
		[{port, 8086}],
		#{env => #{dispatch => Get_Hashtags_Dispatcher}}
	),

	Retweet_Dispatcher  = cowboy_router:compile([
		{'_', [
			{"/retweet", retweet_handler, []}
		]}
	]),
	{ok, _} = cowboy:start_clear(retweet_listener,
		[{port, 8087}],
		#{env => #{dispatch => Retweet_Dispatcher}}
	),



	Get_MyTweets_Dispatcher  = cowboy_router:compile([
		{'_', [
			{"/get_mytweets", get_mytweets_handler, []}
		]}
	]),
	{ok, _} = cowboy:start_clear(get_mytweets_listener,
		[{port, 8088}],
		#{env => #{dispatch => Get_MyTweets_Dispatcher}}
	),


	%Start Bonus mode
	bonus:start_link(),
	% Start my Server
	server:start_link(),
	%Start my Client
	middleware:start(),
	%Start supervisor
	dosp_sup:start_link().

stop(_State) ->
	ok.
