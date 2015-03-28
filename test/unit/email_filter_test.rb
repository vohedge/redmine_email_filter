require File.expand_path('../../test_helper', __FILE__)

class EmailFilterTest < ActiveSupport::TestCase
  include Redmine::I18n

  fixtures :projects

  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures/email'

  def setup
    @project = Project.find(1)
    # @email_filter = EmailFilter.new
  end

  ################################################################################
  #
  # Validation Tests
  #
  ################################################################################

  # PRESENCE

  def test_email_filter_test_data_valid
    email_filter = create_email_filter
    assert_equal true, email_filter.save
  end

  def test_email_filter_name_presence
    email_filter = create_email_filter
    email_filter.name = ''
    assert_equal false, email_filter.save
  end

  def test_email_filter_project_id_presence
    email_filter = create_email_filter
    email_filter.project_id = ''
    assert_equal false, email_filter.save
  end

  def test_email_filter_operator_presence
    email_filter = create_email_filter
    email_filter.operator = ''
    assert_equal false, email_filter.save
  end

  def test_email_filter_position_presence
    email_filter = create_email_filter
    email_filter.position = ''
    assert_equal false, email_filter.save
  end

  def test_email_filter_conditions_presence
    email_filter = create_email_filter
    email_filter.email_filter_conditions = []
    assert_equal false, email_filter.save
  end

  def test_email_filter_condition_email_field_presence
    email_filter = create_email_filter
    email_filter.email_filter_conditions.first.email_field = ''
    assert_equal false, email_filter.save
  end

  def test_email_filter_condition_match_type_presence
    email_filter = create_email_filter
    email_filter.email_filter_conditions.first.match_type = ''
    assert_equal false, email_filter.save
  end

  def test_email_filter_condition_match_text_presence
    email_filter = create_email_filter
    email_filter.email_filter_conditions.first.match_text = ''
    assert_equal false, email_filter.save
  end

  # TYPE

  def test_email_filter_project_id_type
    %w{A a - . あ １}.each do |id|
      email_filter = create_email_filter
      email_filter.project_id = id 
      assert_equal false, email_filter.save
    end
    %w{1 100}.each do |id|
      email_filter = create_email_filter
      email_filter.project_id = id 
      assert_equal true, email_filter.save
    end
  end

  def test_email_filter_position_type
    %w{Aa abc . あいうえお}.each do |position|
      email_filter = create_email_filter
      email_filter.position = position
      assert_equal false, email_filter.save
    end
    %w{1 12 156}.each do |position|
      email_filter = create_email_filter
      email_filter.position = position 
      assert_equal true, email_filter.save
    end
  end

  # INCLUTION

  def test_email_filter_operator_inclution
    %w{12 Aa abc - あいうえお}.each do |operator|
      email_filter = create_email_filter
      email_filter.operator = operator
      assert_equal false, email_filter.save
    end
    %w{and or}.each do |operator|
      email_filter = create_email_filter
      email_filter.operator = operator
      assert_equal true, email_filter.save
    end
  end

  def test_email_filter_condition_email_field
    %w{12 Aa abc - あいうえお}.each do |email_field|
      email_filter = create_email_filter
      email_filter.email_filter_conditions.first.email_field = email_field
      assert_equal false, email_filter.save
    end
    %w{from to cc subject body}.each do |email_field|
      email_filter = create_email_filter
      email_filter.email_filter_conditions.first.email_field = email_field
      assert_equal true, email_filter.save
    end
  end

  def test_email_filter_condition_match_type
    %w{12 Aa abc - あいうえお}.each do |match_type|
      email_filter = create_email_filter
      email_filter.email_filter_conditions.first.match_type = match_type
      assert_equal false, email_filter.save
    end
    %w{include not_include}.each do |match_type|
      email_filter = create_email_filter
      email_filter.email_filter_conditions.first.match_type = match_type
      assert_equal true, email_filter.save
    end
  end

  ################################################################################
  #
  # Single Condition Tests
  #
  ################################################################################

  def test_email_filter_to
    email = load_email('email001.eml')
    email_filter = create_email_filter

    condition = EmailFilterCondition.new(email_field: 'to',
                                         match_type: 'include',
                                         match_text: 'redmine')
    email_filter.email_filter_conditions = [condition]
    assert_equal true, email_filter.applicable?(email)

    condition = EmailFilterCondition.new(email_field: 'to',
                                         match_type: 'include',
                                         match_text: 'ruby')
    email_filter.email_filter_conditions = [condition]
    assert_equal false, email_filter.applicable?(email)

    condition = EmailFilterCondition.new(email_field: 'to',
                                         match_type: 'not_include',
                                         match_text: 'ruby')
    email_filter.email_filter_conditions = [condition]
    assert_equal true, email_filter.applicable?(email)

    condition = EmailFilterCondition.new(email_field: 'to',
                                         match_type: 'not_include',
                                         match_text: 'redmine')
    email_filter.email_filter_conditions = [condition]
    assert_equal false, email_filter.applicable?(email)
  end

  def test_email_filter_from
    email = load_email('email001.eml')
    email_filter = create_email_filter

    condition = EmailFilterCondition.new(email_field: 'from',
                                         match_type: 'include',
                                         match_text: 'jsmith')
    email_filter.email_filter_conditions = [condition]
    assert_equal true, email_filter.applicable?(email)

    condition = EmailFilterCondition.new(email_field: 'from',
                                         match_type: 'include',
                                         match_text: 'taro')
    email_filter.email_filter_conditions = [condition]
    assert_equal false, email_filter.applicable?(email)

    condition = EmailFilterCondition.new(email_field: 'from',
                                         match_type: 'not_include',
                                         match_text: 'taro')
    email_filter.email_filter_conditions = [condition]
    assert_equal true, email_filter.applicable?(email)

    condition = EmailFilterCondition.new(email_field: 'from',
                                         match_type: 'not_include',
                                         match_text: 'jsmith')
    email_filter.email_filter_conditions = [condition]
    assert_equal false, email_filter.applicable?(email)
  end

  def test_email_filter_cc
    email = load_email('email001.eml')
    email_filter = create_email_filter

    condition = EmailFilterCondition.new(email_field: 'cc',
                                         match_type: 'include',
                                         match_text: 'bob@somenet.foo')
    email_filter.email_filter_conditions = [condition]
    assert_equal true, email_filter.applicable?(email)

    condition = EmailFilterCondition.new(email_field: 'cc',
                                         match_type: 'include',
                                         match_text: 'taro')
    email_filter.email_filter_conditions = [condition]
    assert_equal false, email_filter.applicable?(email)

    condition = EmailFilterCondition.new(email_field: 'cc',
                                         match_type: 'not_include',
                                         match_text: 'taro')
    email_filter.email_filter_conditions = [condition]
    assert_equal true, email_filter.applicable?(email)

    condition = EmailFilterCondition.new(email_field: 'cc',
                                         match_type: 'not_include',
                                         match_text: 'bob@somenet.foo')
    email_filter.email_filter_conditions = [condition]
    assert_equal false, email_filter.applicable?(email)
  end

  def test_email_filter_subject
    email = load_email('email001.eml')
    email_filter = create_email_filter

    condition = EmailFilterCondition.new(email_field: 'subject',
                                         match_type: 'include',
                                         match_text: 'testing!')
    email_filter.email_filter_conditions = [condition]
    assert_equal true, email_filter.applicable?(email)

    condition = EmailFilterCondition.new(email_field: 'subject',
                                         match_type: 'include',
                                         match_text: 'Hello!')
    email_filter.email_filter_conditions = [condition]
    assert_equal false, email_filter.applicable?(email)

    condition = EmailFilterCondition.new(email_field: 'subject',
                                         match_type: 'not_include',
                                         match_text: 'Hello!')
    email_filter.email_filter_conditions = [condition]
    assert_equal true, email_filter.applicable?(email)

    condition = EmailFilterCondition.new(email_field: 'subject',
                                         match_type: 'not_include',
                                         match_text: 'testing!')
    email_filter.email_filter_conditions = [condition]
    assert_equal false, email_filter.applicable?(email)
  end

  def test_email_filter_body
    email = load_email('email001.eml')
    email_filter = create_email_filter

    condition = EmailFilterCondition.new(email_field: 'body',
                                         match_type: 'include',
                                         match_text: 'Lorem ipsum')
    email_filter.email_filter_conditions = [condition]
    assert_equal true, email_filter.applicable?(email)

    condition = EmailFilterCondition.new(email_field: 'body',
                                         match_type: 'include',
                                         match_text: 'Ruby on rails')
    email_filter.email_filter_conditions = [condition]
    assert_equal false, email_filter.applicable?(email)

    condition = EmailFilterCondition.new(email_field: 'body',
                                         match_type: 'not_include',
                                         match_text: 'Ruby on rails')
    email_filter.email_filter_conditions = [condition]
    assert_equal true, email_filter.applicable?(email)

    condition = EmailFilterCondition.new(email_field: 'body',
                                         match_type: 'not_include',
                                         match_text: 'Lorem ipsum')
    email_filter.email_filter_conditions = [condition]
    assert_equal false, email_filter.applicable?(email)
  end

  ################################################################################
  #
  # Multi Conditions Tests
  #
  ################################################################################

  def test_email_filter_operator_and
    email = load_email('email001.eml')
    email_filter = create_email_filter

    email_filter.operator = 'and'
    condition1 = EmailFilterCondition.new(email_field: 'from',
                                         match_type: 'include',
                                         match_text: 'jsmith@somenet.foo')
    condition2 = EmailFilterCondition.new(email_field: 'subject',
                                         match_type: 'include',
                                         match_text: 'testing!')
    email_filter.email_filter_conditions = [condition1,condition2]
    assert_equal true, email_filter.applicable?(email)

    condition1 = EmailFilterCondition.new(email_field: 'from',
                                         match_type: 'include',
                                         match_text: 'jsmith@somenet.foo')
    condition2 = EmailFilterCondition.new(email_field: 'subject',
                                         match_type: 'include',
                                         match_text: 'Hello!')
    email_filter.email_filter_conditions = [condition1,condition2]
    assert_equal false, email_filter.applicable?(email)
  end

  def test_email_filter_operator_or
    email = load_email('email001.eml')
    email_filter = create_email_filter

    email_filter.operator = 'or'
    condition1 = EmailFilterCondition.new(email_field: 'from',
                                         match_type: 'include',
                                         match_text: 'jsmith@somenet.foo')
    condition2 = EmailFilterCondition.new(email_field: 'subject',
                                         match_type: 'include',
                                         match_text: 'testing!')
    email_filter.email_filter_conditions = [condition1,condition2]
    assert_equal true, email_filter.applicable?(email)

    condition1 = EmailFilterCondition.new(email_field: 'from',
                                         match_type: 'include',
                                         match_text: 'jsmith@somenet.foo')
    condition2 = EmailFilterCondition.new(email_field: 'subject',
                                         match_type: 'include',
                                         match_text: 'Hello!')
    email_filter.email_filter_conditions = [condition1,condition2]
    assert_equal true, email_filter.applicable?(email)

    condition1 = EmailFilterCondition.new(email_field: 'from',
                                         match_type: 'include',
                                         match_text: 'noah@somenet.foo')
    condition2 = EmailFilterCondition.new(email_field: 'subject',
                                         match_type: 'include',
                                         match_text: 'Hello!')
    email_filter.email_filter_conditions = [condition1,condition2]
    assert_equal false, email_filter.applicable?(email)
  end

  private

    def create_email_filter
      email_filter = EmailFilter.new(name: 'Filter for testing',
                                     project_id: @project.id,
                                     operator: 'and',
                                     position: 1)
      email_filter.email_filter_conditions.build(email_field: 'to',
                                                 match_type: 'include',
                                                 match_text: 'testing')
      email_filter
    end

    def load_email(filename, options={})
      raw = IO.read(File.join(FIXTURES_PATH, filename))
      yield raw if block_given?
      Mail.new(raw)
    end


end

