class EmailFilterCondition < ActiveRecord::Base
  include Redmine::SafeAttributes

  unloadable

  belongs_to :email_filter

  attr_accessible :email_filter_id,
                  :email_field,
                  :match_type,
                  :match_text,
                  :email_filter_attributes

  validates :email_field, presence: true
  validates :match_type,  presence: true
  validates :match_text,  presence: true
end

