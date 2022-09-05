# frozen_string_literal: true

class GraphqlSchemaController < ApplicationController
  GRAPHQL_SCHEMA_RELATIVE_PATH = 'app/graphql/schema.json'

  def graphql_schema
    schema = File.open(Rails.root.join(GRAPHQL_SCHEMA_RELATIVE_PATH))

    render(json: JSON.parse(schema.read))
  end
end
