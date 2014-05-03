module DashboardHelper

  if defined?(Diamond)
    include Diamond::ThesesHelper
  end

  CONTEXT_FILTERS = [:newest, :recently_accepted, :recently_updated, :recently_created, :unaccepted, :newest_enrollments].freeze

end
