class CreatePopularityFunction < ActiveRecord::Migration
  # Popularity: log2 of the votes cast, plus the seconds since 1 Jan 2014 divided by 45000 (10x slower than reddit's)
  def up
    execute <<-SPROC
CREATE OR REPLACE FUNCTION ranking(created_at timestamp, vote_count integer) RETURNS NUMERIC AS $$
  SELECT ROUND(LOG(2, greatest(vote_count, 1)) + ((EXTRACT(EPOCH FROM created_at) - EXTRACT(EPOCH from timestamp '2014-1-1 0:00')) / 450000)::numeric, 7);
$$ LANGUAGE SQL IMMUTABLE;
SPROC

    execute <<-SPROC
CREATE INDEX index_questions_on_ranking
  ON questions (ranking(created_at::timestamp, vote_count) DESC);
SPROC
  end

  def down
    execute <<-SPROC
DROP INDEX IF EXISTS index_questions_on_ranking;
DROP FUNCTION IF EXISTS ranking(timestamp, integer);
SPROC
  end
end
