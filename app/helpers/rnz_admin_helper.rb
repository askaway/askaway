module RnzAdminHelper
  def showing_approved_questions?
    request.fullpath == rnz_admin_questions_path(approved: true)
  end
  def showing_unapproved_questions?
    request.fullpath == rnz_admin_questions_path
  end
end
