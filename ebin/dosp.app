{application, 'dosp', [
	{description, "New project"},
	{vsn, "0.1.0"},
	{modules, ['api_handler','dosp_app','dosp_sup']},
	{registered, [dosp_sup]},
	{applications, [kernel,stdlib,cowboy]},
	{mod, {dosp_app, []}},
	{env, []}
]}.