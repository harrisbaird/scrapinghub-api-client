module Scrapinghub
  class Items
    include HTTParty
    base_uri 'https://storage.scrapinghub.com/items'

    def initialize(client)
      @client = client
      self.class.basic_auth(@client.api_key, nil)
    end

    def get(id, opts = { format: 'json' })
      self.class.get("/#{id}", query: opts)
    end

    def stats(job, opts = {})
      self.class.get("/#{job}/stats", query: opts)
    end
  end
end
