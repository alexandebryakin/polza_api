# frozen_string_literal: true

module Types
  class StatusType < Types::BaseEnum
    SUCCESS = 'success'
    FAILURE = 'failure'

    value SUCCESS
    value FAILURE
  end
end
