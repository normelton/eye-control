class Eye::Process
  include Celluloid::Notifications

  state_machine :state do
    after_transition any => any, :do => :publish_state
  end

  def publish_state
    publish("process:state", self)
  end

  def state_key
    [Eye::Local.host, @config[:application], @config[:group], self.name].join(":")
  end

  def state_hash
    self.status_data.merge({
      :timestamp => Time.now.to_i,
      :host => Eye::Local.host,
      :application => @config[:application],
      :group => @config[:group],
      :full_name => self.full_name
    })
  end
end