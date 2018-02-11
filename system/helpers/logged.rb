module Logged
  def login?
    return true if (retrieve_mode == 'development' && session[:registered].nil?) || session[:registered]
    false
  end
end
