class Eye::RedisManager
  include Celluloid::IO
  include Celluloid::Logger
  include Celluloid::Notifications

  attr_accessor :config

  def initialize config
    @config = config

    async.init_redis
    async.init_subscriptions
    every(20) { keepalive }
    every(20) { broadcast_states }
  end

  def keepalive
    @redis.publish "eye:command:keepalive", {}
  end

  def init_redis
    @redis = ::Redis.new(:host => @config[:host], :port => @config[:port], :driver => :celluloid)
    @redis_sub = ::Redis.new(:host => @config[:host], :port => @config[:port], :driver => :celluloid)

    @redis_sub.psubscribe("eye:command:*") do |on|
      on.pmessage do |pattern, channel, msg|
        begin
          evt = JSON.parse msg
        rescue
          warn "Unable to parse incoming Redis message"
          next
        end

        next unless evt["host"] == Eye::Local.host
        next unless process = Eye::Control.process_by_full_name(evt["full_name"])

        if evt["event"] == "process:start" && ! @config[:readonly]
          info "Starting #{process.full_name}"
          process.send_command(:start)
        elsif evt["event"] == "process:stop" && ! @config[:readonly]
          info "Stopping #{process.full_name}"
          process.send_command(:stop)
        elsif evt["event"] == "process:restart" && ! @config[:readonly]
          info "Restarting #{process.full_name}"
          process.send_command(:restart)
        end
      end
    end
  end

  def init_subscriptions
    @subscription = subscribe("process:state", :broadcast_state)
  end

  def broadcast_states
    Eye::Control.all_processes.each{|p| broadcast_state(nil, p) }
  end

  def broadcast_state topic, process
    process_state = process.state_hash.merge(:readonly => @config[:readonly])
    
    @redis.hset "eye:processes", process.state_key, process_state.to_json
    @redis.publish "eye:process:state", process_state.to_json
  end

  def retract_process process
    @redis.hdel "eye:processes", process.state_key
  end
end