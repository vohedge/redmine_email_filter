require 'redmine_email_filter/mail_handler_patch'

Redmine::Plugin.register :redmine_email_filter do
  name 'Redmine Email Filter plugin'
  author 'Noah Kobayashi'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'https://github.com/vohedge/redmine_email_filter.git'
  author_url 'https://github.com/vohedge/redmine_email_filter.git'
end

