module RedmineEmailFilter
  module MailHandlerPatch
    def self.included(base) # :nodoc:
      base.send(:include, InstanceMethods)
      
      base.class_eval do
        alias_method_chain :receive, :email_filter
        alias_method_chain :target_project, :email_filter
      end
    end
    
    module InstanceMethods
      private
  
      def receive_with_email_filter(email)
        email_filters = EmailFilter.where(active: true).order(:position)

        # Ignore all emails when no active filter exists
        return if email_filters.length < 1

        email_filters.each do |filter|
          logger.debug "[redmine_email_filter] Proccessing Filter: #{filter.name}" if logger && logger.debug?

          if ( filter.applicable?(email) )
            issue = receive_without_email_filter(email)
            logger.debug "[redmine_email_filter] Ticket Created: #{issue.subject}" if logger && logger.debug?

            return issue
          end
        end

        logger.debug "[redmine_email_filter] No Match Filter" if logger && logger.debug?
        return false
      end

      def target_project_with_email_filter
        email_filters = EmailFilter.where(active: true).order(:position)
        email_filters.each do |filter|
          if ( filter.applicable?(email) )
            target = Project.find_by_id(filter.project_id)
            return target unless target.nil?
          end
        end
        target_project_without_email_filter
      end
    end # module InstanceMethods
  end # module MailHandlerPatch
end # module EmailFilter

# Add module to MailHandler class
MailHandler.send(:include, RedmineEmailFilter::MailHandlerPatch)

