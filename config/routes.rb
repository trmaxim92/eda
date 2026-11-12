Rails.application.routes.draw do
  devise_for :users, path: "users", path_names: { sign_in: "sign_in", sign_out: "sign_out" }

  get "up" => "rails/health#show", as: :rails_health_check
  get "robots.txt", to: "robots#show", as: :robots
  get "sitemap.xml", to: "sitemaps#index", as: :sitemap, defaults: { format: :xml }
  get "sitemap-pages.xml", to: "sitemaps#pages", as: :sitemap_pages, defaults: { format: :xml }
  get "sitemap-cities.xml", to: "sitemaps#cities", as: :sitemap_cities, defaults: { format: :xml }
  get "sitemap-city-types.xml", to: "sitemaps#city_types", as: :sitemap_city_types, defaults: { format: :xml }

  root "home#index"
  post "select_city", to: "city_selections#create", as: :select_city
  delete "select_city", to: "city_selections#destroy"

  get "rabota-v-yandex-eda", to: "pages#show", defaults: { slug: "rabota-v-yandex-eda" }, as: :rabota_v_yandex_eda
  get "rabota-kurerom", to: "pages#show", defaults: { slug: "rabota-kurerom" }, as: :rabota_kurerom
  get "usloviya-raboty", to: "pages#show", defaults: { slug: "usloviya-raboty" }, as: :usloviya_raboty
  get "rabota-cherez-park", to: "pages#show", defaults: { slug: "rabota-cherez-park" }, as: :rabota_cherez_park
  get "kontakty", to: "pages#show", defaults: { slug: "kontakty" }, as: :kontakty

  get "rabota-peshim-kurerom", to: "courier_types#show", defaults: { slug: "rabota-peshim-kurerom" }, as: :rabota_peshim
  get "rabota-velokurerom", to: "courier_types#show", defaults: { slug: "rabota-velokurerom" }, as: :rabota_velo
  get "rabota-avtokurerom", to: "courier_types#show", defaults: { slug: "rabota-avtokurerom" }, as: :rabota_auto

  get "otzyvy", to: "reviews#index", as: :otzyvy
  get "blog", to: "blog#index", as: :blog

  get "goroda", to: "cities#index", as: :goroda
  get "goroda/:city_slug/:courier_type_slug", to: "city_courier_pages#show", as: :gorod_courier_type
  get "goroda/:slug", to: "cities#show", as: :gorod

  resources :leads, only: :create
  get "spasibo", to: "leads#thank_you", as: :thank_you
  get "go/register", to: "registrations#go", as: :go_register

  namespace :admin do
    root to: "dashboard#index"
    resources :pages, except: :show
    resources :cities, except: :show do
      member do
        post :apply_seo_template
      end
    end
    resources :city_courier_pages, except: :show do
      member do
        get :preview
        post :apply_seo_template
      end
    end
    resources :courier_types, except: :show
    resources :leads, only: %i[index show edit update]
    resources :referral_links
    resources :reviews, except: :show
    resources :faqs, except: :show
    resources :redirects, except: :show
    resources :seo_templates, except: :show
    resource :seo, only: :show, controller: "seo"
    resources :site_settings, only: %i[index edit update]
    resources :users, except: :show
  end
end
