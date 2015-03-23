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
        # Filter Action
        binding.pry
        receive_without_email_filter(email)
      end
  
    end # module InstanceMethods
  end # module MailHandlerPatch
end # module EmailFilter

# Add module to MailHandler class
MailHandler.send(:include, RedmineEmailFilter::MailHandlerPatch)

