class DatasetImporter
  def initialize(raw_records)
    @records = raw_records
  end

  def call
    imported, failed, duplicates = 0, 0, 0
    seen = { external_ids: Set.new, titles: Set.new }

    @records.each do |raw|
      attrs = normalize(raw)

      if invalid?(attrs)
        failed += 1
        next
      end

      if duplicate_in_payload?(attrs, seen) || duplicate_in_db?(attrs)
        duplicates += 1
        next
      end

      if Dataset.create(attrs).persisted?
        imported += 1
        seen[:external_ids] << attrs[:external_id]
        seen[:titles] << attrs[:title].downcase
      else
        failed += 1
      end
    end

    { imported:, failed:, duplicates: }
  end

  private

  def normalize(raw)
    {
      external_id: raw["external_id"].presence,
      title:       raw["title"].presence,
      authors:     Array.wrap(raw["authors"]).compact,
      keywords:    Array.wrap(raw["keywords"]).compact
    }
  end

  def invalid?(attrs)
    attrs[:external_id].nil? || attrs[:title].nil?
  end

  def duplicate_in_payload?(attrs, seen)
    seen[:external_ids].include?(attrs[:external_id]) ||
      seen[:titles].include?(attrs[:title].downcase)
  end

  def duplicate_in_db?(attrs)
    Dataset.exists?(external_id: attrs[:external_id]) ||
      Dataset.exists?(["lower(title) = ?", attrs[:title].downcase])
  end
end
