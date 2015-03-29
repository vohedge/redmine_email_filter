class EmailFilter < ActiveRecord::Base
  include Redmine::SafeAttributes

  EMAIL_FILTER_CONDITION_COUNT_MIN = 1

  unloadable

  has_many :email_filter_conditions, dependent: :destroy
  accepts_nested_attributes_for :email_filter_conditions, allow_destroy: true
  belongs_to :project

  acts_as_list

  attr_accessible :name,
                  :project_id,
                  :operator,
                  :position,
                  :move_to,
                  :email_filter_conditions_attributes

  validates :name,       presence: true
  validates :project_id, presence: true, numericality: { only_integer: true }
  validate  :must_have_valid_project_id
  validates :operator,   presence: true,
                         inclusion: { in: %w(and or), message: "%{value} is not a valid operator" }
  validates :position,   presence: true, numericality: { only_integer: true }
  validate  :must_have_email_filter_condition

  def applicable?(email)
    match   = 0;
    unmatch = 0;

    self.email_filter_conditions.each do |condition|
      text = email.to.to_s   if condition.email_field == 'to'
      text = email.from.to_s if condition.email_field == 'from'
      text = email.cc.to_s   if condition.email_field == 'cc'
      text = email.subject   if condition.email_field == 'subject'
      text = email.decoded   if condition.email_field == 'body'
      if is_match(condition.match_type, condition.match_text, text)
        match   = match + 1
      else
        unmatch = unmatch + 1
      end
    end

    return true if self.operator == 'and' && unmatch == 0
    return true if self.operator == 'or' && match > 0
    return false
  end

  private

    def must_have_valid_project_id
      unless Project.find_by_id(project_id)
        errors.add(:base, 'Must have a project')
      end
    end

    def must_have_email_filter_condition
      if email_filter_conditions.empty? or email_filter_conditions.all? {|condition| condition.marked_for_destruction? }
        errors.add(:base, 'Must have at least one condition')
      end
    end

    def is_match(match_type, match_text, text)
      result = text.include?(match_text)
      return true if match_type == 'include' && result
      return true if match_type == 'not_include' && ! result
      false
    end
end

