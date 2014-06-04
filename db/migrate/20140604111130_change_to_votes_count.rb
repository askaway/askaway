class ChangeToVotesCount < ActiveRecord::Migration
  def up
    execute "DROP INDEX IF EXISTS index_questions_on_ranking;"
    execute "DROP FUNCTION IF EXISTS ranking(timestamp, integer);"
    rename_column :questions, :vote_count, :votes_count
    execute <<-SPROC
CREATE OR REPLACE FUNCTION ranking(created_at timestamp, votes_count integer) RETURNS NUMERIC AS $$
  SELECT ROUND(LOG(2, greatest(votes_count, 1)) + ((EXTRACT(EPOCH FROM created_at) - EXTRACT(EPOCH from timestamp '2014-1-1 0:00')) / 450000)::numeric, 7);
$$ LANGUAGE SQL IMMUTABLE;
SPROC
    execute <<-SPROC
CREATE INDEX index_questions_on_ranking
  ON questions (ranking(created_at::timestamp, votes_count) DESC);
SPROC
  end
  def down
    execute "DROP INDEX IF EXISTS index_questions_on_ranking;"
    execute "DROP FUNCTION IF EXISTS ranking(timestamp, integer);"
    rename_column :questions, :votes_count, :vote_count
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
end
