Rails.application.routes.draw do
   root 'entries#index'
   scope '/blogs' do
     post '/update_all_blogs' => 'blogs#update_all_blogs', as: :blogs_update_all_blogs
     post '/:id/download_newest_entries' => 'blogs#download_newest_entries', as: :blog_download_newest_entries
   end
   resources :blogs
   resources :entries, only: [:index, :show, :destroy]
end
