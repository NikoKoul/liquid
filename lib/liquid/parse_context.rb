module Liquid
  class ParseContext
    attr_accessor :partial, :locale, :line_number
    attr_reader :warnings, :error_mode

    def initialize(options = {})
      @template_options = options ? options.dup : {}
      @locale = @template_options[:locale] ||= I18n.new
      @warnings = []
      self.partial = false
    end

    def [](option_key)
      @options[option_key]
    end

    def partial=(value)
      @partial = value
      @options = value ? partial_options : @template_options
      @error_mode = @options[:error_mode] || Template.error_mode
      value
    end

    def partial_options
      @partial_options ||= begin
        dont_pass = @template_options[:include_options_blacklist]
        if dont_pass == true
          { locale: locale }
        elsif dont_pass.is_a?(Array)
          opts = @template_options.dup
          dont_pass.each { |o| opts.delete(o) }
          opts
        else
          @template_options
        end
      end
    end
  end
end
