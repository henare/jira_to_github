#!/usr/bin/env ruby

require_relative 'lib/jira_issue'
require_relative 'lib/jira_item'
require 'nokogiri'

file = File.open('../PW.xml')
doc = Nokogiri::XML file

doc.search(:item).each do |item|
  issue = JiraIssue.new JiraItem.parse(item)
  p issue
end
