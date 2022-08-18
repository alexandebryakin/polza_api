module Mutations
  class BaseMutation < GraphQL::Schema::Mutation
    
    private

    # @return [User]
    def current_user
      context[:current_user]
    end
  end
end
