require File.expand_path('../../test_helper', __FILE__)

class EmailFilterTest < ActiveSupport::TestCase
  include Redmine::I18n

  fixtures :projects

  def setup
    @project = Project.find(1)
    # @email_filter = EmailFilter.new
  end

  # PRESENCE

  def test_email_filter_test_data_valid
    email_filter = create_email_filter
    assert email_filter.save
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
      assert email_filter.save
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
      assert email_filter.save
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
      assert email_filter.save
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
      assert email_filter.save
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
      assert email_filter.save
    end
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


end

