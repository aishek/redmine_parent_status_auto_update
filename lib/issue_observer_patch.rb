require_dependency 'issue_observer'

# Patches Redmine's Issues dynamically.
# Adds issue after update handler
module IssueObserverPatch
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)
  end
    
  module InstanceMethods
    # If all child issues have status with id 5,
    # sets parent issue's status to id 11
    def after_update(issue)
      update_issue_status_if_children_closed(issue.parent) if issue.status_id == 5 and issue.parent.present?
    end
    
    def update_issue_status_if_children_closed(issue)
      return if issue.children.empty?

      should_change_parent_status = true
      issue.children.each do |child|
        should_change_parent_status = (child.status_id == 5)
        break unless should_change_parent_status
      end
      
      # there is one trouble with this statement:
      # no emails sends on this update
      Issue.update_all("status_id = 5", ["id = ?", issue.id]) if should_change_parent_status

      # recursively updates parent
      update_issue_status_if_children_closed(issue.parent) if issue.parent.present?
    end
  end    
end