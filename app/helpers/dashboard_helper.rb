module DashboardHelper

  if defined?(Diamond)
    include Diamond::ThesesHelper

    def theses_header_title
      t("label_thesis_title_#{current_user_permission(Diamond::Thesis)}")
    end
  end

  if defined?(Graphite)
    def elective_block_enrollment_status(elective_mod)
      if current_user.student.has_pending_enrollments_for_module?(elective_mod)
        content_tag :span do
          I18n.t(:label_elective_block_enrollment_pending)
        end
      elsif elective_mod.student_enrolled?(current_user.verifable)
        content_tag :span, :class => "text-success" do
          I18n.t(:label_elective_block_enrollment_accepted)
        end
      else
        content_tag :span, :class => "text-danger" do
          I18n.t(:label_elective_block_student_enroll)
        end
      end
    end
  end

  CONTEXT_FILTERS = [:newest, :recently_accepted, :recently_updated, :recently_created, :unaccepted, :newest_enrollments].freeze

end
