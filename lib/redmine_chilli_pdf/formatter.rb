module RedmineChilliPDF
  class Formatter
    HEADER_FOOTER_FONT_SIZE = 8
    DEFAULT_MARGIN = '0.5in'
    DEFAULT_PAGE_SIZE = "Letter"
    DEFAULT_PAGE_TITLE = "Untitled"
    DEFAULT_LAYOUT = 'pdf.pdf.erb'
    DEFAULT_VIEW_TEMPLATE  = 'wiki/show.pdf.html.erb'

    attr_reader :page_title

    # TODO: Hack...need to come up with better approach for this...
    TokenManager.add_token_definition do
      {:page_title => {:replacement_object => (DEFAULT_PAGE_TITLE),
                       :description        => "The project & wiki page name (eg: 'My Project, Wiki Page Title')"}}
    end

    def initialize(filename, title = nil, render_html_version = nil)
      @page_title = title
      @filename = filename
      @allow_debugging = render_html_version

      # TODO: Hack...need to come up with better approach for this...
      TokenManager.add_token_definition do
        {:page_title => {:replacement_object => (@page_title || DEFAULT_PAGE_TITLE),
                         :description        => "The project & wiki page name (eg: 'My Project, Wiki Page Title')"}}
      end
    end

    def render_options
      default_options = {
        :pdf => @filename,
        :template => view_template,
        :page_size => DEFAULT_PAGE_SIZE,
        :show_as_html => render_as_html?,
        :margin => {
          :top    => DEFAULT_MARGIN,
          :bottom => DEFAULT_MARGIN,
          :left   => DEFAULT_MARGIN,
          :right  => DEFAULT_MARGIN
        },
        :layout => DEFAULT_LAYOUT
      }

      default_options.merge!(footer_options) if RedmineChilliPDF::Config.footer_enabled?
      default_options.merge!(header_options) if RedmineChilliPDF::Config.header_enabled?
      default_options
    end

    private
      def footer_options
        {:footer => {
          :font_size => 8,
          :line => true,
          :spacing => 2
        }.merge(substitute_tokens(RedmineChilliPDF::Config.footer_values))}
      end

      def header_options
        {:header => {
          :font_size => HEADER_FOOTER_FONT_SIZE,
          :line => true,
          :spacing => 2
        }.merge(substitute_tokens(RedmineChilliPDF::Config.header_values))}
      end

      def substitute_tokens(hash)
        hash.inject({}) do |converted_list, unconverted_item|
          header_location,header_location_value = unconverted_item
          converted_list.merge({header_location => replace_tokens_in(header_location_value)})
        end
      end

      def replace_tokens_in(string)
        TokenManager.apply_tokens_to string
      end

      def view_template
        DEFAULT_VIEW_TEMPLATE
      end

      def render_as_html?
        !@allow_debugging.blank?
      end
  end
end
