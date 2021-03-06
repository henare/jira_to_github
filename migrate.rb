#!/usr/bin/env ruby

require 'jira'
require 'yaml'
require 'octokit'
require_relative 'lib/issue_monkeypatch'

configuration = YAML.load File.open('configuration.yml')
ATTACHMENTS_BASE_URL = "#{configuration['jira']['site']}attachments/#{configuration['jira']['project_key']}/"

client = JIRA::Client.new username: configuration['jira']['username'],
                          password: configuration['jira']['password'],
                          auth_type: :basic,
                          site: configuration['jira']['site'],
                          context_path: configuration['jira']['context_path']

Octokit.configure do |c|
  c.login = configuration['github']['username']
  c.password = configuration['github']['password']
end

START_AT_ISSUE = 1

puts "Geting Jira issues for project key #{configuration['jira']['project_key']}..."
query = "key >= #{configuration['jira']['project_key']}-#{START_AT_ISSUE}"
jira_issues = client.Issue.jql(query).reverse
puts "Found #{jira_issues.count} Jira issues"

mappings = []

jira_issues.each do |issue|
  puts "Creating GitHub issue #{issue.title}..."
  github_issue = Octokit.create_issue configuration['github']['repo'], issue.title, issue.body, {labels: issue.github_labels}
  puts "Created GitHub issue ##{github_issue.number}"

  mappings << {jira_issue: issue, github_issue: github_issue}

  puts "# Apache redirect"
  puts "Redirect /browse/#{issue.key} https://github.com/#{configuration['github']['repo']}/issues/#{github_issue.number}"

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

puts "\nMigration complete.\n\n"

puts "# Redirect issue URLs for #{configuration['jira']['project_key']}"
mappings.each do |mapping|
  puts "Redirect /browse/#{mapping[:jira_issue].key} https://github.com/#{configuration['github']['repo']}/issues/#{mapping[:github_issue].number}"
end
