require 'sinatra'
require 'sinatra/json'
require 'haml'
require 'erb'
# lib
require 'cmath'

# 静态文件从 ./public 目录提供服务
# 文件 ./public/css/style.css 作为 http://example.com/css/style.css

get '/' do
   "index"
end

get '/json' do
   json :foo => 'bar'
end

# require 'json'
# get '/json' do
#    content_type :json
#    response = {
#      body: 'welcome to sinatra',
#    }
#    response.to_json
# end

get '/hello/:name' do
   # 匹配 "GET /hello/foo" 和 "GET /hello/bar"
   # params[:name] 的值是 'foo' 或者 'bar'
   "Hello #{params[:name]}!"
 end
 
 get '/posts' do
   # matches "GET /posts?title=foo&author=bar"
   title = params['title']
   author = params['author']
 end

 get '/page' do
   # ./views/page.haml
   haml :page
 end

 get '/time' do
   code = "<%= Time.now %>"
   erb code
 end


