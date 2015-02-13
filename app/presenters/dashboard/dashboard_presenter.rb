class Dashboard::DashboardPresenter

  CONTEXT_FILTERS = [:newest, :recently_accepted, :recently_updated,
                     :recently_created, :unaccepted,
                     :newest_enrollments].freeze

  protected

  attr_reader :kontroler

  def page
    @page ||= kontroler.params[:page].to_i < 1 ? 1 : kontroler.params[:page]
  end

  def per_page
    @per_page ||= kontroler.params[:per_page].to_i < 1 ? 10 : kontroler.params[:per_page]
  end

  public

  def initialize(dashboard_kontroler)
    @kontroler = dashboard_kontroler
  end

end
