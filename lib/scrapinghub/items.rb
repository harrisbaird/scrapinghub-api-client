require 'httparty'

module Scrapinghub
  class Items
    include HTTParty
    disable_rails_query_string_format

    base_uri 'https://storage.scrapinghub.com/items'

    def initialize(api_key)
      self.class.basic_auth(api_key, nil)
    end

    def get(id, opts = { format: 'json' })
      self.class.get("/#{id}", query: opts)
    end

    def stats(job, opts = {})
      self.class.get("/#{job}/stats", query: opts)
    end
  end
end
