class Entry < ActiveRecord::Base
  attr_accessible :author, :title, :avatar

  has_attached_file :avatar, styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>'
  }

  class << self
    def update_feeds
      require 'feedzirra'
      feeds_urls = "http://iwanovaca.tumblr.com/rss"
      feeds_urls_array=[]
      feed = Feedzirra::Feed.fetch_and_parse(feeds_urls_array)
      news =[]
      news = check_for_news(feed.entries ,news)
      add_news(news)
    end

    def add_news(entries)
      entries.each do |entry|
        img_url = get_img_src(entry.summary)
        Entry.create(feed_id: author, img_url: url_type[0].to_s, published_date: entry.published, title: entry.title, entry_id:entry.entry_id, content_type: url_type[1])
      end  
    end

    def check_for_news(entries, news)
      entries.each do |entry|
        if Entry.exists?(:title => entry.title)
          break
        else
          news<<entry
        end
      end
      news
    end

    def get_img_src(entry)
      html = Nokogiri::HTML(entry)
      img = html.css('img/@src')
    end
  end
end
