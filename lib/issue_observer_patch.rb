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
      if issue.status_id == 5 and issue.parent.present?
        should_change_parent_status = true
        issue.parent.children.each do |child|
          should_change_parent_status = (child.status_id == 5)
          break unless should_change_parent_status
        end
      
        # there is one trouble with this statement:
        # no emails sends on this update
        Issue.update_all("status_id = 11", ["id = ?", issue.parent.id]) if should_change_parent_status
      end
    end
  end    
end