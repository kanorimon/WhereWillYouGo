class AddRadiusToPoints < ActiveRecord::Migration
  def change
    add_column :points, :radius, :integer
  end
end
