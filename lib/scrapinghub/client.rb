module Scrapinghub
  class Client
    attr_reader :api_key

    # @param api_key [String] scrapinghub API key
    def initialize(api_key)
      @api_key = api_key
    end

    # @return [Scrapinghub::Jobs]
    def jobs
      @jobs ||= Scrapinghub::Jobs.new(self)
    end

    # @return [Scrapinghub::Items]
    def items
      @items ||= Scrapinghub::Items.new(self)
    end

    def logs
      @logs ||= Scrapinghub::Logs.new(self)
    end
  end
end
