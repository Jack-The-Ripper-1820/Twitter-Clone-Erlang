{application, 'dosp', [
	{description, "New project"},
	{vsn, "0.1.0"},
	{modules, ['api_handler','dosp_app','dosp_sup','get_hashtags_handler','get_mentions_handler','get_mytweets_handler','login_handler','logoff_handler','middleware','register_handler','retweet_handler','send_tweet_handler','server','user_follow_handler']},
	{registered, [dosp_sup]},
	{applications, [kernel,stdlib,cowboy,mochiweb]},
	{mod, {dosp_app, []}},
	{env, []}
]}.