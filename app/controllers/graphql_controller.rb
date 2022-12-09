# frozen_string_literal: true

class GraphqlController < ApplicationController
  # If accessing from outside this domain, nullify the session
  # This allows for outside API access while preventing CSRF attacks,
  # but you'll have to authenticate your user separately
  # protect_from_forgery with: :null_session

  SKIPPABLE_OPERATION_NAMES = [
    OperationNames::Auth::Users::SIGNUP,
    OperationNames::Auth::Users::SIGNIN,
    OperationNames::BusinessCards::SHOW
  ].freeze

  def execute # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = {
      session:,
      current_user:
    }
    result = PolzaApiSchema.execute(query, variables:, context:, operation_name:)
    render json: result
  rescue JWT::ExpiredSignature
    head(:unauthorized)
  rescue StandardError => e
    raise e unless Rails.env.development?

    handle_error_in_development(e)
  end

  private

  # Handle variables in form data, JSON body, or a blank value
  def prepare_variables(variables_param) # rubocop:disable Metrics/MethodLength
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development(err)
    logger.error err.message
    logger.error err.backtrace.join("\n")

    render json: { errors: [{ message: err.message, backtrace: err.backtrace }], data: {} },
           status: :internal_server_error
  end

  def current_user # rubocop:disable Metrics/AbcSize
    # https://www.howtographql.com/graphql-ruby/4-authentication/
    return nil if SKIPPABLE_OPERATION_NAMES.include?(params[:operationName])

    token = (request.headers['Authorization'].presence || '').split(' ').last
    decoded = Auth::JwtDecode.new.call(token:)

    user_id = decoded['data']['user']['id']
    @current_user = User.find(user_id)
  rescue JWT::DecodeError => e
    # TODO: handle
    raise e
  end

  # def unauthorized!
  #   raise GraphQL::ExecutionError.new('Unauthorized', options: { status: :unauthorized, code: 401 })
  # end
end
