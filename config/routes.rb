get '/doc_pu', :to => 'doc_pu#index'
get '/doc_pu/:action', :to => 'doc_pu#:action'
get '/doc_pu_settings/:action', :to => 'doc_pu_settings#:action'
get '/doc_pu_wiki/:action', :to => 'doc_pu_wiki#:action'

post '/doc_pu/:action', :to => 'doc_pu#:action'
post '/doc_pu_settings/:action', :to => 'doc_pu_settings#:action'
post '/doc_pu_wiki/:action', :to => 'doc_pu_wiki#:action'

