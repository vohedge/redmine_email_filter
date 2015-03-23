class EmailFilterCondition < ActiveRecord::Base
  unloadable
  belongs_to :email_filter
end

