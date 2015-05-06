-module(news_topnews_handler).
-author("tapanp@koderoom.com").

-export([init/3]).

-export([content_types_provided/2]).
-export([welcome/2]).
-export([terminate/3]).

%% Init
init(_Transport, _Req, []) ->
	{upgrade, protocol, cowboy_rest}.

%% Callbacks
content_types_provided(Req, State) ->
	{[		
		{<<"application/json">>, welcome}	
	], Req, State}.

terminate(_Reason, _Req, _State) ->
	ok.

%% API
welcome(Req, State) ->
	% Url = "http://api.contentapi.ws/news?channel=us_politics&limit=5&skip=15&format=short",
	% {ok, "200", _, Response_mlb} = ibrowse:send_req(Url,[],get,[],[]),
	% Body = list_to_binary(Response_mlb),
	% {Body, Req, State}.

	Latest_Politics_Url = "http://api.contentapi.ws/news?channel=us_politics&limit=5&format=short&skip=20",
	% io:format("all news : ~p~n",[Url_Top_News]),
	{ok, "200", _, Response_Latest_Politics} = ibrowse:send_req(Latest_Politics_Url,[],get,[],[]),
	Res_Latest_Politics = jsx:decode(list_to_binary(Response_Latest_Politics)),
	LatestPoliticsParams = proplists:get_value(<<"articles">>, Res_Latest_Politics),

	{ok, Body} = index_dtl:render([{<<"latestpoliticsheadlines">>,LatestPoliticsParams}]),
    {Body, Req, State}.

