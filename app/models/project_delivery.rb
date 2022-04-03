# frozen_string_literal: true

# == Schema Information
#
# Table name: project_deliveries
#
#  id                  :integer          not null, primary key
#  file                :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  assigned_project_id :integer          not null
#  version_number      :integer          default(1)
#
# Indexes
#
#  index_project_deliveries_on_assigned_project_id  (assigned_project_id)
#

class ProjectDelivery < ApplicationRecord
  has_many :phase_instances, dependent: :destroy
  has_many :statuses
  has_many :defects, through: :phase_instances
  belongs_to :assigned_project

  validates :assigned_project, presence: true

  before_create :assign_version_number

  mount_uploader :file, FileUploader

  def defects_from_phase(phase)
    defects.joins(phase_instance: :phase).where('phases.id = ?', phase.id)
  end

  def summary(project_delivery_id, user_id, assigned_project_id)
    assigned_project = AssignedProject.find(assigned_project_id)
    project_delivery = ProjectDelivery.find(project_delivery_id)
    user = User.find(user_id)
    phases = assigned_project.process.phases

    last_project_deliveries_ids = []
    user.assigned_projects.where('id <= ?', assigned_project_id).each do |previous_assigned_project|
      last_project_deliveries_ids << previous_assigned_project.project_deliveries.last.id
    end

    {
      phases: phase_summary(project_delivery, user, assigned_project, last_project_deliveries_ids,
                            phases),
      locs: locs_summary(project_delivery, user, last_project_deliveries_ids),
      defects_injected: defects_injected_summary(project_delivery,
                                                 user,
                                                 assigned_project,
                                                 last_project_deliveries_ids,
                                                 phases),
      defects_removed: defects_removed_summary(project_delivery,
                                               user,
                                               assigned_project,
                                               last_project_deliveries_ids,
                                               phases)
    }
  end

  def destroy_defects_injected_in_phase(phase_id)
    defects_ids = phase_instances
                  .joins(:defects)
                  .where(defects: { phase_injected_id: phase_id })
                  .pluck('defects.id')
    Defect.where(id: defects_ids).destroy_all
  end

  private

  def phase_summary(project_delivery, _user, _assigned_project, last_project_deliveries_ids, phases)
    result = []
    first_phase_instance = project_delivery.phase_instances.where(first: true).order(id: :desc)&.first
    phases.each do |phase|
      result << { metric: phase.name,
                  actual: project_delivery.phase_instances.where(phase:).sum(:elapsed_time),
                  plan: '',
                  to_date: PhaseInstance.where(project_delivery: last_project_deliveries_ids,
                                               phase:)
                                        .sum(:elapsed_time) }
    end

    result.push({ metric: 'TOTAL',
                  actual: result.map { |x| x[:actual] }.sum,
                  plan: first_phase_instance&.plan_time || 0,
                  to_date: result.map { |x| x[:to_date] }.sum })
    result
  end

  def locs_summary(project_delivery, _user, last_project_deliveries_ids)
    result = []
    first_phase_instance = project_delivery.phase_instances.where(first: true).order(id: :desc)&.first
    last_phase_instance = project_delivery.phase_instances.where(last: true).order(id: :desc)&.first
    base = first_phase_instance&.actual_base_loc || 0
    deleted = last_phase_instance&.deleted || 0
    modified = last_phase_instance&.modified || 0
    reused = last_phase_instance&.reused || 0
    plan_loc = first_phase_instance&.plan_loc || 0
    new_reusable = last_phase_instance&.new_reusable || 0
    total = last_phase_instance&.total || 0
    added = total - base + deleted - reused

    to_date_base = PhaseInstance.joins('INNER JOIN ( SELECT project_delivery_id, MAX(id) AS MaxId FROM phase_instances WHERE phase_instances.first = true GROUP BY project_delivery_id) groupedpi ON phase_instances.project_delivery_id = groupedpi.project_delivery_id AND phase_instances.id = groupedpi.MaxId ')
                                .where(project_delivery_id: last_project_deliveries_ids)
                                .sum(:actual_base_loc)

    to_date = PhaseInstance.select("SUM(reused) AS reused,
                                    SUM(total) AS total,
                                    SUM(modified) AS modified,
                                    SUM(deleted) AS deleted,
                                    SUM(new_reusable) AS new_reusable")
                           .joins('INNER JOIN ( SELECT project_delivery_id, MAX(id) AS MaxId FROM phase_instances WHERE last = true GROUP BY project_delivery_id) groupedpi ON phase_instances.project_delivery_id = groupedpi.project_delivery_id AND phase_instances.id = groupedpi.MaxId ')
                           .where(project_delivery_id: last_project_deliveries_ids)[0]

    to_date_added = to_date.total.to_i - to_date_base.to_i + to_date.deleted.to_i - to_date.reused.to_i

    result.push({ metric: 'BASE', actual: base, plan: '', to_date: '' })
    result.push({ metric: 'DELETED', actual: deleted, plan: '', to_date: '' })
    result.push({ metric: 'MODIFIED', actual: modified, plan: '', to_date: '' })
    result.push({ metric: 'ADDED', actual: added, plan: '', to_date: '' })
    result.push({ metric: 'REUSED', actual: reused, plan: '', to_date: to_date.reused })
    result.push({ metric: 'ADDED & MODIFIED',
                  actual: added + modified,
                  plan: plan_loc,
                  to_date: to_date_added.to_i + to_date.modified.to_i })
    result.push({ metric: 'NEW REUSABLE', actual: new_reusable, plan: '',
                  to_date: to_date.new_reusable.to_i })
    result.push({ metric: 'TOTAL', actual: total, plan: '', to_date: to_date.total })

    result
  end

  def defects_injected_summary(project_delivery, _user, _assigned_project, last_project_deliveries_ids, phases)
    result = []

    phases.each do |ph|
      actual = Defect.joins(:phase_instance)
                     .where(phase_instances: { project_delivery_id: project_delivery.id },
                            defects: { phase_injected_id: ph.id })
                     .count
      to_date = Defect.joins(:phase_instance)
                      .where(phase_instances: { project_delivery_id: last_project_deliveries_ids },
                             defects: { phase_injected_id: ph.id })
                      .count

      result.push({ metric: ph.name,
                    actual:,
                    plan: '',
                    to_date: })
    end

    result.push({ metric: 'TOTAL',
                  actual: result.map { |x| x[:actual] }.sum,
                  to_date: result.map { |x| x[:to_date] }.sum })

    result
  end

  def defects_removed_summary(project_delivery, _user, _assigned_project, last_project_deliveries_ids, phases)
    result = []

    phases.each do |ph|
      actual = Defect.joins(:phase_instance)
                     .where(phase_instances: { project_delivery_id: project_delivery.id,
                                               phase_id: ph.id })
                     .count
      to_date = Defect.joins(:phase_instance)
                      .where(phase_instances: { project_delivery_id: last_project_deliveries_ids,
                                                phase_id: ph.id })
                      .count

      result.push({ metric: ph.name,
                    actual:,
                    plan: '',
                    to_date: })
    end

    result.push({ metric: 'TOTAL',
                  actual: result.map { |x| x[:actual] }.sum,
                  to_date: result.map { |x| x[:to_date] }.sum })

    result
  end

  def assign_version_number
    self.version_number = assigned_project.project_deliveries.count + 1
  end
end
