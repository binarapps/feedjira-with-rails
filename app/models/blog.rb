class Blog < ActiveRecord::Base
  has_many :entries, dependent: :destroy

  after_create :download_entries_after_blog_create

  def update_feed!
    @newest_entry = entries.order(published: :desc).first
    download_success_date = lambda { |url, feed|
      next unless !@newest_entry || entry.published > @newest_entry.published
      add_new_entry_from_feed(entry)
    }
    Feedjira::Feed.fetch_and_parse(
      url,
      on_success: download_success_date,
      on_failure: download_failure
    )
  end

  def download_all_entries!
    Feedjira::Feed.fetch_and_parse(
      url,
      on_success: download_success,
      on_failure: download_failure
    )
  end

  def download_newest_entries!(number)
    return false if number == 0
    on_success_number = lambda { |url, feed|
      feed.entries[0..number - 1].each do |entry|
        add_new_entry_from_feed(entry)
      end
    }
    feed = Feedjira::Feed.fetch_and_parse(
      url,
      on_success: on_success_number,
      on_failure: download_failure
    )
  end

  def download_newest_entry!
    download_newest_entries!(1)[0]
  end

  def self.update_all_blogs
    Blog.all.each do |blog|
      blog.update_feed!
    end
  end

  def download_entries_after_blog_create
    download_newest_entries!(5)
  end

  private

  def add_new_entry_from_feed(entry)
    db_entry = Entry.create_entry_from_feed(entry)
    db_entry.blog_id = id
    db_entry.save
  end

  def download_success
    lambda { |url, feed|
      feed.entries.each do |entry|
        add_new_entry_from_feed(entry)
      end
    }
  end

  def download_failure
    lambda { |curl, err|
      logger.error "Downloading #{curl} failed due to #{error}"
    }
  end
end
