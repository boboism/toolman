class AddIndexHiltNoToTunningDiagrams < ActiveRecord::Migration
  def change
    add_index :tunning_diagrams, :hilt_no, name: "tunning_diagrams_hilt_no"
  end
end
