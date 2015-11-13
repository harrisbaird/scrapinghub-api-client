require 'httparty'

module Scrapinghub
  class Jobs
    include HTTParty
    disable_rails_query_string_format
    debug_output $stdout

    base_uri 'https://dash.scrapinghub.com/api'

    def initialize(api_key)
      self.class.basic_auth(api_key, nil)
    end

    def schedule(project, spider, opts = {})
      opts = { body: opts.merge(project: project, spider: spider) }
      perform(:post, '/schedule.json', opts)['jobid']
    end

    def list(project, opts = {})
      opts = { query: opts.merge(project: project) }
      perform(:get, '/jobs/list.json', opts)['jobs']
    end

    def update(project, job, opts = {})
      opts = { body: query.merge(project: project, job: job) }
      perform(:post, '/jobs/update.json', opts)
    end

    def delete(project, job)
      opts = { body: { project: project, job: job } }
      perform(:post, '/jobs/delete.json', opts)['status'] == 'ok'
    end

    def stop(project, job)
      opts = { body: { project: project, job: job } }
      perform(:post, '/jobs/stop.json', opts)['status'] == 'ok'
    end

    private

    def perform(type, url, opts = {})
      res = self.class.send(type, url, opts)
      fail BadRequest, res.parsed_response['message'] unless res.success?
      res
    end
  end
end
