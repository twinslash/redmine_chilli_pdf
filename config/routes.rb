RedmineApp::Application.routes.draw do
  match 'projects/:project_id/wiki.pdf', :controller => 'extended_wiki', :action => 'show', :format => 'pdf'
  match 'projects/:project_id/wiki/:id.pdf', :controller => 'extended_wiki', :action => 'show', :format => 'pdf'
end
