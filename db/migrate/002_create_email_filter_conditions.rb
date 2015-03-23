class CreateEmailFilterConditions < ActiveRecord::Migration
  def change
    create_table :email_filter_conditions do |t|
      t.column :email_filter_id, :integer, :null => false
      t.column :email_field,     :text,    :null => false
      t.column :match_type,      :string,  :null => false
      t.column :match_text,      :text,    :null => false
      t.timestamps :null => false
    end
  end
end
