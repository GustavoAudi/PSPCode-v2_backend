class ProjectFeedback < ApplicationRecord
  has_many :corrections, dependent: :destroy
  belongs_to :project_delivery
  accepts_nested_attributes_for :corrections

  def self.group_corrections(corrections)
    corrections
      .group_by { |correction| correction.criterion.section.name }
      .map { |key, value| CorrectionsGroupDto.new(section_name: key, corrections: value) }
  end

  class CorrectionsGroupDto
    attr_reader :section_name, :corrections

    def initialize(section_name:, corrections:)
      @section_name = section_name
      @corrections = corrections.map { |correction| CorrectionDto.new(correction: correction) }
    end

  end

  class CorrectionDto
    attr_reader :correction

    # TODO
    def getObsPhases(criterion_id)
      "phases"
    end

    def initialize(correction:)
      @id = correction.id
      @description = correction.criterion.description
      @comment = correction.comment
      @approved = correction.approved
      @obs_phases = getObsPhases(correction.criterion_id)
    end
  end

end
