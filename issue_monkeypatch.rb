module JIRA
  module Resource
    class Issue
      def title
        "[#{key}] #{summary}"
      end

      def body
        assignee_text = assignee ? assignee.displayName : 'Unassigned'

        # Add horizontal rule after any description
        description_text = description ? description + "\n\n---\n" : ''

        if comments.empty?
          comment_text = ''
        else
          comment_text = "---\n### Imported Jira Comments\n"
          comments.each do |comment|
            comment_text += pretty_comment(comment)
          end
        end

        <<-BODY.gsub(/^ {10}/, '')
          #{description_text}**Issue details imported from Jira:**

          Detail | Value
          ------ | -----
          Assignee | #{assignee_text}
          Reporter | #{reporter.displayName}
          Created | #{pretty_time(created)}
          Updated | #{pretty_time(updated)}
          #{comment_text}
        BODY
      end

      def github_labels
        labels = [issuetype.name.downcase]
        labels << priority.name.downcase if priority
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

      def pretty_comment(comment)
        "**#{comment.author['displayName']}** - #{pretty_time(comment.created)}\n" + comment.body.gsub(/^/, '>') + "\n\n"
      end
    end
  end
end
