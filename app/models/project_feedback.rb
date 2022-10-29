# frozen_string_literal: true

class ProjectFeedback < ApplicationRecord
  has_many :corrections, dependent: :destroy
  belongs_to :project_delivery
  accepts_nested_attributes_for :corrections

  def self.group_corrections(corrections, phase_instances)
    corrections
      .group_by { |correction| correction.criterion.section.name }
      .map { |key, value| CorrectionsGroupDto.new(section_name: key, corrections: value, phase_instances: phase_instances) }
  end

  class CorrectionsGroupDto
    attr_reader :section_name, :corrections, :phase_instances

    def initialize(section_name:, corrections:, phase_instances:)
      @section_name = section_name
      @corrections = corrections.sort_by { |c| c.criterion.order }.map { |c| CorrectionDto.new(correction: c, phase_instances: phase_instances) }
    end
  end

  class CorrectionDto
    attr_reader :correction, :phase_instances

    def initialize(correction:, phase_instances:)
      @id = correction.id
      @description = correction.criterion.description
      @comment = correction.comment
      @approved = correction.approved
      @obs_phases = get_obs_phases(correction, phase_instances)
    end

    def get_obs_phases(correction, phase_instances)
      algorithm_method_name = "build_#{correction.criterion.algorithm}_obs"
      phase_obs = []
      if phase_instances.present?
        phase_instances.each_with_index do |phase_instance, index|
          result = phase_instance.send(algorithm_method_name)
          phase_obs << { index: index, name: phase_instance.phase.name } if result.present? && phase_instance.phase.present? && phase_instance.phase.name.present?
        end
      end
      phase_obs
    end
  end
end
