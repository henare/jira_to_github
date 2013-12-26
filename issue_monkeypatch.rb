module JIRA
  module Resource
    class Issue
      def title
        "[#{key}] #{summary}"
      end

      def body
        assignee = assignee ? assignee.displayName : 'Unassigned'

        # Add horizontal rule after any description
        description = description ? description + "\n\n---\n" : ''

        <<-BODY.gsub(/^ {10}/, '')
          #{description}**Issue details imported from Jira:**

          Detail | Value
          ------ | -----
          Assignee | #{assignee}
          Reporter | #{reporter.displayName}
          Created | #{pretty_time(created)}
          Updated | #{pretty_time(updated)}

          ### Imported Jira Comments
          TODO
        BODY
      end

      def github_labels
        labels = [issuetype.name.downcase, priority.name.downcase]
        labels << components.first.name unless components.empty?
        # We always use fixVersion for tracking milestones
        labels << fields['fixVersions'].first['name'] unless fields['fixVersions'].empty?

        labels
      end

      private

      # HAHA our very own time parser thanks to insane Ruby parsing/formatting/timezone arsehattery
      def pretty_time(time)
        "#{time[0..9]} #{time[11..18]}"
      end
    end
  end
end
