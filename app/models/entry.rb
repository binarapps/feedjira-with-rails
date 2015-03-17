class Entry < ActiveRecord::Base
  belongs_to :blog

  def self.create_entry_from_feed(entry)
    new_entry = Entry.new(title: entry.title,
                          author: entry.author,
                          content: check_content(entry),
                          published: entry.published,
                          url: entry.url,
                         )
    new_entry
  end

  private

  def self.check_content(entry)
    return entry.content if entry.content
    return entry.summary if entry.summary
  end
end
