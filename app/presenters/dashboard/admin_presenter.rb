class Dashboard::AdminPresenter < Dashboard::DashboardPresenter

  def view_name
    "admin"
  end

  def theses
    @theses ||= {}
    filter = kontroler.params[:filter]
    if filter.present?
      unless @theses[filter].present?
        thesis_ids = Diamond::Thesis.public_send(filter).pick_five

        @theses[filter] = Diamond::Thesis.where(id: thesis_ids.to_a).include_peripherals
      else
        @theses[filter]
      end
    else
      @theses[:blank] ||= theses_rel
    end
  end

  protected

  def theses_rel
    Diamond::Thesis.include_peripherals.newest.pick_five
  end

end
