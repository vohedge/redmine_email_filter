class EmailFilter < ActiveRecord::Base
  include Redmine::SafeAttributes

  unloadable

  has_many :email_filter_conditions
  belongs_to :project

  acts_as_list

  attr_accessible :name,
                  :project_id,
                  :operator,
                  :position,
                  :move_to

  scope :sorted, lambda { order(:position) }
end

