# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id               :integer          not null, primary key
#  name             :string           not null
#  process_id       :integer          not null
#  description_file :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_projects_on_process_id  (process_id)
#

class Project < ApplicationRecord
  # Process that a project follow
  belongs_to :process, class_name: 'PspProcess'

  delegate :name, to: :process, prefix: true, allow_nil: true

  validates :name, :process, presence: true

  mount_uploader :description_file, FileUploader
end
