require 'redmine'

# Patches to the Redmine core.
require 'dispatcher'
require 'issue_observer_patch'

Dispatcher.to_prepare do
  IssueObserver.send(:include, IssueObserverPatch) unless IssueObserver.included_modules.include? IssueObserverPatch
end

Redmine::Plugin.register :redmine_parent_status_auto_update do
  name 'Redmine Parent Status Auto Update plugin'
  author 'Alexandr Borisov'
  description 'This is a demo plugin for parent issue\'s status auto update'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
end
