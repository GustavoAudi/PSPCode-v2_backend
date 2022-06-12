# frozen_string_literal: true

class Notification < ApplicationRecord
  self.abstract_class = true

  belongs_to :assigned_project
  belongs_to :originator, polymorphic: true
  belongs_to :receiver, polymorphic: true

  validates :assigned_project, :originator, :receiver, presence: true

  after_create :send_email_notification
end
