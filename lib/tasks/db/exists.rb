# frozen_string_literal: true

namespace :db do
  desc 'Checks to see if the database exists'
  task :exists do
    Rake::Task['environment'].invoke
    ActiveRecord::Base.connection
  rescue StandardError
    exit 1 # rubocop:disable Rails/Exit
  else
    exit 0 # rubocop:disable Rails/Exit
  end
end
