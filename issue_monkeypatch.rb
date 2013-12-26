module JIRA
  module Resource
    class Issue
      def title
        "[#{self.key}] #{self.summary}"
      end

      def body
        # TODO: Add more information from the issue to this for GitHub
        self.description
      end
    end
  end
end
