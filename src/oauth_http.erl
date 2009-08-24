-module(oauth_http).

-export([get/1, post/2, response_params/1, response_body/1, response_code/1]).

-define(TIMEOUT_MS, 6000).
-define(HTTP_REQ_HEADERS, [{"User-Agent", "CoTweetRobot/0.0.2"}]).

get(URL) ->
  request("GET", {URL, []}).

post(URL, Data) ->
  request("POST", {URL, [], "application/x-www-form-urlencoded", Data}).

% inets http client version.
%request(Method,Request) ->
%   http:request(Method, Request, [{autoredirect, false}], []).

request(Method, {URL, _} = _Req) when is_list(Method) ->
    lhttpc:request(URL, Method, [], ?TIMEOUT_MS);

request(Method, {URL, _Args, ContentType, PostData} = _Req) when is_list(Method) ->
    Hdrs = lists:append(?HTTP_REQ_HEADERS, [{"Content-Type",ContentType}]),
    lhttpc:request(URL, Method, Hdrs, PostData, ?TIMEOUT_MS).

response_params(Response) ->
  oauth_uri:params_from_string(response_body(Response)).

response_body({{_, _, _}, _, Body}) ->
  Body.

response_code({{_, Code, _}, _, _}) ->
  Code.
