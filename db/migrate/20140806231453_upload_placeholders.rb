class UploadPlaceholders < ActiveRecord::Migration
  def up
    Placeholder.create(uploaded_avatar: File.new(Rails.root.join("app/assets/images/placeholders/owl.jpg"), "r"))
    Placeholder.create(uploaded_avatar: File.new(Rails.root.join("app/assets/images/placeholders/pukeko.jpg"), "r"))
    Placeholder.create(uploaded_avatar: File.new(Rails.root.join("app/assets/images/placeholders/giraffe.jpg"), "r"))
    Placeholder.create(uploaded_avatar: File.new(Rails.root.join("app/assets/images/placeholders/baboon.jpg"), "r"))
    Placeholder.create(uploaded_avatar: File.new(Rails.root.join("app/assets/images/placeholders/fox.jpg"), "r"))

    User.find_each do |user|
      user.update_attribute(:placeholder_id, Placeholder.offset(rand(Placeholder.count)).first.id)
    end
    Party.find_each do |party|
      party.update_attribute(:placeholder_id, Placeholder.offset(rand(Placeholder.count)).first.id)
      party.save!
    end
  end

  def down
  end
end
