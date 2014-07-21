class RenameTopicRnzsToEmbeddedTopics < ActiveRecord::Migration
  def change
    rename_table :topic_rnzs, :embedded_topics
    rename_column :questions, :topic_rnz_id, :embedded_topic_id
  end
end
