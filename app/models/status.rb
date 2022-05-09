# == Schema Information
#
# Table name: statuses
#
#  id                  :integer          not null, primary key
#  assigned_project_id :integer          not null
#  user_id             :integer          not null
#  value               :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  project_delivery_id :integer
#
# Indexes
#
#  index_statuses_on_assigned_project_id  (assigned_project_id)
#  index_statuses_on_project_delivery_id  (project_delivery_id)
#  index_statuses_on_user_id              (user_id)
#

class Status < ApplicationRecord
  belongs_to :project_delivery
  belongs_to :assigned_project
  belongs_to :user

  validates :user, :assigned_project_id, presence: true

  before_create :assign_project_delivery

  private

  def assign_project_delivery
    project_delivery = assigned_project.project_deliveries.last
    return unless project_delivery.present?

    self.project_delivery_id = project_delivery.id
  end
end
