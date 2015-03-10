require "cgi"

module Rawscsi
  module Query
    class Lucene < Base
      def initialize(query_hash)
        @query_hash = query_hash
      end

      def build
        [
          query,
          date,
          sort,
          start,
          limit,
          fields,
          "q.parser=lucene"
        ].compact.join("&")
      end

      private
      def query
        "q=#{CGI.escape(query_hash[:q])}"
      end
    end
  end
end

