module Scrapinghub
  class Logs
    include HTTParty
    base_uri 'https://storage.scrapinghub.com/logs'

    def initialize(client)
      @client = client
      self.class.basic_auth(@client.api_key, nil)
    end

    def get(id, opts = { format: 'text' })
      self.class.get("/#{id}", query: opts).parsed_response
    end
  end
end
