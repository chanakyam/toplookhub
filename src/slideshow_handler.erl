-module(slideshow_handler).
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
	{[{Name,Value}], Req2} = cowboy_req:bindings(Req),
	Url_single_slide_show =  toplookhub_util:news_single_slideshow(Value),
	{ok, "200", _, ResponseSingleSlide} = ibrowse:send_req(Url_single_slide_show,[],get,[],[]),
	%io:format("response ~s ~n ",[ResponseSingleSlide]),
	ResSingle = string:sub_string(ResponseSingleSlide, 1, string:len(ResponseSingleSlide) -1 ),
	FirstSlide = jsx:decode(list_to_binary(ResSingle)),
	%io:format("params ~p ~n",[FirstSlide]),
	Url = toplookhub_util:news_slideshow_url("10"),
	{ok, "200", _, Response} = ibrowse:send_req(Url,[],get,[],[]),
	Res = string:sub_string(Response, 1, string:len(Response) -1 ),
	[{<<"total_rows">>,_},{<<"offset">>,_},{<<"rows">>,Params}] = jsx:decode(list_to_binary(Res)),
	%io:format("params ~p ~n",[Params]),
	%%getting thumbnails for headlines
	Url_Top_News = toplookhub_util:news_top_text_graphics_news_with_limit("10"),
	{ok, "200", _, Response_Top_News} = ibrowse:send_req(Url_Top_News,[],get,[],[]),
	Res_Top_News = string:sub_string(Response_Top_News, 1, string:len(Response_Top_News) -1 ),
	[{<<"total_rows">>,_},{<<"offset">>,_},{<<"rows">>,Params_Top_News}] = jsx:decode(list_to_binary(Res_Top_News)),
	%io:format("params ~p ~n",[Params_Top_News]),
	{ok, Body} = slideshow_dtl:render([{<<"firstslide">>,FirstSlide},{<<"params">>,Params},{<<"headlines">>,Params_Top_News}]),
    {Body, Req, State}.
