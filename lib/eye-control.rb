require "eye"
require "json"
require "celluloid/redis"
require "celluloid/io"

require_relative "eye-control/version.rb"

require_relative "eye-control/extension/controller.rb"
require_relative "eye-control/extension/config_opts.rb"
require_relative "eye-control/extension/process.rb"

require_relative "eye-control/redis_manager.rb"