require 'spec_helper'

describe Instascraper do

  it 'connects to http redirecter and scapes instagram location page' do
    scrape_result = Instascraper.dirty_location_posts_2(108472159177508, 5, nil)
    scrape_result.each do |post|
      "Link: #{post.link}\nImage: #{post.image}\n"
    end

    expect(scrape_result[0].link).to_not eq(nil)
    expect(scrape_result[0].image).to_not eq(nil)  
  end

=begin
  it 'connects to http rerouter and scrapes posts' do
    scrape_result = Instascraper.dirty_location_posts(108472159177508)
    expect(scrape_result.length).to_not eq(0)
  end

  it 'has a version number' do
    expect(Instascraper::VERSION).not_to be nil
  end

  it 'connects to and scrapes an instagram post' do
    scrape_result = Instascraper.full_post("https://www.instagram.com/p/BG2bSCwywJR/?taken-by=edogelardin")
    expect(scrape_result.link).to_not eq(nil)
    expect(scrape_result.image).to_not eq(nil)
    expect(scrape_result.video).to_not eq(nil)
    expect(scrape_result.username).to_not eq(nil)
    expect(scrape_result.user_profile_image).to_not eq(nil)
    expect(scrape_result.timestamp).to_not eq(nil)
    expect(scrape_result.comment).to_not eq(nil)
    expect(scrape_result.hashtags.count).to_not eq(nil)
  end

  it 'connects to instagram\'s Washington Square Park location, scrapes, and maps posts' do
    scrape_result = Instascraper.location_posts(108472159177508, 5, "https://www.instagram.com/p/BHBOZXODA87/?taken-at=1495")
    scrape_result.each do |post|
      "Link: #{post.link}\nImage: #{post.image}\n"
    end

    expect(scrape_result[0].link).to_not eq(nil)
    expect(scrape_result[0].image).to_not eq(nil)
    #expect(scrape_result[0].username).to_not eq(nil)
    #expect(scrape_result[0].user_profile_image).to_not eq(nil)
    #expect(scrape_result[0].timestamp).to_not eq(nil)
    #expect(scrape_result[0].comment).to_not eq(nil)
    #expect(scrape_result[0].hashtags.count).to_not eq(nil)    
  end

  it 'connects to instagram\'s #test hashtag, scrapes, and maps posts' do
    scrape_result = Instascraper.hashtag("test")
    scrape_result.each do |post|
      "Link: #{post.link}\nImage: #{post.image}\n"
    end
    expect(scrape_result[0].link).to_not eq(nil)
    expect(scrape_result[0].image).to_not eq(nil)
  end

  it 'connects to user\'s instagram scrapes and maps their info' do
    scrape_result = Instascraper.user_info("dannyvassallo")
    expect(scrape_result.follower_count).to_not eq(nil)
  end

  it 'connects to user\'s instagram scrapes and maps their info and posts' do
    scrape_result = Instascraper.user_info_and_posts('foofighters')
    expect(scrape_result.follower_count).to_not eq(nil)
    expect(scrape_result.posts.length).to be > 20
  end

  it 'connects to user\'s instagram scrapes just posts' do
    scrape_result = Instascraper.user_posts('foofighters')
    expect(scrape_result[0].link).to_not eq(nil)
    expect(scrape_result[0].image).to_not eq(nil)
  end

  it 'connects to instagram hashtag long_scrapes \'test\' hashtag and gets over 2k posts' do
    scrape_result = Instascraper.long_scrape_hashtag('test', 60)
    expect(scrape_result.length).to be > 2000
  end

  it 'connects to instagram hashtag long_scrapes a user and gets all posts' do
    post_count = Instascraper.user_post_count('foofighters')
    scrape_result = Instascraper.long_scrape_user_posts('foofighters', 30)
    expect(scrape_result.length.to_s).to be === post_count
  end

  it 'connects to instagram hashtag long_scrapes a user info with posts and gets all of them' do
    scrape_result = Instascraper.long_scrape_user_info_and_posts('foofighters', 30)
    post_count = scrape_result.post_count
    expect(scrape_result.posts.length.to_s).to be === post_count
  end

  it 'connects to a user and checks their post count' do
    scrape_result = Instascraper.user_posts('foofighters')
    expect(scrape_result).to_not eq(nil)
  end

  it 'connects to a user and checks their follower count' do
    scrape_result = Instascraper.user_follower_count('foofighters')
    expect(scrape_result).to_not eq(nil)
  end

  it 'connects to a user and checks their following count' do
    scrape_result = Instascraper.user_following_count('foofighters')
    expect(scrape_result).to_not eq(nil)
  end

  it 'connects to a user and checks their post count' do
    scrape_result = Instascraper.user_post_count('foofighters')
    expect(scrape_result).to_not eq(nil)
  end

  it 'connects to a user and checks their description' do
    scrape_result = Instascraper.user_description('foofighters')
    expect(scrape_result).to_not eq(nil)
  end
=end  
end