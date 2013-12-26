class JiraIssue
  attr_accessor :title,
                :description,
                :type,
                :priority,
                :status,
                :resolution,
                :reporter,
                :assignee,
                :created,
                :updated,
                :fixVersion,
                :component,
                :attachments

  def initialize(attributes)
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
end
