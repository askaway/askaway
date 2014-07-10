ActiveAdmin.register_page "Update Questions" do
  content do
    QuestionRankingCache.update
    para "Question ranking has been updated for admin panel."
  end
end
