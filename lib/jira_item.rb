# Converts a Nokogiri-parsed Jira XML item into a Hash suitable for creating a JiraIssue with
class JiraItem
  def self.parse(item)
    {title: item.at(:title).inner_text,
     description: item.at(:description).inner_text,
     type: item.at(:type).inner_text,
     priority: inner_text_or_nil(item.at(:priority)),
     status: item.at(:status).inner_text,
     resolution: item.at(:resolution).inner_text,
     reporter: item.at(:reporter).inner_text,
     assignee: item.at(:assignee).inner_text,
     created: item.at(:created).inner_text,
     updated: item.at(:updated).inner_text,
     fixVersion: inner_text_or_nil(item.at :fixVersion),
     component: inner_text_or_nil(item.at :component)}
     # attachment: item.at(:attachment).inner_text
  end

  private

  def self.inner_text_or_nil(element)
    element.inner_text if element
  end
end
