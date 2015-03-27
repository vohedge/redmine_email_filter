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
        email_filters = EmailFilter.all.order(:position)

        unless email_filters
          receive_without_email_filter(email)
        end

        email_filters.each do |filter|
          match   = 0;
          unmatch = 0;

          filter.email_filter_conditions.each do |condition|
            text = email.from    if condition.email_field == 'from'
            text = email.cc.to_s if condition.email_field == 'cc'
            text = email.subject if condition.email_field == 'subject'
            text = email.decoded if condition.email_field == 'body'
            if is_match(condition.match_type, condition.match_text, text)
              match = match + 1
            else
              unmatch = unmatch + 1
            end
          end

          if ( filter.operator == 'and' && unmatch == 0 )
            receive_without_email_filter(email)
          end

          if ( filter.operator == 'or' && match > 0 )
            receive_without_email_filter(email)
          end
        end
      end

      def is_match(match_type, match_text, text)
        result = text.include?(match_text)
        return true if match_type == 'include' && result
        return true if match_type == 'not_include' && ! result
        false
      end
  
    end # module InstanceMethods
  end # module MailHandlerPatch
end # module EmailFilter

# Add module to MailHandler class
MailHandler.send(:include, RedmineEmailFilter::MailHandlerPatch)

