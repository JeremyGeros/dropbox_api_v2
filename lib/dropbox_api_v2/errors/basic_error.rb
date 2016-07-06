module DropboxApiV2::Errors
  class BasicError < StandardError
    def initialize(message, metadata)
      @metadata = metadata
      super message
    end

    class << self
      def build(message, metadata)
        subtype, metadata = find_subtype metadata

        if subtype.nil?
          new message, metadata
        else
          subtype.build message, metadata
        end
      end

      def find_subtype(metadata)
        if defined? self::ErrorSubtypes
          discriminator = metadata[".tag"]
          metadata = metadata[discriminator] unless metadata[discriminator].nil?
          [self::ErrorSubtypes[discriminator.to_sym], metadata]
        else
          [nil, metadata]
        end
      end
    end
  end

  class BadPathError < BasicError; end
  class CantCopySharedFolderError < BasicError; end
  class CantMoveFolderIntoItselfError < BasicError; end
  class CantNestSharedFolderError < BasicError; end
  class CantShareOutsideTeamError < BasicError; end
  class ContainsSharedFolderError < BasicError; end
  class DisallowedNameError < BasicError; end
  class DisallowedSharedLinkPolicyError < BasicError; end
  class EmailUnverifiedError < BasicError; end
  class FileAncestorConflictError < BasicError; end
  class FileConflictError < BasicError; end
  class FolderConflictError < BasicError; end
  class GroupDeletedError < BasicError; end
  class GroupNotOnTeamError < BasicError; end
  class InProgressError < BasicError; end
  class InsideAppFolderError < BasicError; end
  class InsideOsxPackageError < BasicError; end
  class InsidePublicFolderError < BasicError; end
  class InsideSharedFolderError < BasicError; end
  class InsufficientPlanError < BasicError; end
  class InsufficientSpaceError < BasicError; end
  class InvalidCursorError < BasicError; end
  class InvalidDropboxIdError < BasicError; end
  class InvalidEmailError < BasicError; end
  class InvalidIdError < BasicError; end
  class InvalidPathError < BasicError; end
  class InvalidSettingsError < BasicError; end
  class IsAppFolderError < BasicError; end
  class IsFileError < BasicError; end
  class IsOsxPackageError < BasicError; end
  class IsPublicFolderError < BasicError; end
  class MalformedPathError < BasicError; end
  class NoAccountError < BasicError; end
  class NoPermissionError < BasicError; end
  class NoWritePermissionError < BasicError; end
  class NotAMemberError < BasicError; end
  class NotFileError < BasicError; end
  class NotFolderError < BasicError; end
  class NotFoundError < BasicError; end
  class RateLimitError < BasicError; end
  class RestrictedContentError < BasicError; end
  class SharedLinkAlreadyExistsError < BasicError; end
  class TeamFolderError < BasicError; end
  class TeamPolicyDisallowsMemberPolicyError < BasicError; end
  class TooManyFilesError < BasicError; end
  class TooManyMembersError < BasicError; end
  class TooManyPendingInvitesError < BasicError; end
  class UnmountedError < BasicError; end
  class UnsupportedContentError < BasicError; end
  class UnsupportedExtensionError < BasicError; end
  class UnverifiedDropboxId < BasicError; end
  
  # Thrown if the redirect URL was missing parameters or if the given parameters were not valid.
  #
  # The recommended action is to show an HTTP 400 error page.
  class BadRequestError < Exception; end

  # Thrown if all the parameters are correct, but there's no CSRF token in the session.  This
  # probably means that the session expired.
  #
  # The recommended action is to redirect the user's browser to try the approval process again.
  class BadStateError < Exception; end

  # Thrown if the given 'state' parameter doesn't contain the CSRF token from the user's session.
  # This is blocked to prevent CSRF attacks.
  #
  # The recommended action is to respond with an HTTP 403 error page.
  class CsrfError < Exception; end

  # The user chose not to approve your app.
  class NotApprovedError < Exception; end

  # Dropbox redirected to your redirect URI with some unexpected error identifier and error
  # message.
  class ProviderError < Exception; end
end
