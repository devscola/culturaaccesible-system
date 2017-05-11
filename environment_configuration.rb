def retrieve_mode
  begin
    system_environment = ENV.fetch('SYSTEM_MODE')
  rescue
    system_environment = nil
  end
  return system_environment
end

def retrieve_port
  begin
    capybara_default_port = '4567'
  rescue
    capybara_default_port = '4567'
  end
  return capybara_default_port
end

def retrieve_travis
  File.exist?('travis.ci')
end
