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
        # Work with "redmine_email_integration" plugin
        if with_redmine_email_integration? and new_email?(email)
          if EmailMessage.message_id_exists?(email.message_id)
            logger.debug "[redmine_email_filter] Ignore duplicate email" if logger && logger.debug?
            return
          end
        elsif with_redmine_email_integration? and not new_email?(email)
          logger.debug "[redmine_email_filter] Delegate to redmine_email_integration plugin" if logger && logger.debug?
          receive_without_email_filter(email)
          return
        end

        # Ignore all emails when no active filter exists
        email_filters = EmailFilter.where(active: true).order(:position)
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

      def new_email?(email)
        origin_message_id = email.references.first if email.references.class == Array
        origin_message_id = email.in_reply_to unless origin_message_id
        unless origin_message_id
          return true
        else
          return false
        end
      end

      def with_redmine_email_integration?
        File.exist?(Rails.root.to_s + '/plugins/redmine_email_integration/init.rb')
      end
    end # module InstanceMethods
  end # module MailHandlerPatch
end # module EmailFilter

# Add module to MailHandler class
MailHandler.send(:include, RedmineEmailFilter::MailHandlerPatch)

