require 'sinatra'

get '/home' do
  File.read(File.join('public', 'home.html'))
end
