class Instascraper::InstagramPost
  attr_accessor :link, :image, :username, :user_profile_image, :timestamp, :comment, :hashtags
  def initialize(link, image, username=nil, user_profile_image=nil, timestamp=nil, comment=nil, hashtags=[])
    @image = image
    @link = link
    @username = username
    @user_profile_image = user_profile_image
    @timestamp = timestamp
    @comment = comment
    @hashtags = hashtags
  end
end