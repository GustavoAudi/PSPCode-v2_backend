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
      phase_obs = []
      algorithm = correction.criterion.algorithm
      return phase_obs unless algorithm.present?

      if phase_instances.present?
        algorithms = algorithm.split('_and_')
        algorithms.each do |a|
          algorithm_method_name = "build_#{a}_obs"

          phase_instances.each_with_index do |phase_instance, index|
            result = nil
            if correction.criterion.algorithm_type == 'phase'
              if phase_instance.method(algorithm_method_name).parameters.length.positive?
                result = 'any' if phase_instance.send(algorithm_method_name, phase_instances).any?
              else
                result = phase_instance.send(algorithm_method_name)
              end
            elsif phase_instance.defects.present?
              phase_instance.defects.each do |defect|
                result = if defect.method(algorithm_method_name).parameters.length.positive?
                           defect.send(algorithm_method_name, phase_instances)
                         else
                           defect.send(algorithm_method_name)
                         end
                break if result.present?
              end
            end

            phase_obs << { index: index, name: phase_instance.phase.name } if result.present? && phase_instance.phase.present? && phase_instance.phase.name.present?
          end
        end
      end

      phase_obs
    end
  end
end
