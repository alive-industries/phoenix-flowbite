defmodule FlowbitePhoenix.Components do
  @moduledoc """
  Import all FlowbitePhoenix components in one go.
  
  This module provides a convenient way to import all FlowbitePhoenix components
  at once instead of importing them individually.

  ## Usage

      import FlowbitePhoenix.Components

  This is equivalent to:

      import FlowbitePhoenix.Components.Forms
      import FlowbitePhoenix.Components.Layout
      import FlowbitePhoenix.Components.Feedback
      import FlowbitePhoenix.Components.Navigation

  ## Individual Imports

  You can also import specific component modules:

      import FlowbitePhoenix.Components.Forms      # Forms: input, button, simple_form, toggle, etc.
      import FlowbitePhoenix.Components.Layout     # Layout: modal, table, card, header, etc.  
      import FlowbitePhoenix.Components.Feedback   # Feedback: flash, alert, badge, spinner, etc.
      import FlowbitePhoenix.Components.Navigation # Navigation: dropdown, back, breadcrumb, etc.
  """

  defmacro __using__(_) do
    quote do
      import FlowbitePhoenix.Components.Forms
      import FlowbitePhoenix.Components.Layout
      import FlowbitePhoenix.Components.Feedback
      import FlowbitePhoenix.Components.Navigation
    end
  end

  # Re-export all component functions for direct access
  defdelegate simple_form(assigns), to: FlowbitePhoenix.Components.Forms
  defdelegate button(assigns), to: FlowbitePhoenix.Components.Forms
  defdelegate input(assigns), to: FlowbitePhoenix.Components.Forms
  defdelegate label(assigns), to: FlowbitePhoenix.Components.Forms
  defdelegate error(assigns), to: FlowbitePhoenix.Components.Forms
  defdelegate toggle(assigns), to: FlowbitePhoenix.Components.Forms

  defdelegate modal(assigns), to: FlowbitePhoenix.Components.Layout
  defdelegate header(assigns), to: FlowbitePhoenix.Components.Layout
  defdelegate table(assigns), to: FlowbitePhoenix.Components.Layout
  defdelegate card(assigns), to: FlowbitePhoenix.Components.Layout
  defdelegate card_header(assigns), to: FlowbitePhoenix.Components.Layout
  defdelegate icon(assigns), to: FlowbitePhoenix.Components.Layout

  defdelegate flash(assigns), to: FlowbitePhoenix.Components.Feedback
  defdelegate flash_group(assigns), to: FlowbitePhoenix.Components.Feedback
  defdelegate alert(assigns), to: FlowbitePhoenix.Components.Feedback
  defdelegate badge(assigns), to: FlowbitePhoenix.Components.Feedback
  defdelegate spinner(assigns), to: FlowbitePhoenix.Components.Feedback

  defdelegate dropdown(assigns), to: FlowbitePhoenix.Components.Navigation
  defdelegate back(assigns), to: FlowbitePhoenix.Components.Navigation
  defdelegate breadcrumb(assigns), to: FlowbitePhoenix.Components.Navigation
  defdelegate pagination(assigns), to: FlowbitePhoenix.Components.Navigation
end