require 'sinatra'
require 'json'
require 'httparty'

get '/' do
    erb :index
end