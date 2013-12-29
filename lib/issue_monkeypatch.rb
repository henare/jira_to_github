module JIRA
  module Resource
    class Issue
      def title
        "#{summary} (#{key})"
      end

      def body
        # Add horizontal rule after any description
        description_text = description ? jira_markup_to_html(description) + "\n\n---\n" : ''

        assignee_text = assignee ? assignee.displayName : 'Unassigned'

        attachments_text = attachments.empty? ? '' : ":paperclip: Jira attachments: #{ATTACHMENTS_BASE_URL}#{key}\n\n"

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
          #{attachments_text}#{comment_text}
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
        comment_body = jira_markup_to_html(comment.body)
        "**#{comment.author['displayName']}** - #{pretty_time(comment.created)}\n" + comment_body.gsub(/^/, '>') + "\n\n"
      end

      def jira_markup_to_html(text)
        retries = 0
        begin
          response = client.post '/rest/api/1.0/render',
                                 {"rendererType" => "atlassian-wiki-renderer", "unrenderedMarkup" => text}.to_json,
                                 {'Accept' => 'text/html'}
        rescue
          raise if retries >= 5
          retries += 1
          retry
        end
        response.body.force_encoding('UTF-8')
      end
    end
  end
end
