-module(smart_bff_app).

-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
	application:start(sasl),
    application:start(crypto),
    application:start(cowlib),
    application:start(ranch),
    application:start(cowboy),
    application:start(pgsql),
	Dispatch = cowboy_router:compile([
		{ '_', [{"/api/v1/route/config", config_handler, []},
        {"/api/v1/route/config/:id", config_handler, []},
        {"/api/v1/route/:service", routing_handler, []} ] }
    ]),
    {ok, _} = cowboy:start_clear(my_http_listener,
        [{port, 8081}],
        #{env => #{dispatch => Dispatch}}
	),

	%spawn(fun() -> server(ConnPid, EventPid) end),
    inets:start(),
	smart_bff_sup:start_link().

stop(_State) ->
	ok.

