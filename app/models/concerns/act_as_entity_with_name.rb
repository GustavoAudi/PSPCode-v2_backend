

module ActAsEntityWithName
  extend ActiveSupport::Concern

  # Method added to display entities correctly in Rails_admin
  def name
    return unless first_name.present?

    last_name.present? ? "#{first_name} #{last_name}" : first_name
  end
end
