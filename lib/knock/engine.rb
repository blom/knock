module Knock
  class Engine < ::Rails::Engine
    config.middleware.use ActionDispatch::Cookies
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    isolate_namespace Knock
  end
end
