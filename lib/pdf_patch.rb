module PdfPatch
  
  def self.included(base)
    base.send(:include, InstanceMethods)

    base.class_eval do
      require 'application_helper'

      alias_method :wiki_page_to_pdf, :chilli_wiki_page_to_pdf
    end
  end

  module InstanceMethods

    def chilli_wiki_page_to_pdf(page, project, params)
      pdf = Redmine::Export::PDF::ITCPDF.new(current_language)
      header = params[:header]
      pdf.set_title("#{header[:left]} - #{header[:center]} - #{header[:right]}")
      pdf.alias_nb_pages
      footer = params[:footer]
      pdf.footer_date = "#{footer[:left]} - #{footer[:center]} - #{footer[:right]}"
      pdf.add_page
      pdf.SetFontStyle('B',11)
      pdf.RDMMultiCell(190,5,
        "#{RedmineChilliPDF::Config.logo_url}")
      pdf.RDMMultiCell(160,5,
        "#{header[:left]} - #{header[:center]} - #{header[:right]}")
      pdf.ln
      pdf.set_image_scale(1.6)
      pdf.SetFontStyle('',9)
      write_wiki_page(pdf, page)
      pdf.output
    end
  
  end 

end
