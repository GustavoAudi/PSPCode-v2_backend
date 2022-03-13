#Creating courses
Course.create! name: 'PSP 2018',
               description: 'Course to learn psp',
               start_date: Date.today,
               end_date: Date.today + 6.months,
               additional_notes: 'This course will not include X'

Course.create! name: 'PSP 2017',
               description: 'Course to learn psp',
               start_date: Date.today - 1.year,
               end_date: Date.today - 1.year + 6.months,
               additional_notes: ''

Course.create! name: 'PSP 2016',
               description: 'Course to learn psp',
               end_date: Date.today - 2.year + 6.months,
               start_date: Date.today - 2.year,
               additional_notes: ''

# Creating phases
Phase.create! name: 'PLAN', description: 'This phase is to understand the excercise', order: 1, first: true, last: false

Phase.create! name: 'DESIGN', description: 'This phase is to think how to solve the excercise', order: 2, first: false, last: false

Phase.create! name: 'CODE', description: 'This phase is to start coding', order: 3, first: false, last: false

Phase.create! name: 'COMPILE', description: 'This phase is to compile the code (if needed)', order: 4, first: false, last: false

Phase.create! name: 'UNIT TEST', description: 'This phase is to test the code', order: 5, first: false, last: false

Phase.create! name: 'POST MORTEN', description: 'This phase if estimations were correct', order: 5, first: false, last: true

# Creating Processes
PspProcess.create! name: 'PSP0.0', has_plan_time: false, has_plan_loc: false, has_pip: false

PspProcess.create! name: 'PSP0.1', has_plan_time: true, has_plan_loc: true, has_pip: true

PspProcess.create! name: 'PSP1.0', has_plan_time: true, has_plan_loc: true, has_pip: false

# Assign phases to processes
PspProcess.all.each do |process|
  Phase.all.each do |phase|
    process.phases << phase
  end
end

Project.create! name: 'Project 1', process: PspProcess.first, description_file: Rails.root.join('public/files/e1.pdf').open

Project.create! name: 'Project 2', process: PspProcess.second, description_file: Rails.root.join('public/files/e2.pdf').open

Project.create! name: 'Project 3', process: PspProcess.third, description_file: Rails.root.join('public/files/e3.pdf').open

Project.create! name: 'Project 4', process: PspProcess.third, description_file: Rails.root.join('public/files/e4.pdf').open

Project.create! name: 'Project 5', process: PspProcess.third, description_file: Rails.root.join('public/files/e5.pdf').open

Project.create! name: 'Project 6', process: PspProcess.third, description_file: Rails.root.join('public/files/e6.pdf').open

Project.create! name: 'Project 7', process: PspProcess.third, description_file: Rails.root.join('public/files/e7.pdf').open

Project.create! name: 'Project 8', process: PspProcess.third, description_file: Rails.root.join('public/files/e8.pdf').open

# Assign project to course
Course.all.each do |course|
  index = 0
  Project.all.each do |project|
    index = index + 1
    CourseProjectInstance.create! project: project, course: course, start_date: Date.today + index.weeks, end_date: Date.today + (index + 1).weeks
  end
end

# Creating professors
Professor.create! first_name: 'Silvana',
                  last_name: 'Moreno',
                  email: 'silvana@fing.edu.uy',
                  password: :password

Professor.create! first_name: 'Leticia',
                  last_name: 'Perez',
                  email: 'leticia@fing.edu.uy',
                  password: :password

Professor.create! first_name: 'Diego',
                  last_name: 'Vallespir',
                  email: 'diego@fing.edu.uy',
                  password: :password


# Assign Professor to course
Course.all.each do |course|
  Professor.all.each do |professor|
    course.professors << professor
  end
end

#Creating users
User.create! first_name: 'Guillermo', last_name: 'Tavidian', password: :password, email: 'guillermo.tavidian@fing.edu.uy', approved_subjects: ['Calc 2'], programming_language: 'React', have_a_job: true, job_role: 'CTO Infocasas', academic_experience: 'Finishing University', programming_experience: 'senior', course: Course.first, professor: Professor.first

User.create! first_name: 'Guillermo', last_name: 'kuster', password: :password, email: 'guillermo.kuster@fing.edu.uy', approved_subjects: ['Calc 2'], programming_language: 'Ruby', have_a_job: true, job_role: 'Senior Team Leader Rootstrap', academic_experience: 'Finishing University', programming_experience: 'senior', course: Course.first, professor: Professor.first

User.create! first_name: 'John', last_name: 'Doe', password: :password, email: 'John.doe@fing.edu.uy', approved_subjects: [], programming_language: 'PHP', have_a_job: true, job_role: 'Developer', academic_experience: 'Finishing University', programming_experience: 'senior', course: Course.first, professor: Professor.first

User.create! first_name: 'Jane', last_name: 'Doe', password: :password, email: 'Jane.doe@fing.edu.uy', approved_subjects: [], programming_language: 'PHP', have_a_job: true, job_role: 'Developer', academic_experience: 'Finishing University', programming_experience: 'senior', course: Course.first, professor: Professor.first

# Assign projects to students
Course.first.students.each do |student|
  Course.first.course_projects.each do |course_project|
    AssignedProject.create! user: student, course_project_instance: course_project
  end
end

#Create sample phases to first two students
User.first(2).each do |user|
  project_delivery = user.assigned_projects.first.project_deliveries.first
  PhaseInstance.create! start_time: Time.now, end_time: Time.now + 5.minutes, phase: Phase.first, project_delivery: project_delivery, plan_time: 8, plan_loc: 100

  PhaseInstance.create! start_time: Time.now + 10.minutes, end_time: Time.now + 20.minutes, phase: Phase.second, project_delivery: project_delivery, comments: 'Nice Phase'

 last_phase = PhaseInstance.create! start_time: Time.now + 20.minutes, end_time: Time.now + 55.minutes, interruption_time: 2, phase: Phase.third, project_delivery: project_delivery, comments: 'Incredible Phase'

  # Create defects associated to phase instances
 Defect.create! discovered_time: Time.now + 23.minutes, phase_injected: Phase.second, phase_instance: last_phase, defect_type: 'Syntax', fix_defect: 0, fixed_time: Time.now + 25.minutes, description: 'Forgot ;'

 Defect.create! discovered_time: Time.now + 26.minutes, phase_injected: Phase.second, phase_instance: last_phase, defect_type: 'Syntax', fix_defect: 0, fixed_time: Time.now + 27.minutes, description: 'Forgot ;'

 Defect.create! discovered_time: Time.now + 28.minutes, phase_injected: Phase.second, phase_instance: last_phase, defect_type: 'Syntax', fix_defect: 0, fixed_time: Time.now + 31.minutes, description: 'Forgot ;'
end

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

