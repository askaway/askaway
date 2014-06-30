require 'active_support/concern'

module FriendlyIdHelper
  extend ActiveSupport::Concern

  def normalize_friendly_id(text)
    text.split(/\s+/)[0..12].compact.join(" ")[0..80].parameterize
  end

  def resolve_friendly_id_conflict(candidates)
    candidate = candidates.first
    counter = 1
    new_id = candidate
    begin
      counter += 1
      new_id = candidate + friendly_id_config.sequence_separator + counter.to_s
    end while self.class.exists?(slug: new_id)
    new_id
  end
end
