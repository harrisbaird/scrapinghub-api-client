module Scrapinghub
  class Job
    attr_reader :client, :id

    def initialize(client, id)
      @client = client
      @id = id
    end

    def items
      @client.items.get(@id)
    end

    def logs(opts = {})
      @client.logs.get(@id, opts)
    end

    def state
      project = @id.split('/').first
      @client.jobs.list(project, job: @id).first['state']
    end

    def finished?
      state == 'finished'
    end
  end
end
