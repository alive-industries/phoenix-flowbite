defmodule FlowbitePhoenix do
  @moduledoc """
  FlowbitePhoenix - A comprehensive Phoenix LiveView component library using Flowbite CSS framework.
  
  FlowbitePhoenix provides a complete set of UI components styled with Flowbite, 
  a utility-first CSS framework built on Tailwind CSS. It offers ready-to-use
  components for forms, layout, feedback, and navigation with consistent styling
  and theming support.

  ## Important: JavaScript Setup

  FlowbitePhoenix requires the Phoenix LiveView compatible version of Flowbite JS
  to function properly. Always use `flowbite.phoenix.js` instead of the regular
  `flowbite.js` to ensure interactive components work correctly with LiveView
  page transitions.

  ## Installation

  Add `flowbite_phoenix` to your list of dependencies in `mix.exs`:

      def deps do
        [
          {:flowbite_phoenix, "~> 0.1.0"}
        ]
      end

  Then fetch the dependencies and run the installation task:

      mix deps.get
      mix flowbite_phoenix.install

  ## Usage

  Import the component modules you need in your templates or components:

      import FlowbitePhoenix.Components.Forms
      import FlowbitePhoenix.Components.Layout
      import FlowbitePhoenix.Components.Feedback
      import FlowbitePhoenix.Components.Navigation

  Or import all components at once:

      import FlowbitePhoenix.Components

  ## Configuration

  You can configure FlowbitePhoenix in your `config.exs`:

      config :flowbite_phoenix,
        gettext_backend: MyAppWeb.Gettext,
        theme: %{
          primary_color: "blue",
          # Additional theme customizations...
        }

  ## Components

  FlowbitePhoenix provides the following component categories:

  - **Forms**: `input/1`, `button/1`, `simple_form/1`, `toggle/1`, `label/1`, `error/1`
  - **Layout**: `modal/1`, `table/1`, `card/1`, `card_header/1`, `header/1`, `icon/1` 
  - **Feedback**: `flash/1`, `flash_group/1`, `alert/1`, `badge/1`, `spinner/1`
  - **Navigation**: `dropdown/1`, `back/1`, `breadcrumb/1`, `pagination/1`

  All components follow Flowbite design patterns and support dark mode.
  """

  @version Mix.Project.config()[:version]

  @doc """
  Returns the version of FlowbitePhoenix.
  """
  def version, do: @version

  @doc """
  Translates an error message using gettext.
  
  This function provides a unified way to translate error messages throughout
  the FlowbitePhoenix components, with fallback support when Gettext is not available.
  """
  def translate_error({msg, opts}) do
    # When using gettext, we typically pass the strings we want
    # to translate as a static argument:
    #
    #     # Translate the number of files with plural rules
    #     dngettext("errors", "1 file", "%{count} files", count)
    #
    # However the error messages in our forms and APIs are generated
    # dynamically, so we need to translate them by calling Gettext
    # with our gettext backend as first argument. Translations are
    # available in the errors.po file (as we use the "errors" domain).
    if count = opts[:count] do
      FlowbitePhoenix.Gettext.dngettext("errors", msg, msg, count, opts)
    else
      FlowbitePhoenix.Gettext.dgettext("errors", msg, opts)
    end
  end

  def translate_error(msg), do: msg

  @doc """
  Convenience function for gettext translation.
  """
  def gettext(message, default \\ nil) do
    FlowbitePhoenix.Gettext.gettext(message, default)
  end

  @doc """
  Translates the errors for a field from a keyword list of errors.
  """
  def translate_errors(errors, field) when is_list(errors) do
    for {^field, {msg, opts}} <- errors, do: translate_error({msg, opts})
  end
end
