require_relative 'repository'
require_relative '../../domain/exhibition'
require_relative 'exhibition'

module Exhibitions
  class Service
    class << self
      def store(exhibition_data)
        exhibition = Exhibitions::Repository.store(exhibition_data)
        exhibition.serialize
      end

      def retrieve(id)
        exhibition = Exhibitions::Repository.retrieve(id)
        exhibition.serialize
      end

      def list
        Exhibitions::Repository.all
      end

      def flush
        Exhibitions::Repository.flush
      end
    end
  end
end
