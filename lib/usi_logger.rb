module UsiLogger

  def usi_logger(exception, params)
    if defined?(Airbrake)
      Airbrake.notify_or_ignore( exception,
        :parameters    => params,
        :cgi_data      => ENV.to_hash
      )
    else
      Rails.logger.error "Error: #{exception}"
      Rails.logger.error "Params: #{params}"
    end
  end
end
