module DropboxApiV2::Metadata

  class ImageAndFile < Base
    field :body, String
    field :metadata, DropboxApiV2::Metadata::File
  end
end
