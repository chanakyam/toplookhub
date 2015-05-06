%% An utility module to create and return the required URLs

-module(toplookhub_util).
-author("tapanp@koderoom.com").
-include("includes.hrl").
-export([video_db_url/0, 
		 video_db_url/1, 
		 video_view_counter_bump/1,
		 videos_latest/0,
		 videos_popular/1,
		 videos_latest_one/0,
		 videos_home_video/0,
		 video_count/0,
		 videos_get_all/2,
		 news_db_url/0, 
		 news_db_url/1,
		 news_top_text_news_with_limit/2,
		 news_top_text_news_with_limit_and_skip/2,
		 news_top_text_news_with_limit_and_skip1/2,
		 news_top_text_thumb_news_with_limit_and_skip/2,
		 news_top_text_graphics_news_with_limit/1,
		 news_top_text_graphics_news_with_limit_skip/2,
		 news_us_entertainment_url/2,
		 news_category_url/2,
		 news_count/1,
		 news_by_category_limit_skip/3,		
		 news_slideshow_url/1,
		 news_single_slideshow/1
		]).


video_db_url() ->
	%%http://localhost:5984/speakglobally/
	string:concat(?COUCHDB_URL, ?COUCHDB_VIDEO)
. 

video_db_url(VideoId) ->
	%%http://localhost:5984/speakglobally/<ID>
	string:concat(?MODULE:video_db_url(), VideoId)
. 

video_view_counter_bump(VideoId) ->
	%%http://localhost:5984/speakglobally/_design/bump/_update/views_counter/
	Url1 = string:concat(?MODULE:video_db_url(),"_design/bump/_update/views_counter/"),
	string:concat(Url1, VideoId)
.

videos_latest() ->
	%%http://localhost:5984/speakglobally/_design/get_videos/_view/by_id_title_thumbs_duration?descending=true&limit=5
	string:concat(?MODULE:video_db_url(), "_design/get_videos/_view/by_id_title_thumbs_duration?descending=true&limit=5")
.

videos_popular(Count) ->
	%%http://localhost:5984/speakglobally/_design/popular_videos/_view/by_id_title_thumb_duration?descending=true&limit=10
	Url = string:concat(?MODULE:video_db_url(), "_design/popular_videos/_view/by_id_title_thumb_duration?descending=true&limit="),
	string:concat(Url, Count)
.

videos_latest_one() ->
	%%http://localhost:5984/speakglobally/_design/get_videos/_view/latest_one?descending=true&limit=1
	string:concat(?MODULE:video_db_url(), "_design/get_videos/_view/latest_one?descending=true&limit=1")
.

videos_home_video() ->
	%%http://localhost:5984/speakglobally/_design/home_video/_view/by_id_title_video_path?descending=true&limit=15
	string:concat(?MODULE:video_db_url(), "_design/home_video/_view/by_id_title_video_path?descending=true&limit=15") 
.
video_count() ->
	%%http://localhost:5984/speakglobally/_design/get_count/_view/all_docs
	string:concat(?MODULE:video_db_url(),"_design/get_count/_view/all_docs")
.

videos_get_all(Limit, Skip) ->
	%http://localhost:5984/speakglobally/_design/get_videos/_view/by_id_title_thumbs_duration?descending=true&limit=10&skip=10
	Url1 = string:concat(?MODULE:video_db_url(), "_design/get_videos/_view/by_id_title_thumbs_duration?descending=true&limit="),
	Url2 = string:concat(Url1, Limit),
	Url3 = string:concat(Url2, "&skip="),
	string:concat(Url3, Skip)
.

news_db_url() ->
	%% http://localhost:5984/toplookhub/
	string:concat(?COUCHDB_URL, ?COUCHDB_TEXT_GRAPHICS)
.

news_db_url(NewsId) ->
	%% http://localhost:5984/toplookhub/<ID>
	string:concat(?MODULE:news_db_url(), NewsId)
.

news_top_text_news_with_limit(Category,Limit) ->
	%% http://localhost:5984/toplookhub/_design/news_by_category/_view/us_news?descending=true&limit=10
	Url1 = string:concat(?MODULE:news_db_url(), "_design/news_by_category/_view/" ),
	Url2 = string:concat(Url1, Category),
	Url3 = string:concat(Url2, "?descending=true&limit="),
	string:concat(Url3, Limit)
.

