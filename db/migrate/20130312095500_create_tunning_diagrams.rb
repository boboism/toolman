class CreateTunningDiagrams < ActiveRecord::Migration
  def change
    create_table :tunning_diagrams do |t|
      t.string :hilt_no

      t.timestamps
    end
  end
end
