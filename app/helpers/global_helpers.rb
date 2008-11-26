module Merb
  # Helpers defined here available to all views.
  module GlobalHelpers
    # Set a title to be used within the views.
    # Returns nil in case it's accidentally used in <%= %> tags.
    def title(name)
      @page_title = name
      return nil
    end

    # Returns true if there's an error message in the queue.
    def error_message?
      true if message[:error]
    end

    # Returns true if there's a notice message in the queue.
    def notice_message?
      true if message[:notice]
    end

    # Returns a nice <abbr> tag with the given +time+.
    def time_abbr(time = Time.now, options = {:date_only => false})
      format = "%B %d, %Y"
      format += " - %I:%M:%S %p" unless options[:date_only]
      tag  = '<abbr '
      tag += "title='#{time.httpdate}'>"
      tag += time.strftime(format)
      tag += '</abbr>'
      return tag
    end
  end
end
