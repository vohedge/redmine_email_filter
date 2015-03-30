class AddFlagActiveToEmailFilter < ActiveRecord::Migration
  def change
    add_column :email_filters, :active, :boolean, default: true
  end
end
