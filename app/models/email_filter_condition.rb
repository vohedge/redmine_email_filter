class EmailFilterCondition < ActiveRecord::Base
  include Redmine::SafeAttributes

  unloadable

  belongs_to :email_filter

  attr_accessible :email_filter_id,
                  :email_field,
                  :match_type,
                  :match_text,
                  :email_filter_attributes

  validates :email_field, presence: true,
                          inclusion: { in: %w(from to cc subject body), message: "%{value} is not a valid operator" }
  validates :match_type,  presence: true,
                          inclusion: { in: %w(include not_include), message: "%{value} is not a valid operator" }
  validates :match_text,  presence: true
end

