module Rawscsi
  module Query
    class Compound < Base

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
          "q.parser=structured"
        ].compact.join("&")
      end

      private

      def query
        "q=" + Rawscsi::Query::Stringifier.new(query_hash[:q]).build
      end

   end
  end
end

