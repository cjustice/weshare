class User < ActiveRecord::Base
  has_many :items, dependent: :destroy

	before_save { self.email = email.downcase }
	before_create :create_remember_token
	validates :name, presence: true, length: { maximum: 50 }
  	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
  			uniqueness: true
  	has_secure_password

    geocoded_by :address #read the address
    after_validation :geocode #set the lat and long based on address 

  	def User.new_remember_token
	    SecureRandom.urlsafe_base64
	  end

  	def User.hash(token)
  		Digest::SHA1.hexdigest(token.to_s)
  	end

    def feed
      Item.where("user_id = ?", id)
    end

  private

    def create_remember_token
      self.remember_token = User.hash(User.new_remember_token)
    end
    
end
