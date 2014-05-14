require 'eye-control'

Eye.config do
  eye_control :enable => true, :host => "127.0.0.1"
end

Eye.application :app do
  process :process do
    start_command "sleep 100"
    daemonize true
    pid_file "/tmp/1.pid"
  end
end