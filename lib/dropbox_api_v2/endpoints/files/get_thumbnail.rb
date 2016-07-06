module DropboxApiV2::Endpoints::Files
  class GetThumbnail < DropboxApiV2::Endpoints::ContentDownload
    Method      = :post
    Path        = "/2/files/get_thumbnail".freeze
    ResultType  = DropboxApiV2::Metadata::ImageAndFile
    ErrorType   = DropboxApiV2::Errors::PreviewError

    # @method get_thumbnail(path, options = {})
    # Get a thumbnail for an image.
    #
    # This method currently supports files with the following file extensions:
    # jpg, jpeg, png, tiff, tif, gif and bmp. Photos that are larger than 20MB
    # in size won't be converted to a thumbnail.
    #
    # @param path [String] The path to the image file you want to thumbnail.
    # @option format [:jpeg, :png] The format for the thumbnail image, jpeg
    #   (default) or png. For images that are photos, jpeg should be preferred,
    #   while png is better for screenshots and digital arts. The default is
    #   :jpeg.
    # @option size [:w32h32, :w64h64, :w128h128, :w640h480, :w1024h768] The
    #   size for the thumbnail image. The default is :w64h64
    add_endpoint :get_thumbnail do |path, options = {}|
      validate_options(options)
      options[:format] ||= :jpeg
      options[:size] ||= :w64h64

      perform_request(nil, "Dropbox-API-Arg" => options.merge({
        :path => path
      }).to_json)
    end

    private

    def validate_options(options)
      valid_option_keys = [:format, :size]

      options.keys.each do |key|
        unless valid_option_keys.include? key.to_sym
          raise ArgumentError, "Invalid option `#{key}`"
        end
      end
    end
  end
end
