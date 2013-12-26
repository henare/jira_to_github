module JIRA
  module Resource
    class Issue
      def title
        "[#{self.key}] #{self.summary}"
      end

      def body
        assignee = assignee ? assignee.displayName : 'Unassigned'

        # TODO: Add more information from the issue to this for GitHub
        <<-BODY.gsub(/^ {10}/, '')
          #{self.description}

          ---
          **Issue details imported from Jira:**

          Detail | Value
          ------ | -----
          Assignee | #{assignee}
          Reporter | #{self.reporter.displayName}
          Created | #{Date.parse(self.created).to_s}
          Updated | #{Date.parse(self.created).to_s}

          ## Comments
          TODO
        BODY
      end

      def github_labels
        # TODO: Output labels, e.g.
        # ['Task', 'High priority', 'Component: Application', 'Version: Some version']
      end
    end
  end
end
