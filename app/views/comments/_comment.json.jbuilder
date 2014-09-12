comment = comment.decorate

json.body         comment.body
json.path					comment.path
json.created_at   comment.created_at_description
json.user_path    comment.user_path
json.user_name    comment.user_name
json.user_avatar  comment.user_avatar
json.can_delete		current_user.try(:is_admin?)
