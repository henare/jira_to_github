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

jira_issues.reverse.each do |issue|
  puts "Creating GitHub issue #{issue.title}..."
  github_issue = Octokit.create_issue configuration['github']['repo'], issue.title, issue.body, {labels: issue.github_labels}
  puts "Created GitHub issue ##{github_issue.number}"

  case issue.status.name
  when "Resolved", "Closed"
    puts "Closing GitHub issue ##{github_issue.number} as it was already closed in Jira"
    labels = issue.github_labels

    case issue.resolution['name']
    when "Won't Fix"
      labels << "wontfix"
    when "Duplicate"
      labels << "duplicate"
    end

    Octokit.close_issue configuration['github']['repo'], github_issue.number, {labels: labels}
  end
end
