# frozen_string_literal: true

module Types
  module Custom
    class CollectionKindEnum < BaseEnum
      ::Collection::KINDS.each_key do |status|
        value status
      end
    end
  end
end
