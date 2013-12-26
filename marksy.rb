require 'json'
require 'httparty'

class Marksy
  include HTTParty

  headers 'Accept' => 'application/json', 'content-type' => 'application/json'

  def self.jira_to_markdown(text)
    options = {body: {input: 'jira', output: 'markdown', text: text}.to_json}
    response = self.post 'http://marksy.arc90.com/convert', options
    response['payload']
  end
end
