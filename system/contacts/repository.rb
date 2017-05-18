module Contacts
  class Repository
    @content = []

    class << self
      def store(contact_detail)
        contact = Contacts::Contact.new(contact_detail)
        @content << contact
        contact
      end

      def flush
        @content = []
      end
    end
  end
end
