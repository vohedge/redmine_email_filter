module RedmineEmailFilter
  module MailHandlerPatch
    def self.included(base) # :nodoc:
      base.send(:include, InstanceMethods)
      
      base.class_eval do
        alias_method_chain :receive, :email_filter
      end
    end
    
    module InstanceMethods
      private
  
      def receive_with_email_filter(email)
        email_filters = EmailFilter.where(active: true).order(:position)

        if email_filters.length < 1
          issue = receive_without_email_filter(email)
          return issue
        end

        email_filters.each do |filter|
          t = filter.applicable?(email)
          if ( t )
            issue = receive_without_email_filter(email)
            return issue
          end
        end
      end
    end # module InstanceMethods
  end # module MailHandlerPatch
end # module EmailFilter

# Add module to MailHandler class
MailHandler.send(:include, RedmineEmailFilter::MailHandlerPatch)

