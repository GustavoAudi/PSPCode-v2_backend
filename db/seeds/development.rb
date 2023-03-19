# Clean all data bases

Phase.destroy_all
Project.destroy_all
User.destroy_all
Professor.destroy_all
Status.destroy_all
MessageNotification.destroy_all
EventNotification.destroy_all
Course.destroy_all
CourseProjectInstance.destroy_all
AssignedProject.destroy_all
Message.destroy_all
ProjectDelivery.destroy_all
PhaseInstance.destroy_all
Defect.destroy_all
ProfessorCourse.destroy_all
PspProcess.destroy_all
Section.destroy_all
Criterion.destroy_all
ProjectFeedback.destroy_all
Correction.destroy_all

# Creating courses
Course.create! name: 'PSP 2020',
               description: 'Course to learn psp',
               start_date: Date.today - 2.months,
               end_date: Date.today + 4.months,
               additional_notes: 'This course will not include X'

Course.create! name: 'PSP 2021',
               description: 'Course to learn psp',
               start_date: Date.today - 1.years,
               end_date: Date.today + 4.months,
               additional_notes: ''

Course.create! name: 'PSP 2022',
               description: 'Course to learn psp',
               start_date: Date.today - 4.months,
               end_date: Date.today + 4.months,
               additional_notes: ''

# Creating phases
Phase.create! name: 'PLAN', description: 'This phase is to understand the excercise', order: 1,
              first: true, last: false

Phase.create! name: 'DESIGN', description: 'This phase is to think how to solve the excercise',
              order: 2, first: false, last: false

Phase.create! name: 'CODE', description: 'This phase is to start coding', order: 3, first: false,
              last: false

Phase.create! name: 'COMPILE', description: 'This phase is to compile the code (if needed)',
              order: 4, first: false, last: false

Phase.create! name: 'UNIT TEST', description: 'This phase is to test the code', order: 5,
              first: false, last: false

Phase.create! name: 'POST MORTEM', description: 'This phase if estimations were correct', order: 6,
              first: false, last: true

# Creating Processes
PspProcess.create! name: 'PSP0.0', has_plan_time: true, has_plan_loc: false, has_pip: false

PspProcess.create! name: 'PSP0.1', has_plan_time: true, has_plan_loc: true, has_pip: true

# Assign phases to processes
PspProcess.all.each do |process|
  Phase.all.each do |phase|
    process.phases << phase
  end
end

Project.create! name: 'Project 1', process: PspProcess.first,
                description_file: Rails.root.join('public/files/e1.pdf').open

Project.create! name: 'Project 2', process: PspProcess.second,
                description_file: Rails.root.join('public/files/e2.pdf').open

Project.create! name: 'Project 3', process: PspProcess.first,
                description_file: Rails.root.join('public/files/e3.pdf').open

Project.create! name: 'Project 4', process: PspProcess.first,
                description_file: Rails.root.join('public/files/e4.pdf').open

Project.create! name: 'Project 5', process: PspProcess.second,
                description_file: Rails.root.join('public/files/e5.pdf').open

Project.create! name: 'Project 6', process: PspProcess.second,
                description_file: Rails.root.join('public/files/e6.pdf').open

Project.create! name: 'Project 7', process: PspProcess.first,
                description_file: Rails.root.join('public/files/e7.pdf').open

Project.create! name: 'Project 8', process: PspProcess.first,
                description_file: Rails.root.join('public/files/e8.pdf').open

# Assign project to course
Course.all.each do |course|
  Project.all.each do |project|
    CourseProjectInstance.create(project:, course:,
                                 start_date: Date.today - 1.days, end_date: course.end_date - 2.weeks)
  end
end

# Creating professors
Professor.create! first_name: 'Silvana',
                  last_name: 'Moreno',
                  email: 'silvana@mail.com',
                  password: 'admin'

Professor.create! first_name: 'Leticia',
                  last_name: 'Perez',
                  email: 'leticia@mail.com',
                  password: 'admin'

Professor.create! first_name: 'professor',
                  last_name: 'lastname',
                  email: 'admin@mail.com',
                  password: 'admin'

# Assign Professor to course
Course.all.each do |course|
  Professor.all.each do |professor|
    course.professors << professor
  end
end

# Creating users
User.create! first_name: 'gustavo', last_name: 'audi', password: '12345678',
             email: 'gusta97-2009@hotmail.com', approved_subjects: ['Calc 2'], programming_language: 'Java', have_a_job: true, job_role: 'Software Engineer', academic_experience: 'Finishing University', programming_experience: 'senior', course: Course.first, professor: Professor.third
User.create! first_name: 'lia', last_name: 'malvarez', password: '12345678',
             email: 'student2@mail.com', approved_subjects: ['Arqui'], programming_language: 'React', have_a_job: true, job_role: 'Manager', academic_experience: 'Engineer', programming_experience: 'senior', course: Course.first, professor: Professor.third
User.create! first_name: 'student3', last_name: 'lastname', password: '12345678',
             email: 'student3@mail.com', approved_subjects: ['Calc 2'], programming_language: 'Java', have_a_job: true, job_role: 'Software Engineer', academic_experience: 'Finishing University', programming_experience: 'senior', course: Course.third, professor: Professor.second
User.create! first_name: 'student4', last_name: 'lastname', password: '12345678',
             email: 'student4@mail.com', approved_subjects: ['Calc 2'], programming_language: 'C++', have_a_job: true, job_role: 'Manager', academic_experience: 'Engineer', programming_experience: 'senior', course: Course.second, professor: Professor.first

# Assign projects to students
Course.first.students.each do |student|
  Course.first.course_projects.each do |course_project|
    AssignedProject.create! user: student, course_project_instance: course_project
  end
end

