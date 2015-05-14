require 'redmine'
require 'redmine_chilli_pdf'
require 'wicked_pdf' unless defined?(WickedPdf)
require 'nokogiri' unless defined?(Nokogiri)

Redmine::Plugin.register :redmine_chilli_pdf do
  name 'Redmine Chilli Pdf plugin'
  author "//Twinslash"
  description 'Plugin to export wiki in pdf'
  version '0.0.1'
  url 'https://github.com/twinslash/redmine_chilli_pdf'
  author_url 'http://twinslash.com'

  settings partial: 'settings/redmine_chilli_pdf_settings',
           default: RedmineChilliPDF::Config.defaults
end

Rails.configuration.to_prepare do
  require_dependency 'principal'
  require_dependency 'user'
  require_dependency 'lib/redmine/export/pdf'

  User.send(:include, UserPatch) unless User.included_modules.include? UserPatch
  WikiController.send(:include, RedmineChilliPdf::WikiControllerPatch)
  Redmine::Export::PDF.send(:include, PdfPatch)
  # require_dependency 'wiki_format_hook_listener'
end
