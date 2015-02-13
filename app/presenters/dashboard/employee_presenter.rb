class Dashboard::EmployeePresenter < Dashboard::DashboardPresenter

  private

  attr_accessor :context, :arg

  public

  def initialize(kontroler, ctxt, arg)
    super(kontroler)
    @context = ctxt
    @arg = arg
  end

  def proposed_theses
    @proposed_theses ||= theses_stats
    .count
  end

  def accepted_theses
    @accepted_theses ||= theses_stats
    .visible.count
  end

  def unaccepted_theses
    @unaccepted_theses ||= theses_stats
    .unaccepted.count
  end

  def not_chosen_theses
    @unaccepted_theses ||= theses_stats
    .recently_accepted.count
  end

  def chosen_theses
    @chosen_theses ||= theses_stats
    .assigned.count
  end

  def theses
    @theses ||= {}
    filter = kontroler.params[:filter]
    if filter.present?
      unless @theses[filter].present?
        if filter == "newest_enrollments"
          thesis_ids = Diamond::Thesis
          .public_send("#{context}_newest_enrollments", kontroler.current_user.verifable)
        else
          thesis_ids = Diamond::Thesis.public_send(filter)
          .by_supervisor(kontroler.current_user.verifable_id)
        end

        @theses[filter] = Diamond::Thesis.where(id: thesis_ids).include_peripherals
      else
        @theses[filter]
      end
    else
      @theses[:blank] ||= Diamond::Thesis
      .public_send("by_#{context}", arg)
      .pick_five.newest.include_peripherals
    end
  end

  private

  def theses_stats
    Diamond::Thesis.by_annual(kontroler.current_annual)
    .public_send("by_#{context}", arg)
  end

end