Section.create! name: 'Programa y Resultado de Test'
Criterion.create! description: 'El programa resulta ser funcional.',
                  section: Section.find_by_name('Programa y Resultado de Test'),
                  order: 1
Criterion.create! description: 'Todos los test requeridos fueron ejecutados.',
                  section: Section.find_by_name('Programa y Resultado de Test'),
                  order: 2
Criterion.create! description: 'La salida actual es correcta para cada uno de los test.',
                  section: Section.find_by_name('Programa y Resultado de Test'),
                  order: 3
Criterion.create! description: 'El código es compatible con el estándar de codificación.',
                  section: Section.find_by_name('Programa y Resultado de Test'),
                  order: 4, only_in_psp01: true
Criterion.create! description: 'Los resultados de los test son consistentes con el estándar de conteo.',
                  section: Section.find_by_name('Programa y Resultado de Test'),
                  order: 5

Section.create! name: 'Log de Tiempo'
Criterion.create! description: 'Los datos del tiempo se registran en todas las fases del proceso.',
                  section: Section.find_by_name('Log de Tiempo'),
                  order: 1
Criterion.create! description: 'Las etapas del proceso siguen una secuencia adecuada.',
                  section: Section.find_by_name('Log de Tiempo'),
                  order: 2
Criterion.create! description: 'Los tiempos son registrados en los pasos correctos del proceso.',
                  section: Section.find_by_name('Log de Tiempo'),
                  order: 3, algorithm: 5, algorithm_type: 0
Criterion.create! description: 'Los tiempos de las interrupciones son registrados de forma apropiada.',
                  section: Section.find_by_name('Log de Tiempo'),
                  order: 4, algorithm: 2, algorithm_type: 0
Criterion.create! description: 'Los datos del tiempo son completos y razonables.',
                  section: Section.find_by_name('Log de Tiempo'),
                  order: 5, algorithm: 0, algorithm_type: 0
Criterion.create! description: 'Los datos fueron registrados a medida se realizaba el trabajo.',
                  section: Section.find_by_name('Log de Tiempo'),
                  order: 6

Section.create! name: 'Log de Defectos'
Criterion.create! description: 'Todos los defectos tienen la información de registro solicitada.',
                  section: Section.find_by_name('Log de Defectos'),
                  order: 1
Criterion.create! description: 'Los defectos fueron inyectados antes de ser removidos.',
                  section: Section.find_by_name('Log de Defectos'),
                  order: 2, algorithm: 7, algorithm_type: 1
Criterion.create! description: 'Todos los defectos tienen tiempo de corrección.',
                  section: Section.find_by_name('Log de Defectos'),
                  order: 3
Criterion.create! description: 'Los defectos inyectados en compilación y test tienen “fix defect” asociado.',
                  section: Section.find_by_name('Log de Defectos'),
                  order: 4
Criterion.create! description: 'Los defectos son descritos adecuadamente.',
                  section: Section.find_by_name('Log de Defectos'),
                  order: 5
Criterion.create! description: 'El tipo de defecto es consistente con la descripción.',
                  section: Section.find_by_name('Log de Defectos'),
                  order: 6
Criterion.create! description: 'El tipo de defecto es consistente con la fase de inyección.',
                  section: Section.find_by_name('Log de Defectos'),
                  order: 7
Criterion.create! description: 'El tipo de defecto es asignado consistentemente.',
                  section: Section.find_by_name('Log de Defectos'),
                  order: 8

Section.create! name: 'Formulario PIP'
Criterion.create! description: 'El formulario PIP está completo.',
                  section: Section.find_by_name('Formulario PIP'),
                  order: 1, only_in_psp01: true
Criterion.create! description: 'Los registros del PIP muestran perspicacia y reflexión.',
                  section: Section.find_by_name('Formulario PIP'),
                  order: 2

Section.create! name: 'Planning Summary'
Criterion.create! description: 'El tiempo total planificado fue ingresado correctamente.',
                  section: Section.find_by_name('Planning Summary'),
                  order: 1, algorithm: 3, algorithm_type: 0
Criterion.create! description: 'Los tamaños planificado y actual están ingresados correctamente.',
                  section: Section.find_by_name('Planning Summary'),
                  order: 2, algorithm: 4, only_in_psp01: true, algorithm_type: 0

Section.create! name: 'Chequeo de Consistencia'
Criterion.create! description: 'Los defectos removidos son consistentes con los tiempos en las fases de compilación y test.',
                  section: Section.find_by_name('Chequeo de Consistencia'),
                  order: 1, algorithm: 6, algorithm_type: 1
Criterion.create! description: 'El total del tiempo de corrección en cada fase es menor que el tiempo total dedicado a la misma.',
                  section: Section.find_by_name('Chequeo de Consistencia'),
                  order: 2, algorithm: 1, algorithm_type: 0
Criterion.create! description: 'Los datos de los defectos y las fases son consistentes con el log de tiempos.',
                  section: Section.find_by_name('Chequeo de Consistencia'),
                  order: 3
Criterion.create! description: 'Planning summary es consistente con el log de tiempos.',
                  section: Section.find_by_name('Chequeo de Consistencia'),
                  order: 4
Criterion.create! description: 'Planning summary es consistente con el log de defectos.',
                  section: Section.find_by_name('Chequeo de Consistencia'),
                  order: 5

Section.create! name: 'General'
Criterion.create! description: 'Se siguió el proceso definido.',
                  section: Section.find_by_name('General'),
                  order: 1
Criterion.create! description: 'Los datos recogidos del proceso son completos, precisos y coherentes.',
                  section: Section.find_by_name('General'),
                  order: 2
Criterion.create! description: 'El estudiante hizo su propio trabajo.',
                  section: Section.find_by_name("General"),
                  order: 3