ActiveAdmin.register Answer do
  permit_params :question_id, :rep_id, :body

  filter :rep
  filter :rep_party_id_equals, label: "Party", as: :select,
         collection: ->{ Party.all.collect{|p| [p.name, p.id]} }
  filter :question
  filter :body
  filter :created_at
  filter :updated_at
  filter :edited_at

  index do
    selectable_column
    column :id
    column :body
    column :rep
    column :party do |answer|
      link_to answer.rep.party.name, [:admin, answer.rep.party]
    end
    column :created_at
    column :updated_at
    column :convert do |answer|
      link_to "Convert to comment", convert_admin_answer_path(answer), method: :put
    end

    actions
  end

  member_action :convert, method: :put do
    answer = Answer.find(params[:id])
    comment = ConvertAnswerToComment.execute(answer)
    redirect_to question_path(comment.question), :notice => "Answer converted to comment."
  end

end
