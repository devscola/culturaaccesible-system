require_relative 'repository'
require_relative 'contact'

module Contacts
  class Service
    class << self
      def store(contact_detail)
        contact = Contacts::Repository.store(contact_detail)
        contact.serialize
      end

      def flush
        Contacts::Repository.flush
      end
    end
  end
end
