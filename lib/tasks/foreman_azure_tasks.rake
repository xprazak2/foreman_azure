# Tasks
namespace :foreman_azure do
  namespace :example do
    desc 'Example Task'
    task task: :environment do
      # Task goes here
    end
  end
end

# Tests
namespace :test do
  desc 'Test ForemanAzure'
  Rake::TestTask.new(:foreman_azure) do |t|
    test_dir = File.join(File.dirname(__FILE__), '../..', 'test')
    t.libs << ['test', test_dir]
    t.pattern = "#{test_dir}/**/*_test.rb"
    t.verbose = true
  end
end

namespace :foreman_azure do
  task :rubocop do
    begin
      require 'rubocop/rake_task'
      RuboCop::RakeTask.new(:rubocop_foreman_azure) do |task|
        task.patterns = ["#{ForemanAzure::Engine.root}/app/**/*.rb",
                         "#{ForemanAzure::Engine.root}/lib/**/*.rb",
                         "#{ForemanAzure::Engine.root}/test/**/*.rb"]
      end
    rescue
      puts 'Rubocop not loaded.'
    end

    Rake::Task['rubocop_foreman_azure'].invoke
  end
end

Rake::Task[:test].enhance do
  Rake::Task['test:foreman_azure'].invoke
end

load 'tasks/jenkins.rake'
if Rake::Task.task_defined?(:'jenkins:unit')
  Rake::Task['jenkins:unit'].enhance do
    Rake::Task['test:foreman_azure'].invoke
    Rake::Task['foreman_azure:rubocop'].invoke
  end
end
