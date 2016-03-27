require 'deface'

module ForemanAzure
  class Engine < ::Rails::Engine
    engine_name 'foreman_azure'

    config.autoload_paths += Dir["#{config.root}/app/controllers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/helpers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/overrides"]

    # Add any db migrations
    initializer 'foreman_azure.load_app_instance_data' do |app|
      ForemanAzure::Engine.paths['db/migrate'].existent.each do |path|
        app.config.paths['db/migrate'] << path
      end
    end

    initializer 'foreman_azure.register_plugin', :before => :finisher_hook do |_app|
      Foreman::Plugin.register :foreman_azure do
        requires_foreman '>= 1.11'

        # Add permissions
        # security_block :foreman_azure do
        #   permission :view_foreman_azure, :'foreman_azure/hosts' => [:new_action]
        # end

        # Add a new role called 'Discovery' if it doesn't exist
        # role 'ForemanAzure', [:view_foreman_azure]

      end
    end

    # Precompile any JS or CSS files under app/assets/
    # If requiring files from each other, list them explicitly here to avoid precompiling the same
    # content twice.
    assets_to_precompile =
      Dir.chdir(root) do
        Dir['app/assets/javascripts/**/*', 'app/assets/stylesheets/**/*'].map do |f|
          f.split(File::SEPARATOR, 4).last
        end
      end
    initializer 'foreman_azure.assets.precompile' do |app|
      app.config.assets.precompile += assets_to_precompile
    end
    initializer 'foreman_azure.configure_assets', group: :assets do
      SETTINGS[:foreman_azure] = { assets: { precompile: assets_to_precompile } }
    end

    # Include concerns in this config.to_prepare block
    config.to_prepare do
      begin
        Host::Managed.send(:include, ForemanAzure::HostExtensions)
        HostsHelper.send(:include, ForemanAzure::HostsHelperExtensions)
      rescue => e
        Rails.logger.warn "ForemanAzure: skipping engine hook (#{e})"
      end
    end

    rake_tasks do
      Rake::Task['db:seed'].enhance do
        ForemanAzure::Engine.load_seed
      end
    end

    initializer 'foreman_azure.register_gettext', after: :load_config_initializers do |_app|
      locale_dir = File.join(File.expand_path('../../..', __FILE__), 'locale')
      locale_domain = 'foreman_azure'
      Foreman::Gettext::Support.add_text_domain locale_domain, locale_dir
    end
  end
end
