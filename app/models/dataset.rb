class Dataset < ApplicationRecord
  validates :external_id, presence: true, uniqueness: true
  validates :title, presence: true, uniqueness: {case_sensitive: false}

  before_save :normalize_data

  def self.search(query)
    return none if query.blank?

    # Search uses ILIKE for simplicity. For large datasets I would choose
    # PostgreSQL full-text search using tsvector and GIN index or pg_trgm gem 
    # for typo-tolerant search
    where("title ILIKE :q OR keywords::text ILIKE :q", q: "%#{query}%")
  end

  private

  def normalize_data
    self.authors = Array.wrap(authors).compact
    self.keywords = Array.wrap(keywords).compact
  end
end
