require 'oauth2'

module DropboxApiV2

  class Authenticator < OAuth2::Client
    def initialize(client_id, client_secret, session, redirect_uri)
      @oauth_client = OAuth2::Client.new(client_id, client_secret, {
        :authorize_url => 'https://www.dropbox.com/1/oauth2/authorize',
        :token_url => 'https://api.dropboxapi.com/1/oauth2/token'
      })

      @session = session
      @redirect_uri = redirect_uri

      @oauth_client
    end

    def authorize_url(url_state)
      csrf_token = SecureRandom.hex(16)
      @session[:dropbox_auth_csrf_token] = csrf_token
      state = csrf_token
      state += "|" + url_state unless url_state.nil?

      params = {state: state, redirect_uri: @redirect_uri}
      @session[:dropbox_auth_csrf_token] = csrf_token
      

      @oauth_client.auth_code.authorize_url(params)
    end

    def get_token(query_params)
      csrf_token_from_session = @session[:dropbox_auth_csrf_token]

      state = query_params['state']
      if state.nil?
        raise DropboxApiV2::Errors::BadRequestError.new("Missing query parameter 'state'.")
      end

      error = query_params['error']
      error_description = query_params['error_description']
      code = query_params['code']

      if not error.nil? and not code.nil?
        raise DropboxApiV2::Errors::BadRequestError.new("Query parameters 'code' and 'error' are both set;" +
                                  " only one must be set.")
      end
      if error.nil? and code.nil?
        raise DropboxApiV2::Errors::BadRequestError.new("Neither query parameter 'code' or 'error' is set.")
      end

      # Check CSRF token
      if csrf_token_from_session.nil?
        raise DropboxApiV2::Errors::BadStateError.new("Missing CSRF token in session.");
      end
      unless csrf_token_from_session.length > 20
        raise RuntimeError.new("CSRF token unexpectedly short: #{csrf_token_from_session.inspect}")
      end

      split_pos = state.index('|')
      if split_pos.nil?
        given_csrf_token = state
        url_state = nil
      else
        given_csrf_token, url_state = state.split('|', 2)
      end
      
      if !ActiveSupport::SecurityUtils.secure_compare(csrf_token_from_session, given_csrf_token)
        raise DropboxApiV2::Errors::CsrfError.new("Expected #{csrf_token_from_session.inspect}, " +
                            "got #{given_csrf_token.inspect}.")
      end
      @session.delete(@csrf_token_session_key)

      # Check for error identifier

      if not error.nil?
        if error == 'access_denied'
          # The user clicked "Deny"
          if error_description.nil?
            raise DropboxApiV2::Errors::NotApprovedError.new("No additional description from Dropbox.")
          else
            raise DropboxApiV2::Errors::NotApprovedError.new("Additional description from Dropbox: #{error_description}")
          end
        else
          # All other errors.
          full_message = error
          if not error_description.nil?
            full_message += ": " + error_description
          end
          raise DropboxApiV2::Errors::ProviderError.new(full_message)
        end
      end



      auth = @oauth_client.auth_code.get_token(code, {redirect_uri: @redirect_uri})

     return auth.token, auth.params["uid"], url_state
    end
  end
end
