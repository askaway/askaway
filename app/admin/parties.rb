ActiveAdmin.register Party do
  permit_params :name, :auth_statement, :description

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :auth_statement
      f.input :description
    end
    f.actions
  end

  show do |party|
    attributes_table do
      row :id
      row :name
      row :auth_statement
      row :description
    end
    h2 "#{pluralize party.unassigned_topics.count, "Unassigned Topic"}"
    ul do
      party.unassigned_topics.each do |topic|
        li ERB::Util.h(topic.name) + ' ' + link_to("(Assign)", assign_admin_rep_topics_path(topic_id: topic.id, party_id: party.id))
      end
    end
    h2 "#{pluralize party.reps.unassigned.count, "Unassigned Rep"}"
    ul do
      party.reps.unassigned.each do |rep|
        li ERB::Util.h(rep.name) + ' ' + link_to("(Assign)", assign_admin_rep_topics_path(rep_id: rep.id, party_id: party.id))
      end
    end
    h2 "#{pluralize party.reps.assigned.count, "Assigned Rep"}"
    ul do
      party.reps.assigned.each do |rep|
        li ERB::Util.h("#{rep.name} #{rep.topics.map(&:name)}") + ' ' + link_to("(Unassign)", unassign_admin_rep_path(id: rep.id))
      end
    end
    h2 "#{pluralize party.assigned_topics.count, "Assigned Topic"}"
    ul do
      party.assigned_topics.each do |topic|
        li ERB::Util.h("#{topic.name} #{topic.reps.where(party: party).map(&:name)}") + ' ' + link_to("(Unassign)", unassign_admin_rep_path(id: topic.reps.where(party: party).first.id, topic_id: topic.id))
      end
    end
  end
end
