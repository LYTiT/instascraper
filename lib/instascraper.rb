require "dependencies"

module Instascraper
  extend Capybara::DSL

  #get location posts
  def self.location_posts(location_id, num_posts=nil, last_post_reference=nil)
    visit "https://www.instagram.com/explore/locations/#{location_id}/"
    @posts = []
    @last_post_reference = last_post_reference
    scrape_location_posts(num_posts)
  end

  #get a hashtag
  def self.hashtag(hashtag)
    visit "https://www.instagram.com/explore/tags/#{hashtag}/"
    @posts = []
    scrape_posts
  end

  #long scrape a hashtag
  def self.long_scrape_hashtag(hashtag, scrape_length)
    visit "https://www.instagram.com/explore/tags/#{hashtag}/"
    @posts = []
    long_scrape_posts(scrape_length)
  end

  #long scrape a hashtag
  def self.long_scrape_user_posts(username, scrape_length)
    @posts = []
    long_scrape_user_posts_method(username, scrape_length)
  end

  #get user info and posts
  def self.long_scrape_user_info_and_posts(username, scrape_length)
    scrape_user_info(username)
    long_scrape_user_posts_method(username, scrape_length)
    @user = Instascraper::InstagramUserWithPosts.new(username, @image, @post_count, @follower_count, @following_count, @description, @posts)
  end

  #get user info
  def self.user_info(username)
    scrape_user_info(username)
    @user = Instascraper::InstagramUser.new(username, @image, @post_count, @follower_count, @following_count, @description)
  end

  #get user info and posts
  def self.user_info_and_posts(username)
    scrape_user_info(username)
    scrape_user_posts(username)
    @user = Instascraper::InstagramUserWithPosts.new(username, @image, @post_count, @follower_count, @following_count, @description, @posts)
  end

  #get user posts only
  def self.user_posts(username)
    scrape_user_posts(username)
  end

  #get user follower count
  def self.user_follower_count(username)
    scrape_user_info(username)
    return @follower_count
  end

  #get user following count
  def self.user_following_count(username)
    scrape_user_info(username)
    return @following_count
  end

  #get user post count
  def self.user_post_count(username)
    scrape_user_info(username)
    return @post_count
  end

  #get user description
  def self.user_description(username)
    scrape_user_info(username)
    return @description
  end

  #get post details
  def self.full_post(link)    
    @hashtags = []
    complete_post_scrape(link)
    @post = Instascraper::InstagramPost.new(link, @image, @username, @user_profile_image, @timestamp, @comment, @hashtags)
  	return @post
  end

  
  private

  #scrape post details
  def self.complete_post_scrape(link)
    visit link
    @username = page.find('article header div a', match: :first)["title"]
    @user_profile_image = page.find('article header a img')["src"]    
    @timestamp = page.find('article div section a time')["datetime"]
    @image = page.find('article div div div img')["src"]
    comment_html = page.find('article div ul li h1 span') rescue nil
    if comment_html == nil
      @comment = ""
    else
      @comment = comment_html.text
    end

    begin
      all("article div ul li h1 span a").each do |hashtag|
        @hashtags << hashtag.text
      end
    rescue
      @hashtags = []
    end
    
  end

  #post iteration through most receent posts exclusively
  def self.iterate_through_most_recent_posts(num_posts)
    num_posts = num_posts || 100
    i = 0
    #all_posts = find("article div")[1] #most recent post section. [0] is most popular.
    find_all("article h2+div div div a").each do |post|
      if (@last_post_reference != nil && @last_post_reference != post["href"]) or (@last_post_reference == nil)
        break if i >= num_posts
        link = post["href"]
        image = post.find("img")["src"]
        info = Instascraper::InstagramPost.new(link, image)
        @posts << info
        i += 1
      else
        break
      end
    end

    #log
    puts "POST COUNT: #{@posts.length}"
    self.log_posts
    #return result
    return @posts
  end

  #post iteration method
  def self.iterate_through_posts
    all("article div div div a").each do |post|
      link = post["href"]
      image = post.find("img")["src"]
      info = Instascraper::InstagramPost.new(link, image)
      @posts << info
    end

    #log
    puts "POST COUNT: #{@posts.length}"
    self.log_posts
    #return result
    return @posts
  end

  #scrape location posts
  def self.scrape_location_posts(num_posts)
    begin      
      if num_posts == nil
        max_iteration = 10
        page.find('a', :text => "Load more", exact: true).click      
      else
        max_iteration = num_posts/12
        if max_iteration > 0
          page.find('a', :text => "Load more", exact: true).click      
        end
      end
      iteration = 0
      while iteration < max_iteration do
        iteration += 1
        page.execute_script "window.scrollTo(0,document.body.scrollHeight);"
        sleep 0.1
        page.execute_script "window.scrollTo(0,(document.body.scrollHeight - 5000));"
        sleep 0.1
      end
      iterate_through_most_recent_posts(num_posts)
    rescue Capybara::ElementNotFound => e
      begin
        iterate_through_most_recent_posts(num_posts)
      end
    end
  end

  #scrape posts
  def self.scrape_posts
    begin
      page.find('a', :text => "Load more", exact: true).click
      max_iteration = 10
      iteration = 0
      while iteration < max_iteration do
        iteration += 1
        page.execute_script "window.scrollTo(0,document.body.scrollHeight);"
        sleep 0.1
        page.execute_script "window.scrollTo(0,(document.body.scrollHeight - 5000));"
        sleep 0.1
      end
      iterate_through_posts
    rescue Capybara::ElementNotFound => e
      begin
        iterate_through_posts
      end
    end
  end

  def self.long_scrape_posts(scrape_length_in_seconds)
    begin
      page.find('a', :text => "Load more", exact: true).click
      max_iteration = (scrape_length_in_seconds / 0.3)
      iteration = 0
      @loader = "."
      while iteration < max_iteration do
        puts "Instascraper is working. Please wait.#{@loader}"
        iteration += 1
        sleep 0.1
        page.execute_script "window.scrollTo(0,document.body.scrollHeight);"
        sleep 0.1
        page.execute_script "window.scrollTo(0,(document.body.scrollHeight - 5000));"
        sleep 0.1
        @loader << "."
        system "clear"
      end
      iterate_through_posts
    rescue Capybara::ElementNotFound => e
      begin
        iterate_through_posts
      end
    end
  end

  #user info scraper method
  def self.scrape_user_info(username)
    visit "https://www.instagram.com/#{username}/"
    @image = page.find('article header div img')["src"]
    within("header") do
      post_count_html = page.find('span', :text => "posts", exact: true)['innerHTML']
      @post_count = get_span_value(post_count_html)
      follower_count_html = page.find('span', :text => "followers", exact: true)['innerHTML']
      @follower_count = get_span_value(follower_count_html)
      following_count_html = page.find('span', :text => "following", exact: true)['innerHTML']
      @following_count = get_span_value(following_count_html)
      description = page.find('h2').first(:xpath,".//..")['innerHTML']
      @description = Nokogiri::HTML(description).text
    end
  end

  def self.long_scrape_user_posts_method(username, scrape_length_in_seconds)
    @posts = []
    visit "https://www.instagram.com/#{username}/"
    long_scrape_posts(scrape_length_in_seconds)
  end

  def self.scrape_user_posts(username)
    @posts = []
    visit "https://www.instagram.com/#{username}/"
    scrape_posts
  end

  #post logger
  def self.log_posts
    @posts.each do |post|
      puts "\n"
      puts "Image: #{post.image}\n"
      puts "Link: #{post.link}\n"
    end
    puts "\n"
  end

  #split away span tags from user info numbers
  def self.get_span_value(element)
    begin_split = "\">"
    end_split = "</span>"
    return element[/#{begin_split}(.*?)#{end_split}/m, 1]
  end

  #split away a tags from hashtags of a post
  def self.get_a_value(element)
    begin_split = "\">"
    end_split = "</a>"
    return element[/#{begin_split}(.*?)#{end_split}/m, 1]
  end  


end
