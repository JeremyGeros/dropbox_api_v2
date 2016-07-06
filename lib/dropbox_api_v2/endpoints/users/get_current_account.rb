module DropboxApiV2::Endpoints::Users
  class GetCurrentAccount < DropboxApiV2::Endpoints::Rpc
    Method      = :post
    Path        = "/2/users/get_current_account".freeze
    ResultType  = DropboxApiV2::Metadata::BasicAccount
    ErrorType   = DropboxApiV2::Errors::GetAccountError

    # @method get_current_account
    # Get information about a user's current account.
    #
    # @return [BasicAccount] Basic information about any account.
    add_endpoint :get_current_account do |options = {}|
      perform_request options
    end
  end
end
