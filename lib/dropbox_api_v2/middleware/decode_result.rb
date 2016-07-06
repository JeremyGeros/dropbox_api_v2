module DropboxApiV2::MiddleWare
  class DecodeResult < Faraday::Middleware
    def call(rq_env)
      @app.call(rq_env).on_complete do |rs_env|
        if !rs_env[:response_headers]['Dropbox-Api-Result'].nil?
          metadata = decode rs_env[:response_headers]['Dropbox-Api-Result']
          body = rs_env[:body]
          rs_env[:api_result] = {"metadata" => metadata, "body" => body}
        elsif rs_env[:response_headers]['content-type'] == 'application/json'
          rs_env[:api_result] = decode rs_env[:body]
        end
      end
    end

    def decode(json)
      # Dropbox may send a response with the string 'null' in its body, this
      # would be a void result. `add_folder_member` is an example of an
      # endpoint without return values.
      if json.is_a?(String)
        if json == "null"
          {}
        else
          JSON.parse json
        end
      else
        json
      end
    end
  end

  Faraday::Response.register_middleware :decode_result => DecodeResult
end
