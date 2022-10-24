class Correction < ApplicationRecord
  belongs_to :criterion
  belongs_to :project_feedback

  def self.to_h(correction)
    { "id" => correction["id"], "approved" => correction["approved"], "comment" => correction["comment"] }
  end
end
