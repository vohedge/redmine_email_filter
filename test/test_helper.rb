# Load the Redmine helper
require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')

class ActiveSupport::TestCase
  self.fixture_path = File.dirname(__FILE__) + '/fixtures'

  private
    def create_email_filter
      email_filter = EmailFilter.new(name: 'Filter for testing',
                                     project_id: 1,
                                     operator: 'and',
                                     position: 0)
      email_filter.email_filter_conditions.build(email_field: 'to',
                                                 match_type: 'include',
                                                 match_text: 'testing')
      email_filter
    end
end

