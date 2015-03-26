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
  validates :project_id, presence: true
  validates :operator,   presence: true
  # validate do
  #   check_email_filter_conditions_number
  # end

  private

    def email_filter_conditions_count_valid?
      email_filter_conditions.count >= EMAIL_FILTER_CONDITION_COUNT_MIN
    end

    def check_email_filter_conditions_number
      unless email_filter_conditions_count_valid?
        errors.add(:base, :email_filter_conditions_too_short, :count => EMAIL_FILTER_CONDITION_COUNT_MIN)
      end
    end
end

