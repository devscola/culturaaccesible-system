module Exhibitions
  class TestRepository < Repository
      def self.flush
        @@content = []
      end
  end
end