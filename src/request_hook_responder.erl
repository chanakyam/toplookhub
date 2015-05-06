-module(request_hook_responder).

-export([set_cors/1]).

set_cors(Req) ->
	Req1 = cowboy_req:set_resp_header(<<"access-control-allow-methods">>, <<"GET, OPTIONS">>, Req),
    Req2 = cowboy_req:set_resp_header(<<"access-control-allow-origin">>, <<"*">>, Req1),
    Req3 = cowboy_req:set_resp_header(<<"access-control-allow-headers">>, <<"Origin, X-Requested-With, Content-Type, Accept">>, Req2),
    Req3
.