module Scrapinghub
  class Jobs
    include HTTParty
    disable_rails_query_string_format

    base_uri 'https://dash.scrapinghub.com/api'

    def initialize(client)
      @client = client
      self.class.basic_auth(@client.api_key, nil)
    end

    def schedule(project, spider, opts = {})
      opts = { body: opts.merge(project: project, spider: spider) }
      id = perform(:post, '/schedule.json', opts)['jobid']
      Scrapinghub::Job.new(@client, id)
    end

    def list(project, opts = {})
      opts = { query: opts.merge(project: project) }
      perform(:get, '/jobs/list.json', opts)['jobs']
    end

    def update(project, job, opts = {})
      opts = { body: opts.merge(project: project, job: job) }
      perform(:post, '/jobs/update.json', opts)['count']
    end

    def delete(project, job)
      opts = { body: { project: project, job: job } }
      perform(:post, '/jobs/delete.json', opts)['count']
    end

    def stop(project, job)
      opts = { body: { project: project, job: job } }
      perform(:post, '/jobs/stop.json', opts)['count']
    end

    private

    def perform(type, url, opts = {})
      res = self.class.send(type, url, opts)
      return res if res.success?

      case res.parsed_response['message']
      when 'Authentication failed'
        fail Scrapinghub::AuthFailed
      else
        fail Scrapinghub::BadRequest, res.parsed_response['message']
      end
    end
  end
end
