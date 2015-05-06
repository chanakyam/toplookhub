-module(video_page_handler).
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
	{[{Id,VideoId}], Req2} = cowboy_req:bindings(Req),
	% lager:info("Video with Id ~p requested ",[binary_to_list(VideoId)]),
	% Url = wildridge_util:video_db_url(binary_to_list(VideoId)),
	Url = string:concat("http://api.contentapi.ws/v?id=",binary_to_list(VideoId) ),
	% Url2 = wildridge_util:video_view_counter_bump(binary_to_list(VideoId)),  
	{ok, "200", _, Response} = ibrowse:send_req(Url,[],get,[],[]),
	% {ok, "201",_,_} = ibrowse:send_req(Url2,[],put, [],[]),
	Res = string:sub_string(Response, 1, string:len(Response) -1 ),
	Params = jsx:decode(list_to_binary(Res)),

	Trending_Videos_Url = "http://api.contentapi.ws/videos?channel=world_news&limit=21&skip=1&format=short",
	{ok, "200", _, Response_Trending_Videos} = ibrowse:send_req(Trending_Videos_Url,[],get,[],[]),
	ResponseParams_Trending_Videos = jsx:decode(list_to_binary(Response_Trending_Videos)),	
	TrendingVideosParams = proplists:get_value(<<"articles">>, ResponseParams_Trending_Videos),
	
	Latest_Politics_Url = "http://api.contentapi.ws/news?channel=us_politics&limit=5&format=short&skip=20",
	% io:format("all news : ~p~n",[Url_Top_News]),
	{ok, "200", _, Response_Latest_Politics} = ibrowse:send_req(Latest_Politics_Url,[],get,[],[]),
	Res_Latest_Politics = jsx:decode(list_to_binary(Response_Latest_Politics)),
	LatestPoliticsParams = proplists:get_value(<<"articles">>, Res_Latest_Politics),
	
	% {ok, Body} = video_page_dtl:render(Params),
	{ok, Body} = video_page_dtl:render([{<<"news">>, Params}, {<<"trendingvideos">>,TrendingVideosParams},{<<"latestpoliticsheadlines">>,LatestPoliticsParams}]),
    {Body, Req2, State}.


 