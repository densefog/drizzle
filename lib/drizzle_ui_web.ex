defmodule DrizzleUiWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, components, channels, and so on.

  This can be used in your application as:

      use DrizzleUiWeb, :controller
      use DrizzleUiWeb, :html

  The definitions below will be executed for every controller,
  component, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define additional modules and import
  those modules here.
  """

  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt)

  def router do
    quote do
      use Phoenix.Router, helpers: false

      # Import common connection and controller functions to use in pipelines
      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  def controller do
    quote do
      use Phoenix.Controller, namespace: DrizzleUiWeb

      import Plug.Conn
      import DrizzleUiWeb.Gettext
      alias DrizzleUiWeb.Router.Helpers, as: Routes
    end

    # quote do
    # use Phoenix.Controller,
    # formats: [:html, :json],
    # layouts: [html: DrizzleUiWeb.Layouts]

    # import Plug.Conn
    # import DrizzleUiWeb.Gettext

    # unquote(verified_routes())
    # end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {DrizzleUiWeb.LayoutView, :live}

      unquote(html_helpers())
    end

    # quote do
    # use Phoenix.LiveView,
    # layout: {DrizzleUiWeb.Layouts, :app}

    # unquote(html_helpers())
    # end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(html_helpers())
    end
  end

  def html do
    quote do
      use Phoenix.Component

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_csrf_token: 0, view_module: 1, view_template: 1]

      # Include general helpers for rendering HTML
      unquote(html_helpers())
    end
  end

  defp html_helpers do
    quote do
      # HTML escaping functionality
      import Phoenix.HTML
      # Core UI components and translation
      # import DrizzleUiWeb.CoreComponents
      import DrizzleUiWeb.Gettext

      # Shortcut for generating JS commands
      alias Phoenix.LiveView.JS

      # Routes generation with the ~p sigil
      unquote(verified_routes())
    end
  end

  # defp html_helpers do
  # quote do
  ## Use all HTML functionality (forms, tags, etc)
  # use Phoenix.HTML

  ## Import LiveView helpers (live_render, live_component, live_patch, etc)
  # import Phoenix.LiveView.Helpers

  ## Import basic rendering functionality (render, render_layout, etc)
  # import Phoenix.View

  # import DrizzleUiWeb.ErrorHelpers
  # import DrizzleUiWeb.Gettext
  # alias DrizzleUiWeb.Router.Helpers, as: Routes
  # end
  # end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: DrizzleUiWeb.Endpoint,
        router: DrizzleUiWeb.Router,
        statics: DrizzleUiWeb.static_paths()
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/live_view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
