defmodule PlangoraWeb.Router do
  use PlangoraWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug PlangoraWeb.MaybeAuth
    plug PlangoraWeb.Locale
    plug PlangoraWeb.GoogleAnalytics
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :admin_section do
    plug PlangoraWeb.AdminAuth
    plug :put_layout, {PlangoraWeb.LayoutView, :admin}
  end

  pipeline :user_section do
    plug PlangoraWeb.UserAuth
  end

  scope "/", PlangoraWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/contact", PageController, :new
    get "/register", UserController, :new

    resources "/users", UserController, only: [:create]
    resources "/news-posts", NewsPostController, param: "slug", only: [:show, :index]
    resources "/video-posts", VideoPostController, param: "slug", only: [:show, :index]
    resources "/video-categories", VideoCategoryController, param: "category_slug", only: [:show]

    resources "/user-sessions", UserSessionController, only: [:create]
    get "/login", UserSessionController, :new
    delete "/logout", UserSessionController, :delete

    get "/admin-login", AdminSessionController, :new
    resources "/admin-sessions", AdminSessionController, only: [:delete, :create], singleton: true

    scope "/plangora_admin" do
      pipe_through [:admin_section]

      resources "/users", AdminController, except: [:update]
      resources "/video-posts", AdminVideoPostController
      resources "/video-categories", VideoCategoryController
      resources "/news-posts", AdminNewsPostController
      resources "/leads", LeadsController, only: [:index, :show, :delete]
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", PlangoraWeb do
  #   pipe_through :api
  # end
end
