require 'sinatra/base'

class App < Sinatra::Base 
  set :public_folder, 'public/'
  enable :static

  get '/exhibitions' do
    File.read(File.join('public', 'exhibitions.html'))
  end

end