class MakePopularityConfigurableFromSettings < ActiveRecord::Migration
  def up
    execute <<-SPROC
DROP INDEX IF EXISTS index_questions_on_ranking;
DROP FUNCTION IF EXISTS ranking(timestamp, integer);
CREATE OR REPLACE FUNCTION ranking(created_at timestamp, votes_count integer, answers_count integer) RETURNS NUMERIC AS $$
  SELECT ROUND(LOG(2, greatest(votes_count, 1)) + (CAST (aw.value AS numeric) * answers_count) + ((EXTRACT(EPOCH FROM created_at) - EXTRACT(EPOCH from timestamp '2014-1-1 0:00')) / (CAST(tw.value AS numeric) * 43200) )::numeric, 7) FROM settings tw, settings aw WHERE tw.name = 'time_weight' AND aw.name = 'answer_weight';
$$ LANGUAGE SQL IMMUTABLE;
    SPROC
  end

  def down
    execute <<-SPROC
DROP FUNCTION IF EXISTS ranking(timestamp, integer, integer);
CREATE OR REPLACE FUNCTION ranking(created_at timestamp, vote_count integer) RETURNS NUMERIC AS $$
  SELECT ROUND(LOG(2, greatest(vote_count, 1)) + ((EXTRACT(EPOCH FROM created_at) - EXTRACT(EPOCH from timestamp '2014-1-1 0:00')) / 450000)::numeric, 7);
$$ LANGUAGE SQL IMMUTABLE;
    SPROC
  end
end
