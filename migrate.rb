#!/usr/bin/env ruby

require 'jira'
require 'yaml'
require 'octokit'

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

puts Octokit.issues(configuration['github']['repo']).count
