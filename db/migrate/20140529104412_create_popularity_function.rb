class CreatePopularityFunction < ActiveRecord::Migration
  def up
    execute <<-SPROC
CREATE OR REPLACE FUNCTION popularity(count integer, weight integer default 3) RETURNS numeric AS $$
  SELECT log(2, greatest(count, 1)) * weight
$$ LANGUAGE SQL IMMUTABLE;

CREATE FUNCTION ranking(id integer, counts integer, weight integer) RETURNS numeric AS $$
  SELECT log(2, id) + popularity(counts, weight)
$$ LANGUAGE SQL IMMUTABLE;

CREATE INDEX index_questions_on_ranking
  ON questions (ranking(id, vote_count, 1) DESC);
SPROC
  end

  def down
    execute <<-SPROC
DROP INDEX IF EXISTS index_questions_on_ranking;
DROP FUNCTION IF EXISTS popularity(integer, integer);
DROP FUNCTION IF EXISTS ranking(integer, integer, integer);
SPROC
  end
end
