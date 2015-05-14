module RedmineChilliPdf

  module WikiControllerPatch
   
    def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
      base.class_eval do
        unloadable
  
        helper 'redmine_chilli_pdf'
  
        alias_method :show, :chilli_show
      end
    end
 
    module ClassMethods
    end

    module InstanceMethods

      def chilli_show
        if params[:version] && !User.current.allowed_to?(:view_wiki_edits, @project)
          deny_access
          return
        end
        @content = @page.content_for_version(params[:version])
        if @content.nil?
          if User.current.allowed_to?(:edit_wiki_pages, @project) && editable? && !api_request?
            edit
            render :action => 'edit'
          else
            render_404
          end
          return
        end
        if User.current.allowed_to?(:export_wiki_pages, @project)
          if params[:format] == 'pdf'
            send_data(wiki_page_to_pdf(@page, @project, formatter.render_options), :type => 'application/pdf', :filename => "#{@page.title}.pdf")
            return
          elsif params[:format] == 'html'
            export = render_to_string :action => 'export', :layout => false
            send_data(export, :type => 'text/html', :filename => "#{@page.title}.html")
            return
          elsif params[:format] == 'txt'
            send_data(@content.text, :type => 'text/plain', :filename => "#{@page.title}.txt")
            return
          end
        end
        @editable = editable?
        @sections_editable = @editable && User.current.allowed_to?(:edit_wiki_pages, @page.project) &&
          @content.current_version? &&
          Redmine::WikiFormatting.supports_section_edit?

        respond_to do |format|
          format.html
          format.api
        end
      end

      private

        def create_erb
          content = File.read('wiki/pdf_show.html.erb')
          template = ERB.new(content)  
          kit = PDFKIT.new(template.result(binding))
        end

        def formatter
          RedmineChilliPDF::Formatter.new(filename, page_title, true)
        end

        def filename
          "#{@project.name.underscore}_#{@page.title}".gsub(/\s/,'')
        end

        def page_title
          "#{@project.name}, #{@page.title}"
        end

        def wants_html_version?
          @requesting_html_version = params[:as_html] == 'true' || request.format.html?
        end

    end

  end

end