class CourseExporterService
  attr_reader :record

  def initialize(record)
    @record = record
  end

  def perform
    generate_csv
  end

  def generate_csv
    students = record.students
    CSV.generate(headers: true) do |csv|
      csv << headers
      students.each do |student|
        student.assigned_projects.order(:id).each do |assigned_project|
          current_project_delivery = assigned_project.current_project_delivery
          phases = assigned_project.process.phases
          phases.order(:order).each do |phase|
            csv << student_project_phase_row(student, current_project_delivery, phase)
          end
        end
      end
    end
  end

  private

  def headers
    attributes.map(&:titleize)
  end

  def attributes
    %w[ID_estudiante Nombre_Ejercicio Nombre_Fase Actual_Time_de_Fase
       Cant_defectos_removidos_en_Fase]
  end

  def student_project_phase_row(student, project_delivery, phase)
    [student.id,
     project_delivery.assigned_project.course_project_instance.name,
     phase.name,
     project_delivery.phase_instances.where(phase:).sum(:elapsed_time),
     Defect.joins(:phase_instance)
           .where(phase_instances: { project_delivery_id: project_delivery.id,
                                     phase_id: phase.id }).count]
  end
end
