# frozen_string_literal: true

module Types
  module Custom
    class PublicationStatusEnum < BaseEnum
      ::BusinessCard::PUBLICATION_STATUSES.each_key do |status|
        value status
      end
    end
  end
end
