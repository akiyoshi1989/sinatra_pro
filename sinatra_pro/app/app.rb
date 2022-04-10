require 'sinatra'
require 'sinatra/reloader'

set :environment, :production

get '/' do
  'indexpage'
end

get '/input' do
  haml :input_form
end

post '/confirm' do
  @sender_name = params[:sender_name]
  @age = params[:age]
  @free_form = params[:free_form]
  haml :confirm
end

post '/complete' do
  if params[:btn_value] == "submit"
    haml :complete
  else
    haml :input_form
  end
end
