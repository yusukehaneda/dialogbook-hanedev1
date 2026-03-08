Rails.application.routes.draw do
  root "home#index"

  # Fly.io ヘルスチェック用エンドポイント
  get "up" => "rails/health#show", as: :rails_health_check

  # auth0 settings
  get "/auth/:provider/callback", to: "sessions#create"
  get "/auth/failure", to: "sessions#failure"
  get "/sign_out", to: "sessions#destroy"

  # MyPage
  namespace :mypage do
    get "comments/create"
    root to: "users#show"
    resources :users,    only: [:edit, :show, :update]
    get "/:id/switch_school/:sid", to: "users#switch_school", as: :switch_school
    get "/update_scores/:id", to: "users#update_scores", as: :update_scores
    resources :schools,  only: [:destroy]
    resources :notes,    only: [:create, :destroy]
    resources :posts,    only: [:create]
    resources :comments, only: [:create]
  end

  # Teacher's Dashboard
  namespace :td do
    get "/users",          to: "users#index"
    get "/users/approve",  to: "users#approve"
    get "/users/withdraw", to: "users#withdraw"
    get "/users/delete",   to: "users#delete"
    resources :lessons,    except: [:new, :show]
    resources :rubrics,    except: [:new, :show]
    resources :meetings,   except: [:new, :show]
    resources :notes,      only: [:destroy, :edit, :update]
    resources :schools,    only: [:show]

    namespace :api, { format: "json" } do
      resources :users,    only: [:index]
    end
  end

  # Administration
  namespace :admin do
    root "projects#index"
    resources :projects, except: [:new, :show]
    resources :schools,  only: [:create, :destroy, :edit, :update]
    resources :users,    only: [:destroy, :edit, :update]
  end
end
