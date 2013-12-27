# Jira to GitHub Issues migration

This `migrate.rb` script allows you to migrate a Jira project to GitHub issues.

It does this by connecting to your Jira instance using the REST API and
extracting all the issues. It then formats them, preserving as much relevant
detail as possible, and creates them on your GitHub project via their API.

## Usage

To use this script you'll want to review the formatting of the outputted
issues. You'll probably want to tweak it for your needs, as it's been
developed with how the OpenAustralia Foundation used Jira in mind. On the other
hand it may work perfectly fine for you.

Once you're happy it's going to create the issues like you want them, you'll
probably want to create a new user account on GitHub. You can then use that
account to create the issues, rather than your personal account.

Copy `configuration.yml.example` to `configuration.yml` and fill in your
details. It should be pretty self explanatory.

I strongly recommend you create a test repo with your fancy new GitHub account
and import the issues into that first as a test run.

Once you're ready to go:

```
# Install the Gems
bundle install

# Run the migration
bundle exec ./migrate.rb
```

## Copyright & License

Copyright OpenAustralia Foundation Limited 2013. Licensed under the Affero GPL.

## Authors

Henare Degan
