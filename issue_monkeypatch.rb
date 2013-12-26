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
          Created | #{pretty_time(self.created)}
          Updated | #{pretty_time(self.updated)}

          ## Comments
          TODO
        BODY
      end

      def github_labels
        # TODO: Output labels, e.g.
        # ['Task', 'High priority', 'Component: Application', 'Version: Some version']
      end

      private

      # HAHA our very own time parser thanks to insane Ruby parsing/formatting/timezone arsehattery
      def pretty_time(time)
        "#{time[0..9]} #{time[11..18]}"
      end
    end
  end
end