news_top_text_news_with_limit_and_skip(Limit, Skip) ->
	%% http://localhost:5984/toplookhub/_design/news_by_category/_view/us_news?descending=true&limit=10
	Url1 = string:concat(?MODULE:news_db_url(), "_design/toplookhub/_view/by_id_title" ),	
	Url3 = string:concat(Url1, "?descending=true&limit="),
	Url4 = string:concat(Url3, Limit),
	Url5 = string:concat(Url4, "&skip="),
	string:concat(Url5, Skip)
.

news_top_text_news_with_limit_and_skip1(Limit, Skip) ->
	%% http://localhost:5984/toplookhub/_design/news_by_category/_view/us_news?descending=true&limit=10
	Url1 = string:concat(?MODULE:news_db_url(), "_design/toplookhub/_view/by_id_title_thumb" ),	
	Url3 = string:concat(Url1, "?descending=true&limit="),
	Url4 = string:concat(Url3, Limit),
	Url5 = string:concat(Url4, "&skip="),
	string:concat(Url5, Skip)
.

news_top_text_thumb_news_with_limit_and_skip(Limit, Skip) ->
	%% http://localhost:5984/toplookhub/_design/news_by_category/_view/us_news?descending=true&limit=10
	Url1 = string:concat(?MODULE:news_db_url(), "_design/toplookhub/_view/by_id_title_thumb" ),	
	Url3 = string:concat(Url1, "?descending=true&limit="),
	Url4 = string:concat(Url3, Limit),
	Url5 = string:concat(Url4, "&skip="),
	string:concat(Url5, Skip)
.



news_top_text_graphics_news_with_limit(Limit) ->
	%%http://localhost:5984/toplookhub/_design/news_and_graphics/_view/by_title_thumb?descending=true&limit=10
	Url1 = string:concat(?MODULE:news_db_url(), "_design/toplookhub/_view/by_id_title?descending=true&limit="),
	string:concat(Url1,Limit)
.

news_top_text_graphics_news_with_limit_skip(Limit, Skip) ->
	%%http://localhost:5984/toplookhub/_design/news_and_graphics/_view/by_title_thumb?descending=true&limit=10
	Url1 = string:concat(?MODULE:news_db_url(), "_design/toplookhub/_view/by_title_thumb?descending=true&limit="),
	Url2 = string:concat(Url1, Limit),
	Url3 = string:concat(Url2, "&skip="),
	string:concat(Url3, Skip)
.

news_category_url(Category, PageNumber) ->
	%% http://localhost:5984/toplookhub/_design/news_by_category/_view/us_news?descending=true&limit=10
	Skip = (PageNumber  -  1)  * 15,
	Url1 = string:concat(?MODULE:news_db_url(), "_design/toplookhub_news_by_category/_view/" ),
	Url2 = string:concat(Url1, Category),
	Url3 = string:concat(Url2, "?descending=true&limit=15&skip="),
	string:concat(Url3, integer_to_list(Skip))
.

news_us_entertainment_url(Category, PageNumber) ->
	%% http://localhost:5984/toplookhub/_design/news_by_category/_view/us_news?descending=true&limit=10
	Skip = (PageNumber  -  1)  * 15,
	Url1 = string:concat(?MODULE:news_db_url(), "_design/news_by_category/_view/" ),
	Url2 = string:concat(Url1, "us_entertainment"),
	Url3 = string:concat(Url2, "?descending=true&limit=15&skip="),
	string:concat(Url3, integer_to_list(Skip))
.

news_count(Category) ->
	%% http://localhost:5984/toplookhub/_design/get_count/_view/<category>
	Url1 = string:concat(?MODULE:news_db_url(), "_design/get_count/_view/"),
	string:concat(Url1, Category) 
.

news_by_category_limit_skip(Category, Skip, Limit) ->
	%%http://localhost:5984/toplookhub/_design/news_by_category/_view/us_news?limit=15&skip=0
	Url1 = string:concat(?MODULE:news_db_url(), "_design/news_by_category/_view/"),
	Url2 = string:concat(Url1, Category),
	Url3 = string:concat(Url2, "?limit="),
	Url4 = string:concat(Url3, Limit),
	Url5 = string:concat(Url4, "&descending=true&skip="),
	string:concat(Url5, Skip)	
.

news_slideshow_url(Limit) ->
	Url1 = string:concat(?MODULE:news_db_url(), "_design/toplookhub/_view/by_title_view_image?descending=true&limit="),
	string:concat(Url1,Limit)
.


news_single_slideshow(Id) ->
	Url1 = string:concat(?MODULE:news_db_url(), Id)
.

