class Item < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates :description, presence: true, length: { maximum: 400 }
  validates :user_id, presence: true

  def self.per_page
    3
  end

end
