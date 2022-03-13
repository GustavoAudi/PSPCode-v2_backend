module RailsAdmin
  module Config
    module Actions
      class ExportCourseData < RailsAdmin::Config::Actions::Base
        register_instance_option :visible? do
          object_class = bindings[:object].class
          authorized? && (object_class == Course)
        end

        register_instance_option :member do
          true
        end

        register_instance_option :controller do
          proc do
            csv_data = CourseExporterService.new(@object).perform

            send_data(csv_data, filename: "PSP_course_#{Time.now.to_i}.csv")
          end
        end

        register_instance_option :link_icon do
          'icon-share'
        end

        register_instance_option :pjax? do
          false
        end
      end
    end
  end
end
