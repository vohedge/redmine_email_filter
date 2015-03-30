require File.expand_path('../../test_helper', __FILE__)

class EmailFilterEamilHanderTest < ActiveSupport::TestCase
  include Redmine::I18n

  fixtures :projects, :projects_trackers,
           :issues, :issue_statuses, :trackers,
           :journals, :journal_details,
           :attachments,
           :members, :member_roles,
           :roles,
           :users,
           :enumerations

  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures/email'

  def setup
  end

  def teardown
    Setting.clear_cache
  end

  def test_target_project1
    # issue length
    issue_length = Issue.count

    # Set up email filter
    email_filter = create_email_filter
    condition = EmailFilterCondition.new(email_field: 'to',
                                         match_type: 'include',
                                         match_text: 'redmine')
    email_filter.email_filter_conditions = [condition]
    email_filter.project_id = 1
    email_filter.save

    # Email receive
    issue = submit_email('email001.eml',
                         unknown_user: 'accept',
                         no_permission_check: 1)
    assert_equal email_filter.project_id, issue.project_id
    assert_equal issue_length + 1, Issue.count
  end

  def test_target_project2
    # issue length
    issue_length = Issue.count

    # Set up email filter
    email_filter = create_email_filter
    condition = EmailFilterCondition.new(email_field: 'to',
                                         match_type: 'include',
                                         match_text: 'redmine')
    email_filter.email_filter_conditions = [condition]
    email_filter.project_id = 2
    email_filter.save

    # Email receive
    issue = submit_email('email001.eml',
                         unknown_user: 'accept',
                         no_permission_check: 1)
    assert_equal email_filter.project_id, issue.project_id
    assert_equal issue_length + 1, Issue.count
  end

  def test_not_applicable_email
    # issue length
    issue_length = Issue.count

    # Set up email filter
    email_filter = create_email_filter
    condition = EmailFilterCondition.new(email_field: 'to',
                                         match_type: 'include',
                                         match_text: 'cat@somenet.foo')
    email_filter.email_filter_conditions = [condition]
    email_filter.project_id = 2
    email_filter.save

    # Email receive
    submit_email('email001.eml',
                 unknown_user: 'accept',
                 no_permission_check: 1)

    # Assert
    assert_equal issue_length, Issue.count
  end

  private

    def submit_email(filename, options={})
      raw = IO.read(File.join(FIXTURES_PATH, filename))
      yield raw if block_given?
      MailHandler.receive(raw, options)
    end
end

