ActiveAdmin.register Rep do
  scope :all
  scope :unassigned

  index do
    column :id
    column :user_name
    column :party
    column :topics do |rep|
      val = ''.html_safe
      if rep.topics.exists?
        val += ERB::Util.h(rep.topics.order('name asc').map(&:name).to_s + ' ')
        val += link_to('Remove', unassign_admin_rep_path(rep)) + ' '
      end
      val += link_to 'Assign', assign_admin_rep_topics_path(rep_id: rep.id)
      val
    end
    column :created_at
  end

  member_action :remove_assignment, method: :patch do
    @rep = Rep.find(params[:id])
    rep_topic = RepTopic.where(rep_id: @rep.id, topic_id: params[:rep][:unassign_topic]).first
    rep_topic.destroy!
    redirect_url = session[:previous_url] || admin_reps_path
    redirect_to redirect_url, notice: "#{@rep.user_name} unassigned from #{rep_topic.name}."
  end

  member_action :unassign do
    @rep = Rep.find(params[:id])
    @rep.unassign_topic = Topic.find(params[:topic_id]) if params[:topic_id]
    session[:previous_url] = env["HTTP_REFERER"]
  end
end
