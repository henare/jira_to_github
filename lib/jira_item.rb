# Converts a Nokogiri-parsed Jira XML item into a Hash suitable for creating a JiraIssue with
class JiraItem
  def self.parse(item)
    {title: item.at(:title).inner_text,
     description: item.at(:description).inner_text,
     type: item.at(:type).inner_text,
     priority: item.at(:priority).inner_text,
     status: item.at(:status).inner_text,
     resolution: item.at(:resolution).inner_text,
     reporter: item.at(:reporter).inner_text,
     assignee: item.at(:assignee).inner_text,
     created: item.at(:created).inner_text,
     updated: item.at(:updated).inner_text,
     fixVersion: item.at(:fixVersion).inner_text,
     component: item.at(:component).inner_text}
     # attachment: item.at(:attachment).inner_text
  end
end
