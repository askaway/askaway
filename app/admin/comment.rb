ActiveAdmin.register Comment do
  permit_params :body, :question_id, :user_id, :workflow_state

  scope :all
  scope :awaiting_review

  index do
    selectable_column

    column :id
    column :body
    column :user do |comment|
      link_to comment.user.name, comment.user
    end

    column :review do |comment|
      if comment.awaiting_review?
        link = link_to "Accept", accept_admin_comment_path(comment), method: :put
        link += " "
        link += link_to "Reject", reject_admin_comment_path(comment), method: :put
      elsif comment.accepted? || comment.rejected?
        comment.workflow_state.capitalize
      end
    end

    actions
  end

  form do |f|
    f.inputs do
      f.input :question, collection: Question.all.map{|q| [q.body, q.id]}
      f.input :user
      f.input :body
      f.input :workflow_state, as: :select, collection: Comment.workflow_spec.states.keys
    end
    f.actions
  end

  member_action :accept, method: :put do
    comment = Comment.find(params[:id])
    comment.accept!
    redirect_to admin_comments_url, :notice => "Comment accepted."
  end

  member_action :reject, method: :put do
    comment = Comment.find(params[:id])
    comment.reject!
    redirect_to admin_comments_url, :notice => "Comment rejected."
  end
end
