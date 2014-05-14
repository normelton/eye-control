Eye Control
===

A plugin for [Eye](http://github.com/kostya/eye) that provides centralized process monitoring and management. The GUI component is located at http://github.com/normelton/eye-control-gui.

### Eye Configuration

Each Eye server will report its state to a centralized [Redis](http://redis.io) Redis server. This must be configured on each Eye server:

```ruby
Eye.config do
  logger '/tmp/eye.log'
  eye_control :enable => true, :host => '192.168.1.5'
end
```

By default, the Eye process will also respond to start / stop / restart requests coming from Eye Control. This can be disabled by running in read-only mode:

```ruby
Eye.config do
  logger '/tmp/eye.log'
  eye_control :enable => true, :host => '192.168.1.5', :readonly => true
end
```

### Security

Right now, there are no security measures in place. Ensure that only legitimate clients can connect to your Eye Control and Redis servers.
