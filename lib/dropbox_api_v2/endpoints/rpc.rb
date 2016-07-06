module DropboxApiV2::Endpoints
  class Rpc < DropboxApiV2::Endpoints::Base
    def initialize(builder)
      @connection = builder.build("https://api.dropboxapi.com") do |c|
        c.request :encode_args_in_body
        c.response :decode_result
        c.response :json
      end
    end
  end
end
