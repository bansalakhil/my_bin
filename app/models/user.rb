class User < ApplicationRecord
  validates :name, :email, :uid, :token, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  validates :uid, uniqueness: { scope: :provider, case_sensitive: false }

  has_many :js_bins, dependent: :destroy
  has_many :ruby_bins, dependent: :destroy

  def update_info_from_auth_hash(auth_hash)
    update_attributes(
      email: auth_hash["info"][:email],
      name: auth_hash["info"][:name],
      profile_pic: auth_hash["info"][:image],
      token: auth_hash["credentials"][:token]
    )
  end  
end
