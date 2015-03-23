# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

scope 'admin' do
  resources :email_filters, :except => :show
end
