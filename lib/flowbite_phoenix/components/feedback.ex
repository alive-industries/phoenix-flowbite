defmodule FlowbitePhoenix.Components.Feedback do
  @moduledoc """
  Feedback components for FlowbitePhoenix using Flowbite CSS framework.
  
  This module provides feedback-related components including alerts, badges, 
  flash messages, and spinners with consistent Flowbite styling.
  """
  
  use Phoenix.Component
  alias Phoenix.LiveView.JS

  @doc """
  Renders flash notices using Flowbite alert styling.

  ## Examples

      <.flash kind={:info} flash={@flash} />
      <.flash kind={:info} phx-mounted={show("#flash")}>Welcome Back!</.flash>
  """
  attr :id, :string, doc: "the optional id of flash container"
  attr :flash, :map, default: %{}, doc: "the map of flash messages to display"
  attr :title, :string, default: nil
  attr :kind, :atom, values: [:info, :error], doc: "used for styling and flash lookup"
  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the flash container"

  slot :inner_block, doc: "the optional inner block that renders the flash message"

  def flash(assigns) do
    ~H"""
    <div
      :if={msg = render_slot(@inner_block) || Phoenix.Flash.get(@flash, @kind)}
      id={@id}
      phx-mounted={show("##{@id}")}
      phx-remove={hide("##{@id}")}
      phx-click={JS.push("lv:clear-flash", value: %{key: @kind}) |> hide("##{@id}")}
      role="alert"
      class={[
        "flex items-center p-4 mb-4 text-sm rounded-lg",
        @kind == :info && "text-blue-800 bg-blue-50 dark:bg-gray-800 dark:text-blue-400",
        @kind == :error && "text-red-800 bg-red-50 dark:bg-gray-800 dark:text-red-400"
      ]}
      {@rest}
    >
      <FlowbitePhoenix.Components.Layout.icon :if={@kind == :info} name="hero-information-circle-mini" class="flex-shrink-0 w-4 h-4 me-3" />
      <FlowbitePhoenix.Components.Layout.icon :if={@kind == :error} name="hero-exclamation-triangle-mini" class="flex-shrink-0 w-4 h-4 me-3" />
      <div>
        <span :if={@title} class="font-medium">{@title}</span>
        <span class={@title && "block"}>{msg}</span>
      </div>
      <button
        type="button"
        class="ms-auto -mx-1.5 -my-1.5 bg-blue-50 text-blue-500 rounded-lg focus:ring-2 focus:ring-blue-400 p-1.5 hover:bg-blue-200 inline-flex items-center justify-center h-8 w-8 dark:bg-gray-800 dark:text-blue-400 dark:hover:bg-gray-700"
        data-dismiss-target={"##{@id}"}
        aria-label={FlowbitePhoenix.gettext("close")}
      >
        <span class="sr-only">Close</span>
        <FlowbitePhoenix.Components.Layout.icon name="hero-x-mark-solid" class="w-3 h-3" />
      </button>
    </div>
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id}>
      <.flash kind={:info} title={FlowbitePhoenix.gettext("Success!")} flash={@flash} />
      <.flash kind={:error} title={FlowbitePhoenix.gettext("Error!")} flash={@flash} />
      <.flash
        id="client-error"
        kind={:error}
        title={FlowbitePhoenix.gettext("We can't find the internet")}
        phx-disconnected={show("#client-error")}
        phx-connected={hide("#client-error")}
        hidden
      >
        {FlowbitePhoenix.gettext("Attempting to reconnect")}
        <FlowbitePhoenix.Components.Layout.icon name="hero-arrow-path" class="ml-1 h-3 w-3 animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={FlowbitePhoenix.gettext("Something went wrong!")}
        phx-disconnected={show("#server-error")}
        phx-connected={hide("#server-error")}
        hidden
      >
        {FlowbitePhoenix.gettext("Hang in there while we get back on track")}
        <FlowbitePhoenix.Components.Layout.icon name="hero-arrow-path" class="ml-1 h-3 w-3 animate-spin" />
      </.flash>
    </div>
    """
  end

  @doc """
  Renders a Flowbite alert component.

  ## Examples

      <.alert color="green">Success! Your changes have been saved.</.alert>
      <.alert color="red" dismissible={true}>Error! Something went wrong.</.alert>
  """
  attr :color, :string, default: "blue", values: ~w(blue red green yellow gray)
  attr :dismissible, :boolean, default: false
  attr :class, :string, default: ""
  attr :id, :string, default: nil
  slot :inner_block, required: true

  def alert(assigns) do
    ~H"""
    <div
      id={@id}
      class={[
        "flex items-center p-4 mb-4 text-sm rounded-lg",
        alert_color_class(@color),
        @class
      ]}
      role="alert"
    >
      <FlowbitePhoenix.Components.Layout.icon name="hero-information-circle-mini" class="flex-shrink-0 w-4 h-4 me-3" />
      <div>
        {render_slot(@inner_block)}
      </div>
      <button
        :if={@dismissible}
        type="button"
        class="ms-auto -mx-1.5 -my-1.5 rounded-lg focus:ring-2 p-1.5 inline-flex items-center justify-center h-8 w-8"
        data-dismiss-target={"##{@id}"}
        aria-label="Close"
      >
        <span class="sr-only">Close</span>
        <FlowbitePhoenix.Components.Layout.icon name="hero-x-mark-solid" class="w-3 h-3" />
      </button>
    </div>
    """
  end

  defp alert_color_class("blue"), do: "text-blue-800 bg-blue-50 dark:bg-gray-800 dark:text-blue-400"
  defp alert_color_class("red"), do: "text-red-800 bg-red-50 dark:bg-gray-800 dark:text-red-400"
  defp alert_color_class("green"), do: "text-green-800 bg-green-50 dark:bg-gray-800 dark:text-green-400"
  defp alert_color_class("yellow"), do: "text-yellow-800 bg-yellow-50 dark:bg-gray-800 dark:text-yellow-300"
  defp alert_color_class("gray"), do: "text-gray-800 bg-gray-50 dark:bg-gray-800 dark:text-gray-300"

  @doc """
  Renders a badge with Flowbite styling.

  ## Examples

      <.badge>Default</.badge>
      <.badge color="green">Success</.badge>
      <.badge color="red" size="sm">Error</.badge>
  """
  attr :color, :string, default: "blue", values: ~w(blue gray red green yellow indigo purple pink)
  attr :size, :string, default: "default", values: ~w(xs sm default)
  attr :class, :string, default: ""
  slot :inner_block, required: true

  def badge(assigns) do
    ~H"""
    <span class={[
      "inline-flex items-center font-medium me-2 px-2.5 py-0.5 rounded",
      badge_color_class(@color),
      badge_size_class(@size),
      @class
    ]}>
      {render_slot(@inner_block)}
    </span>
    """
  end

  defp badge_color_class("blue"), do: "bg-blue-100 text-blue-800 dark:bg-blue-900 dark:text-blue-300"
  defp badge_color_class("gray"), do: "bg-gray-100 text-gray-800 dark:bg-gray-900 dark:text-gray-300"
  defp badge_color_class("red"), do: "bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-300"
  defp badge_color_class("green"), do: "bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-300"
  defp badge_color_class("yellow"), do: "bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-300"
  defp badge_color_class("indigo"), do: "bg-indigo-100 text-indigo-800 dark:bg-indigo-900 dark:text-indigo-300"
  defp badge_color_class("purple"), do: "bg-purple-100 text-purple-800 dark:bg-purple-900 dark:text-purple-300"
  defp badge_color_class("pink"), do: "bg-pink-100 text-pink-800 dark:bg-pink-900 dark:text-pink-300"

  defp badge_size_class("xs"), do: "text-xs"
  defp badge_size_class("sm"), do: "text-sm"
  defp badge_size_class("default"), do: "text-sm"

  @doc """
  Renders a spinner with Flowbite styling.

  ## Examples

      <.spinner />
      <.spinner size="lg" />
  """
  attr :size, :string, default: "default", values: ~w(sm default lg)
  attr :class, :string, default: ""

  def spinner(assigns) do
    ~H"""
    <div
      class={[
        "inline-block animate-spin rounded-full border-4 border-solid text-blue-600",
        "border-current border-r-transparent align-[-0.125em] motion-reduce:animate-[spin_1.5s_linear_infinite]",
        spinner_size_class(@size),
        @class
      ]}
      role="status"
      aria-label="loading"
    >
      <span class="!absolute !-m-px !h-px !w-px !overflow-hidden !whitespace-nowrap !border-0 !p-0 ![clip:rect(0,0,0,0)]">
        Loading...
      </span>
    </div>
    """
  end

  defp spinner_size_class("sm"), do: "h-4 w-4"
  defp spinner_size_class("default"), do: "h-8 w-8"
  defp spinner_size_class("lg"), do: "h-12 w-12"

  ## JS Commands

  def show(js \\ %JS{}, selector) do
    JS.show(js,
      to: selector,
      transition:
        {"transition-all transform ease-out duration-200",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95",
         "opacity-100 translate-y-0 sm:scale-100"}
    )
    |> JS.hide(to: selector, transition: {"block", "block", "hidden"}, time: 2000)
  end

  def hide(js \\ %JS{}, selector) do
    JS.hide(js,
      to: selector,
      transition:
        {"transition-all transform ease-in duration-200",
         "opacity-100 translate-y-0 sm:scale-100",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"}
    )
  end
end