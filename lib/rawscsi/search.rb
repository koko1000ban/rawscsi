require "httparty"

module Rawscsi
  class Search < Base

    class Error < StandardError; end

    def search(arg, options = {})
      if arg.is_a?(String)
        query = Rawscsi::Query::Simple.new(arg).build
        raw = options[:raw]
      elsif arg.is_a?(Hash)
        parser = arg.delete(:parser) || :structured
        case parser
        when :structured
          query = Rawscsi::Query::Compound.new(arg).build
        when :lucene
          query = Rawscsi::Query::Lucene.new(arg).build
        end

        raw = arg[:raw]
      else
        raise "Unknown argument type"
      end

      response = send_request_to_aws(query)
      raise Error, response.message if response.code == 400

      results = results_container(response)

      if raw
        results
      else
        build_results(results)
      end
    end

    private
    def url(query)
      [
        "http://search-",
        "#{config.domain_name}-",
        "#{config.domain_id}.",
        "#{config.region}.",
        "cloudsearch.amazonaws.com/",
        "#{config.api_version}/",
        "search?",
        query
      ].join
    end

    def send_request_to_aws(query)
      url_query = url(query)
      HTTParty.get(url_query)
    end

    def results_container(response)
      if is_active_record
        Rawscsi::SearchHelpers::ResultsActiveRecord.new(response, model)
      else
        Rawscsi::SearchHelpers::ResultsHash.new(response)
      end
    end

    def build_results(results_container)
      results_container.build
    end
  end
end

