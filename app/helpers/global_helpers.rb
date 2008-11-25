module Merb
  # Helpers defined here available to all views.
  module GlobalHelpers
    # Set a title to be used within the views.
    # Returns nil in case it's accidentally used in <%= %> tags.
    def title(name)
      @page_title = name
      return nil
    end
  end
end
