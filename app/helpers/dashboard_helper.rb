module DashboardHelper

  if defined?(Diamond)
    include Diamond::ThesesHelper

    def theses_header_title
      t("label_thesis_title_#{current_user_permission(Diamond::Thesis)}")
    end
  end

  if defined?(Graphite)
    require 'graphite/enrollment/status_info'
    include Graphite::Enrollment::StatusInfo
  end

  CONTEXT_FILTERS = [:newest, :recently_accepted, :recently_updated, :recently_created, :unaccepted, :newest_enrollments].freeze

end
