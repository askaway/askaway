ActiveAdmin.register RepTopic do
  permit_params :topic_id, :rep_id

  collection_action :assign do
    @rep_topic = RepTopic.new
    @reps = Rep.all
    @reps = Rep.where(party_id: Party.find(params[:party_id])) if params[:party_id]
    @rep_topic.rep = Rep.find(params[:rep_id]) if params[:rep_id]
    @rep_topic.topic = Topic.find(params[:topic_id]) if params[:topic_id]
    session[:previous_url] = env["HTTP_REFERER"]
  end

  collection_action :create_assignment, method: :post do
    @rt = RepTopic.create!(permitted_params)
    redirect_url = session[:previous_url] || admin_reps_path
    redirect_to redirect_url, notice: "#{@rt.rep.name} assigned to #{@rt.topic.name}."
  end

  controller do
    def permitted_params
      params.require(:rep_topic).permit(:topic_id, :rep_id)
    end
  end
end
