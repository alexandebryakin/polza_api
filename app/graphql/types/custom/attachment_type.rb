# frozen_string_literal: true

# https://sulmanweb.com/file-uploading-in-graphql-api-in-rails-with-activestorage/
module Types
  module Custom
    class AttachmentType < Types::BaseObject
      field :id, Integer, null: false
      field :documentable_type, String, null: true
      field :documentable_id, ID, null: true
      field :content_type, String, null: true
      field :url, String, null: false
      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  
      def url
        return object.service_url if Rails.env.production?
          
        Rails.application.routes.url_helpers.rails_blob_url(object, host: ENV.fetch('HOST'))
      end
  
      def content_type
        object&.content_type
      end
    end
  end
end
