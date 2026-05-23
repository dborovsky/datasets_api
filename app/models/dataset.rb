class Dataset < ApplicationRecord
  validates :external_id, presence: true, uniqueness: true
  validates :title, presence: true, uniqueness: {case_sensitive: false}

  before_save :normalize_data

  def self.search(query)
    return none if query.blank?

    where("title ILIKE :q OR keywords::text ILIKE :q", q: "%#{query}%")
  end

  private

  def normalize_data
    self.authors = Array.wrap(authors).compact
    self.keywords = Array.wrap(keywords).compact
  end
end
