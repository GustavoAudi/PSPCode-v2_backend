# frozen_string_literal: true

class AssignedProjectDecorator < Draper::Decorator
  delegate_all

  def project_url
    ENV['HOST_URL'] +
      "students/#{user_id}/projects/#{id}"
  end
end
