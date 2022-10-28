# frozen_string_literal: true

module OperationNames
  module Auth
    module Users
      SIGNUP = 'SignupUser'
      SIGNIN = 'SigninUser'
    end
  end

  module Passports
    GET_PASSPORT = 'GetPassport'
    UPSERT = 'UpsertPassport'
  end

  module BusinessCards
    GET_BUSINESS_CARD = 'GetBusinessCard'
    UPSERT = 'UpsertBusinessCard'
    DELETE = 'DeleteBusinessCard'
  end

  module Phones
    CREATE = 'CreatePhone'
  end

  module Emails
    CREATE = 'CreateEmail'
  end

  module Users
    GET_USER = 'GetUser'
  end
end
