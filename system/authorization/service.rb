require 'digest'

module Authorization
  class Service
    PASSWORD = 'fb67941c184cc28c9c91779530feebd8'
    @token = false
    def self.verify(username, password)
      passphrase = Digest::MD5.hexdigest(password)
      @token = Digest::MD5.hexdigest(username + password) if ( passphrase == PASSWORD )
    end

    def self.is_registered?
      @token
    end
  end
end
