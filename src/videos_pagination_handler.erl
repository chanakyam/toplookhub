-module(videos_pagination_handler).
-author("shree@ybrantdigital.com").

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
		{<<"text/html">>, welcome}	
	], Req, State}.

terminate(_Reason, _Req, _State) ->
	ok.

%% API
welcome(Req, State) ->
	{Page, PageNumber} = cowboy_req:qs_val(<<"p">>, Req),

	Category = "morevideos",

	Url = "http://api.contentapi.ws/videos?channel=world_news&limit=1&skip=3&format=long",
	% io:format("movies url: ~p~n",[Url]),
	{ok, "200", _, Response_mlb} = ibrowse:send_req(Url,[],get,[],[]),
	ResponseParams_mlb = jsx:decode(list_to_binary(Response_mlb)),	
	[Params] = proplists:get_value(<<"articles">>, ResponseParams_mlb),

	Trending_Videos_Url = "http://api.contentapi.ws/videos?channel=world_news&limit=21&skip=1&format=short",
	{ok, "200", _, Response_Trending_Videos} = ibrowse:send_req(Trending_Videos_Url,[],get,[],[]),
	ResponseParams_Trending_Videos = jsx:decode(list_to_binary(Response_Trending_Videos)),	
	TrendingVideosParams = proplists:get_value(<<"articles">>, ResponseParams_Trending_Videos),
	
	Latest_Politics_Url = "http://api.contentapi.ws/news?channel=us_politics&limit=5&format=short&skip=20",
	% io:format("all news : ~p~n",[Url_Top_News]),
	{ok, "200", _, Response_Latest_Politics} = ibrowse:send_req(Latest_Politics_Url,[],get,[],[]),
	Res_Latest_Politics = jsx:decode(list_to_binary(Response_Latest_Politics)),
	LatestPoliticsParams = proplists:get_value(<<"articles">>, Res_Latest_Politics),
	
	% {ok, Body} = video_paginated_page_dtl:render(),
	{ok, Body} = video_paginated_page_dtl:render([{<<"videoParam">>,Params},{<<"trendingvideos">>,TrendingVideosParams},{<<"news_category">>,Category},{<<"latestpoliticsheadlines">>,LatestPoliticsParams}]),
    {Body, Req, State}.


