# frozen_string_literal: true

OUTPUT_DIR = 'app/graphql'

namespace :graphql do
  task schema_dump: :environment do
    require 'graphql/rake_task'

    GraphQL::RakeTask.new(
      schema_name: PolzaApiSchema.to_s,
      directory: OUTPUT_DIR,
      load_schema: lambda do |_task|
        require Rails.root.join('config/environment')
        PolzaApiSchema
      end
    )
    Rake::Task['graphql:schema:dump'].invoke
  end
end
