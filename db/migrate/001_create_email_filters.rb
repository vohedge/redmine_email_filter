class CreateEmailFilters < ActiveRecord::Migration
  def change
    create_table :email_filters do |t|
      t.column :name,       :text,    null: false
      t.column :project_id, :integer, null: false
      t.column :operator,   :string,  null: false
      t.column :position,   :integer, default: 0
      t.timestamps :null => false
    end
  end
end

