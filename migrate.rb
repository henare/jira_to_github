#!/usr/bin/env ruby

require 'jira'
require 'yaml'

configuration = YAML.load File.open('configuration.yml')

client = JIRA::Client.new username: configuration['username'],
                          password: configuration['password'],
                          auth_type: :basic,
                          site: configuration['site'],
                          context_path: configuration['context_path']

puts client.Project.find('PW').issues.count
