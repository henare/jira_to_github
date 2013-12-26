#!/usr/bin/env ruby

require 'jira'
require 'yaml'
require 'octokit'
require_relative 'issue_monkeypatch'

configuration = YAML.load File.open('configuration.yml')

client = JIRA::Client.new username: configuration['jira']['username'],
                          password: configuration['jira']['password'],
                          auth_type: :basic,
                          site: configuration['jira']['site'],
                          context_path: configuration['jira']['context_path']

Octokit.configure do |c|
  c.login = configuration['github']['username']
  c.password = configuration['github']['password']
end

puts "Geting Jira issues for project key #{configuration['jira']['project_key']}..."
jira_issues = client.Project.find(configuration['jira']['project_key']).issues
puts "Found #{jira_issues.count} Jira issues"

def jira_to_github(jira_issue)
  # TODO: Add GitHub issue labels for additional Jira attributes e.g. issue type, priority, etc.
  {title: jira_issue.title,
   body: jira_issue.body}
end

# jira_issues.each do |jira_issue|
#   issue = jira_to_github(jira_issue)
#   puts "Creating GitHub issue #{issue[:title]}..."
#   github_issue = Octokit.create_issue configuration['github']['repo'], issue[:title], issue[:body]
#   puts "Created GitHub issue ##{github_issue.number}"
# end
