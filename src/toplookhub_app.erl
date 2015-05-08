-module(toplookhub_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
	Dispatch = cowboy_router:compile([
		{'_',[
                {"/", home_page_handler, []},
                {"/morepoliticsnews", all_news_pagination_handler, []},
                % {"/api/news/topnews", news_topnews_handler, []},     
                % {"/api/news/count", news_count_handler, []},     
                % {"/api/news/topnews_with_images", top_news_and_graphics_handler, []},  
                % {"/slideshow/:id", slideshow_handler, []},                      
                {"/n/:id", news_page_handler, []}, 
                {"/morevideos", videos_pagination_handler, []}, 
                {"/v/:id", video_page_handler, []},                
				{"/css/[...]", cowboy_static, 
					[
                		{directory, {priv_dir, toplookhub, ["public/css"]}},
                		{mimetypes, {fun mimetypes:path_to_mimes/2, default}}
            		]
            	},
                
                {"/images/[...]", cowboy_static, 
                    [
                        {directory, {priv_dir, toplookhub, ["public/images"]}},
                        {mimetypes, {fun mimetypes:path_to_mimes/2, default}}
                    ]
                },
                {"/js/[...]", cowboy_static, 
                    [
                        {directory, {priv_dir, toplookhub, ["public/js"]}},
                        {mimetypes, {fun mimetypes:path_to_mimes/2, default}}
                    ]
                },
                {"/players/[...]", cowboy_static, 
                    [
                        {directory, {priv_dir, toplookhub, ["public/players"]}},
                        {mimetypes, {fun mimetypes:path_to_mimes/2, default}}
                    ]
                },
            	% {"/", cowboy_static, 
            	% 	[
             %    		{directory, {priv_dir, toplookhub, ["public"]}},
             %    		{file, "index.html"},
             %    		{mimetypes, {fun mimetypes:path_to_mimes/2, default}}
            	% 	]
            	% },
                {"/test", cowboy_static, 
                    [
                        {directory, {priv_dir, toplookhub, ["public"]}},
                        {file, "testslider.html"},
                        {mimetypes, {fun mimetypes:path_to_mimes/2, default}}
                    ]
                }
                
			 ]
		}

	]), 
    ok = application:start(compiler),
    ok = application:start(syntax_tools),
    ok = application:start(goldrush),
    ok = application:start(lager),
    ok = application:start(crypto),
    ok = application:start(jsx),
    ok = application:start(ranch),
    ok = application:start(cowlib),
    ok = application:start(cowboy),
    ok = application:start(ibrowse),

	{ok, _} = cowboy:start_http(http,100, [{port, 9907}],[{env, [{dispatch, Dispatch}]},
                                                          {onrequest, fun request_hook_responder:set_cors/1},
                                                          {onresponse, fun error_hook_responder:respond/4}
              ]), 
    toplookhub_sup:start_link().

stop(_State) ->
    ok.
