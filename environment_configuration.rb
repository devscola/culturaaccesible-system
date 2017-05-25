def retrieve_mode
  begin
    ENV.fetch('SYSTEM_MODE')
  rescue
    nil
  end
end

def retrieve_port
  '4567'
end

def retrieve_travis
  File.exist?('travis.ci')
end
