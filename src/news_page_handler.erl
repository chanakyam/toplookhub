-module(news_page_handler).
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
		{<<"text/html">>, welcome}	
	], Req, State}.

terminate(_Reason, _Req, _State) ->
	ok.

%% API
welcome(Req, State) ->
	Video_Url = "http://api.contentapi.ws/videos?channel=world_news&limit=1&skip=1&format=long",
	% io:format("movies url: ~p~n",[Url]),
	{ok, "200", _, Response_mlb} = ibrowse:send_req(Video_Url,[],get,[],[]),
	ResponseParams_mlb = jsx:decode(list_to_binary(Response_mlb)),	
	[VideoParams] = proplists:get_value(<<"articles">>, ResponseParams_mlb),

	Url_Top_News = "http://api.contentapi.ws/news?channel=us_politics&limit=20&format=short&skip=0",
	% io:format("all news : ~p~n",[Url_Top_News]),
	{ok, "200", _, Response_Top_News} = ibrowse:send_req(Url_Top_News,[],get,[],[]),
	Res_Top_News = jsx:decode(list_to_binary(Response_Top_News)),
	ParamsTopNews1 = proplists:get_value(<<"articles">>, Res_Top_News),
	{[{Name,Value}], Req2} = cowboy_req:bindings(Req),

	Url = string:concat("http://api.contentapi.ws/t?id=",binary_to_list(Value) ),
	{ok, "200", _, Response} = ibrowse:send_req(Url,[],get,[],[]),
	Res = string:sub_string(Response, 1, string:len(Response) -1 ),
	Params = jsx:decode(list_to_binary(Res)),
	%io:format("news params ~p ~n",[Params]),

	Latest_Politics_Url = "http://api.contentapi.ws/news?channel=us_politics&limit=5&format=short&skip=20",
	% io:format("all news : ~p~n",[Url_Top_News]),
	{ok, "200", _, Response_Latest_Politics} = ibrowse:send_req(Latest_Politics_Url,[],get,[],[]),
	Res_Latest_Politics = jsx:decode(list_to_binary(Response_Latest_Politics)),
	LatestPoliticsParams = proplists:get_value(<<"articles">>, Res_Latest_Politics),

	{ok, Body} = news_page_dtl:render([{<<"videoParam">>,VideoParams},{<<"newsParam">>,Params},{<<"topnews1">>,ParamsTopNews1},{<<"latestpoliticsheadlines">>,LatestPoliticsParams}]),
    {Body, Req2, State}.


