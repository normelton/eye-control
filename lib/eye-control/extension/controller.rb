class Eye::Controller
  def set_opt_eye_control params = {}
    params[:enable]   ||= true
    params[:host]     ||= "127.0.0.1"
    params[:port]     ||= 6379
    params[:readonly] ||= false

    params[:port] = params[:port].to_i

    if params[:enable]
      start_eye_control params
    else
      stop_eye_control
    end
  end

  def start_eye_control config
    if @eye_control && @eye_control.actors.first.config != config
      stop_eye_control
    end

    if @eye_control.nil?
      @eye_control = Eye::RedisManager.supervise(config)
    end
  end

  def stop_eye_control
    if @eye_control
      @eye_control.stop
      @eye_control = nil
    end
  end
end