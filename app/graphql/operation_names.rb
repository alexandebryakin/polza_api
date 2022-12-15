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
    GET_BUSINESS_CARDS = 'GetBusinessCards'
    UPSERT = 'UpsertBusinessCard'
    DELETE = 'DeleteBusinessCard'
    SHOW = 'ShowBusinessCard'
    ADD_TO_COLLECTION = 'AddToCollection'
    REMOVE_FROM_COLLECTION = 'RemoveFromCollection'
  end

  module Collections
    GET_COLLECTIONS = 'GetCollections'
  end

  module Phones
    CREATE = 'CreatePhone'
  end

  module Emails
    CREATE = 'CreateEmail'
  end

  module Users
    GET_USER = 'GetUser'
    CHANGE_CURRENT_USER_PASSWORD = 'ChangeCurrentUserPassword'
  end
end
