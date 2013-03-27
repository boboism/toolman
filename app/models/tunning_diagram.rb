class TunningDiagram < ActiveRecord::Base
  attr_accessible :hilt_no, :archive

  has_attached_file :archive, styles: {
    thumb: "100x100>"
  }

  default_scope order("created_at desc")
  scope :search, lambda { |content|
    content = content || {}
    where(hilt_no: content[:text]) unless content[:text].blank?
  }

end
