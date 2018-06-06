class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable, :validatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

         	#attachments
	has_attached_file :profile_image, styles: {thumb: "200x200#" }, default_url: "/assets/missing.png"

  #------Validations

  validates_uniqueness_of :name
  validates_attachment_content_type :profile_image, content_type: /\Aimage\/.*\z/



  def validate!(token)
    res = User.fetch_data(token)
    
    if res['user'] == self.name
      if res['account']['json_metadata'].present?
        if JSON.parse(res['account']['json_metadata'])['profile']['profile_image'] !=nil
    	   profile_image =open(JSON.parse(res['account']['json_metadata'])['profile']['profile_image'])
        end
    	 # cover_image = open(JSON.parse(res['account']['json_metadata'])['profile']['cover_image'])
    	 desc =JSON.parse(res['account']['json_metadata'])['profile']['about']
        # self.update(token: Digest::SHA256.hexdigest(token), desc: desc, profile_image: profile_image)
      end
      self.update(token: token, desc: desc.present? ? desc : nil, profile_image: profile_image.present? ? profile_image : nil)
      true
    else
      false
    end
  end

 

  def self.fetch_data(token)
  	   require 'net/http'
      require 'open-uri'
      require 'json'
    retries = 0

    begin
      uri = URI.parse('https://v2.steemconnect.com/api/me')
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      header = {
        'Content-Type' =>'application/json',
        'Authorization' => token
      }
      req = Net::HTTP::Post.new(uri.path, header)
      res = https.request(req)
      body = JSON.parse(res.body)

      raise res.body if body['user'].blank?

      body
    rescue => e
      retry if (retries += 1) < 3

      { error: e.message }
    end
  end

end
