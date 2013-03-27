class AddAttachmentArchiveToTunningDiagrams < ActiveRecord::Migration
  def self.up
    change_table :tunning_diagrams do |t|
      t.attachment :archive
    end
  end

  def self.down
    drop_attached_file :tunning_diagrams, :archive
  end
end
