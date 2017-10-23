require 'digest'

module Authorization
  class Service
    PASSWORD = 'fb67941c184cc28c9c91779530feebd8'
    def self.verify(username, password)
      passphrase = Digest::MD5.hexdigest(password)
      return true if ( passphrase == PASSWORD )
      false
    end
  end
end
