AhoyCaptain::Engine.routes.draw do
  root to: 'roots#show'
  %w{utm_source utm_medium utm_term utm_content utm_campaign}.each do |utm|
    get "campaigns/#{utm}" => "campaigns#index", defaults: { campaigns_type: utm }, as: "campaign_#{utm}"
  end

  {
    browsers: :browser,
    operating_systems: :os,
    device_types: :device_type
  }.each do |k,v|
    get "/devices/#{k}" => 'devices#index', defaults: { devices_type: v }, as: "devices_#{k}"
  end

  resource :export, only: [:show]
  resource :realtime, only: [:show]
  resources :funnels, only: [:show]
  resources :goals, only: [:index]
  resource :stats, only: [:show]
  resources :countries, only: [:index]
  resources :regions, only: [:index]
  resources :cities, only: [:index]
  resources :campaigns, only: [:index]
  resources :sources, only: [:index]
  resources :exit_pages, only: [:index]
  resources :top_pages, only: [:index]
  resources :entry_pages, only: [:index]

  namespace :stats do
    resources :unique_visitors, only: [:index]
    resources :total_visits, only: [:index]
    resources :total_pageviews, only: [:index]
    resources :views_per_visits, only: [:index]
    resources :bounce_rates, only: [:index]
    resources :visit_durations, only: [:index]
  end
  namespace :filters do
    %w{source medium term content campaign}.each do |utm|
      get "utm/#{utm}s" => "utms#index", defaults: { type: "utm_#{utm}" }
    end

    %w{country region city}.each do |type|
      get "locations/#{type.pluralize}" => "locations#index", defaults: { type: type }
    end

    namespace :properties do
      resources :names, only: [:index]
      resources :values, only: [:index]
    end

    resources :sources, only: [:index]
    resources :screens, only: [:index]
    scope :operating_systems, module: :operating_systems do
      resources :names, only: [:index]
      resources :versions, only: [:index]
    end
    scope :pages, module: :pages do
      resources :actions, only: [:index]
      resources :entry_pages, only: [:index]
      resources :exit_pages, only: [:index]
    end
  end
end
