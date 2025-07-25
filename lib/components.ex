defmodule MachineTalentsWeb.CoreComponents do
  @moduledoc """
  Provides core UI components using Flowbite styling.
  
  At first glance, this module may seem daunting, but its goal is to provide
  core building blocks for your application, such as modals, tables, and
  forms. The components consist mostly of markup and are well-documented
  with doc strings and declarative assigns. You may customize and style
  them in any way you want, based on your application growth and needs.

  The components use Flowbite CSS framework built on Tailwind CSS.
  See the [Flowbite documentation](https://flowbite.com) to learn
  how to customize them or feel free to swap in another framework altogether.

  To use Flowbite components, include the CSS and JS in your root.html.heex:
  <link href="https://cdnjs.cloudflare.com/ajax/libs/flowbite/2.2.1/flowbite.min.css" rel="stylesheet" />
  <script src="https://cdnjs.cloudflare.com/ajax/libs/flowbite/2.2.1/flowbite.min.js"></script>

  Icons are provided by [heroicons](https://heroicons.com). See `icon/1` for usage.
  """
  use Phoenix.Component
  use Gettext, backend: MachineTalentsWeb.Gettext

  alias Phoenix.LiveView.JS

  @doc """
  Renders a modal using Flowbite styling.

  ## Examples

      <.modal id="confirm-modal">
        <:title>Confirm Action</:title>
        This is a modal with Flowbite styling.
      </.modal>

  JS commands may be passed to the `:on_cancel` to configure
  the closing/cancel event, for example:

      <.modal id="confirm" on_cancel={JS.navigate(~p"/posts")}>
        <:title>Navigate Modal</:title>
        This modal will navigate on cancel.
      </.modal>
  """
  attr :id, :string, required: true
  attr :show, :boolean, default: false
  attr :on_cancel, JS, default: %JS{}
  slot :inner_block, required: true
  slot :title

  def modal(assigns) do
    ~H"""
    <div
      id={@id}
      phx-mounted={@show && show_modal(@id)}
      phx-remove={hide_modal(@id)}
      data-modal-backdrop="static"
      tabindex="-1"
      aria-hidden="true"
      class="hidden overflow-y-auto overflow-x-hidden fixed top-0 right-0 left-0 z-50 justify-center items-center w-full md:inset-0 h-[calc(100%-1rem)] max-h-full"
      style={if @show, do: "display: flex", else: "display: none"}
    >
      <div class="relative p-4 w-full max-w-2xl max-h-full">
        <div class="relative bg-white rounded-lg shadow dark:bg-gray-700">
          <div class="flex items-center justify-between p-4 md:p-5 border-b rounded-t dark:border-gray-600">
            <h3 :if={@title != []} class="text-xl font-semibold text-gray-900 dark:text-white">
              {render_slot(@title)}
            </h3>
            <button
              phx-click={@on_cancel}
              type="button"
              data-modal-hide={@id}
              class="text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 ms-auto inline-flex justify-center items-center dark:hover:bg-gray-600 dark:hover:text-white"
            >
              <.icon name="hero-x-mark-solid" class="w-3 h-3" />
              <span class="sr-only">Close modal</span>
            </button>
          </div>
          <div class="p-4 md:p-5 space-y-4">
            {render_slot(@inner_block)}
          </div>
        </div>
      </div>
    </div>
    """
  end

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
      <.icon :if={@kind == :info} name="hero-information-circle-mini" class="flex-shrink-0 w-4 h-4 me-3" />
      <.icon :if={@kind == :error} name="hero-exclamation-triangle-mini" class="flex-shrink-0 w-4 h-4 me-3" />
      <div>
        <span :if={@title} class="font-medium">{@title}</span>
        <span class={@title && "block"}>{msg}</span>
      </div>
      <button
        type="button"
        class="ms-auto -mx-1.5 -my-1.5 bg-blue-50 text-blue-500 rounded-lg focus:ring-2 focus:ring-blue-400 p-1.5 hover:bg-blue-200 inline-flex items-center justify-center h-8 w-8 dark:bg-gray-800 dark:text-blue-400 dark:hover:bg-gray-700"
        data-dismiss-target={"##{@id}"}
        aria-label={gettext("close")}
      >
        <span class="sr-only">Close</span>
        <.icon name="hero-x-mark-solid" class="w-3 h-3" />
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
      <.flash kind={:info} title={gettext("Success!")} flash={@flash} />
      <.flash kind={:error} title={gettext("Error!")} flash={@flash} />
      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={show("#client-error")}
        phx-connected={hide("#client-error")}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 h-3 w-3 animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={show("#server-error")}
        phx-connected={hide("#server-error")}
        hidden
      >
        {gettext("Hang in there while we get back on track")}
        <.icon name="hero-arrow-path" class="ml-1 h-3 w-3 animate-spin" />
      </.flash>
    </div>
    """
  end

  @doc """
  Renders a simple form with Flowbite styling.

  ## Examples

      <.simple_form for={@form} phx-change="validate" phx-submit="save">
        <.input field={@form[:email]} label="Email"/>
        <.input field={@form[:username]} label="Username" />
        <:actions>
          <.button>Save</.button>
        </:actions>
      </.simple_form>
  """
  attr :for, :any, required: true, doc: "the data structure for the form"
  attr :as, :any, default: nil, doc: "the server side parameter to collect all input under"

  attr :rest, :global,
    include: ~w(autocomplete name rel action enctype method novalidate target multipart),
    doc: "the arbitrary HTML attributes to apply to the form tag"

  slot :inner_block, required: true
  slot :actions, doc: "the slot for form actions, such as a submit button"

  def simple_form(assigns) do
    ~H"""
    <.form :let={f} for={@for} as={@as} {@rest}>
      <div class="space-y-6">
        {render_slot(@inner_block, f)}
        <div :for={action <- @actions} class="flex items-center justify-end space-x-2 pt-4">
          {render_slot(action, f)}
        </div>
      </div>
    </.form>
    """
  end

  @doc """
  Renders a button with Flowbite styling and multiple variants.

  ## Examples

      <.button>Send!</.button>
      <.button phx-click="go" color="alternative">Cancel</.button>
      <.button loading={true} color="blue">Loading...</.button>
      <.button variant="outline" color="red">Delete</.button>
  """
  attr :type, :string, default: nil
  attr :class, :string, default: nil
  attr :loading, :boolean, default: false
  attr :variant, :string, default: "default", values: ~w(default outline)
  attr :color, :string, default: "blue", values: ~w(blue alternative dark light green red yellow purple)
  attr :size, :string, default: "default", values: ~w(xs sm default lg xl)
  attr :rest, :global, include: ~w(disabled form name value)

  slot :inner_block, required: true

  def button(assigns) do
    ~H"""
    <button
      type={@type}
      disabled={@loading}
      class={[
        "focus:ring-4 focus:outline-none font-medium rounded-lg text-center inline-flex items-center",
        button_variant_class(@variant, @color),
        button_size_class(@size),
        @loading && "opacity-50 cursor-not-allowed",
        @class
      ]}
      {@rest}
    >
      <%= if @loading do %>
        <svg
          aria-hidden="true"
          role="status"
          class="inline w-4 h-4 me-3 text-white animate-spin"
          viewBox="0 0 100 101"
          fill="none"
          xmlns="http://www.w3.org/2000/svg"
        >
          <path
            d="M100 50.5908C100 78.2051 77.6142 100.591 50 100.591C22.3858 100.591 0 78.2051 0 50.5908C0 22.9766 22.3858 0.59082 50 0.59082C77.6142 0.59082 100 22.9766 100 50.5908ZM9.08144 50.5908C9.08144 73.1895 27.4013 91.5094 50 91.5094C72.5987 91.5094 90.9186 73.1895 90.9186 50.5908C90.9186 27.9921 72.5987 9.67226 50 9.67226C27.4013 9.67226 9.08144 27.9921 9.08144 50.5908Z"
            fill="#E5E7EB"
          />
          <path
            d="M93.9676 39.0409C96.393 38.4038 97.8624 35.9116 97.0079 33.5539C95.2932 28.8227 92.871 24.3692 89.8167 20.348C85.8452 15.1192 80.8826 10.7238 75.2124 7.41289C69.5422 4.10194 63.2754 1.94025 56.7698 1.05124C51.7666 0.367541 46.6976 0.446843 41.7345 1.27873C39.2613 1.69328 37.813 4.19778 38.4501 6.62326C39.0873 9.04874 41.5694 10.4717 44.0505 10.1071C47.8511 9.54855 51.7191 9.52689 55.5402 10.0491C60.8642 10.7766 65.9928 12.5457 70.6331 15.2552C75.2735 17.9648 79.3347 21.5619 82.5849 25.841C84.9175 28.9121 86.7997 32.2913 88.1811 35.8758C89.083 38.2158 91.5421 39.6781 93.9676 39.0409Z"
            fill="currentColor"
          />
        </svg>
        Loading...
      <% else %>
        {render_slot(@inner_block)}
      <% end %>
    </button>
    """
  end

  # Default button variants (filled)
  defp button_variant_class("default", "blue"), do: "text-white bg-blue-700 hover:bg-blue-800 focus:ring-blue-300 dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"
  defp button_variant_class("default", "alternative"), do: "text-gray-900 bg-white border border-gray-200 hover:bg-gray-100 hover:text-blue-700 focus:ring-gray-200 dark:focus:ring-gray-700 dark:bg-gray-800 dark:text-gray-400 dark:border-gray-600 dark:hover:text-white dark:hover:bg-gray-700"
  defp button_variant_class("default", "dark"), do: "text-white bg-gray-800 hover:bg-gray-900 focus:ring-gray-300 dark:bg-gray-800 dark:hover:bg-gray-700 dark:focus:ring-gray-700 dark:border-gray-700"
  defp button_variant_class("default", "light"), do: "text-gray-900 bg-white border border-gray-300 hover:bg-gray-100 focus:ring-gray-200 dark:bg-gray-800 dark:text-white dark:border-gray-600 dark:hover:bg-gray-700 dark:hover:border-gray-600 dark:focus:ring-gray-700"
  defp button_variant_class("default", "green"), do: "text-white bg-green-700 hover:bg-green-800 focus:ring-green-300 dark:bg-green-600 dark:hover:bg-green-700 dark:focus:ring-green-800"
  defp button_variant_class("default", "red"), do: "text-white bg-red-700 hover:bg-red-800 focus:ring-red-300 dark:bg-red-600 dark:hover:bg-red-700 dark:focus:ring-red-900"
  defp button_variant_class("default", "yellow"), do: "text-white bg-yellow-400 hover:bg-yellow-500 focus:ring-yellow-300 dark:focus:ring-yellow-900"
  defp button_variant_class("default", "purple"), do: "text-white bg-purple-700 hover:bg-purple-800 focus:ring-purple-300 dark:bg-purple-600 dark:hover:bg-purple-700 dark:focus:ring-purple-900"
  
  # Outline button variants
  defp button_variant_class("outline", "blue"), do: "text-blue-700 hover:text-white border border-blue-700 hover:bg-blue-800 focus:ring-blue-300 dark:border-blue-500 dark:text-blue-500 dark:hover:text-white dark:hover:bg-blue-500 dark:focus:ring-blue-800"
  defp button_variant_class("outline", "dark"), do: "text-gray-900 hover:text-white border border-gray-800 hover:bg-gray-900 focus:ring-gray-300 dark:border-gray-600 dark:text-gray-400 dark:hover:text-white dark:hover:bg-gray-600 dark:focus:ring-gray-800"
  defp button_variant_class("outline", "green"), do: "text-green-700 hover:text-white border border-green-700 hover:bg-green-800 focus:ring-green-300 dark:border-green-500 dark:text-green-500 dark:hover:text-white dark:hover:bg-green-600 dark:focus:ring-green-800"
  defp button_variant_class("outline", "red"), do: "text-red-700 hover:text-white border border-red-700 hover:bg-red-800 focus:ring-red-300 dark:border-red-500 dark:text-red-500 dark:hover:text-white dark:hover:bg-red-600 dark:focus:ring-red-900"
  defp button_variant_class("outline", "yellow"), do: "text-yellow-400 hover:text-white border border-yellow-400 hover:bg-yellow-500 focus:ring-yellow-300 dark:border-yellow-300 dark:text-yellow-300 dark:hover:text-white dark:hover:bg-yellow-400 dark:focus:ring-yellow-900"
  defp button_variant_class("outline", "purple"), do: "text-purple-700 hover:text-white border border-purple-700 hover:bg-purple-800 focus:ring-purple-300 dark:border-purple-400 dark:text-purple-400 dark:hover:text-white dark:hover:bg-purple-500 dark:focus:ring-purple-900"
  # Default fallback for outline variants not specified
  defp button_variant_class("outline", _), do: "text-blue-700 hover:text-white border border-blue-700 hover:bg-blue-800 focus:ring-blue-300 dark:border-blue-500 dark:text-blue-500 dark:hover:text-white dark:hover:bg-blue-500 dark:focus:ring-blue-800"

  defp button_size_class("xs"), do: "px-3 py-2 text-xs"
  defp button_size_class("sm"), do: "px-3 py-2 text-sm"
  defp button_size_class("default"), do: "px-5 py-2.5 text-sm"
  defp button_size_class("lg"), do: "px-5 py-3 text-base"
  defp button_size_class("xl"), do: "px-6 py-3.5 text-base"

  @doc """
  Renders an input with label and error messages using Flowbite styling.

  A `Phoenix.HTML.FormField` may be passed as argument,
  which is used to retrieve the input name, id, and values.
  Otherwise all attributes may be passed explicitly.

  ## Types

  This function accepts all HTML input types, considering that:

    * You may also set `type="select"` to render a `<select>` tag

    * `type="checkbox"` is used exclusively to render boolean values

    * For live file uploads, see `Phoenix.Component.live_file_input/1`

  See https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input
  for more information. Unsupported types, such as hidden and radio,
  are best written directly in your templates.

  ## Examples

      <.input field={@form[:email]} type="email" />
      <.input name="my-input" errors={["oh no!"]} />
  """
  attr :id, :any, default: nil
  attr :name, :any
  attr :label, :string, default: nil
  attr :value, :any

  attr :type, :string,
    default: "text",
    values: ~w(checkbox color date datetime-local email file hidden month number password
               range search select tel text textarea time url week)

  attr :field, Phoenix.HTML.FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"

  attr :errors, :list, default: []
  attr :checked, :boolean, doc: "the checked flag for checkbox inputs"
  attr :prompt, :string, default: nil, doc: "the prompt for select inputs"
  attr :options, :list, doc: "the options to pass to Phoenix.HTML.Form.options_for_select/2"
  attr :multiple, :boolean, default: false, doc: "the multiple flag for select inputs"

  attr :rest, :global,
    include: ~w(accept autocomplete capture cols disabled form list max maxlength min minlength
                multiple pattern placeholder readonly required rows size step)

  def input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []

    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, Enum.map(errors, &translate_error(&1)))
    |> assign_new(:name, fn -> if assigns.multiple, do: field.name <> "[]", else: field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> input()
  end

  def input(%{type: "checkbox"} = assigns) do
    assigns = assign_new(assigns, :checked, fn -> false end)

    ~H"""
    <div class="mb-5">
      <div class="flex items-center">
        <input
          type="checkbox"
          id={@id}
          name={@name}
          value="true"
          checked={@checked}
          class={[
            "w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 rounded focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600",
            @errors != [] && "border-red-500 dark:border-red-500"
          ]}
          {@rest}
        />
        <label :if={@label} for={@id} class="ms-2 text-sm font-medium text-gray-900 dark:text-gray-300">
          {@label}
        </label>
      </div>
      <.error :for={msg <- @errors}>{msg}</.error>
    </div>
    """
  end

  def input(%{type: "select"} = assigns) do
    ~H"""
    <div class="mb-5">
      <.label for={@id}>{@label}</.label>
      <select
        id={@id}
        name={@name}
        class={[
          "bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500",
          @errors != [] && "border-red-500 dark:border-red-500"
        ]}
        multiple={@multiple}
        {@rest}
      >
        <option :if={@prompt} value="">{@prompt}</option>
        {Phoenix.HTML.Form.options_for_select(@options, @value)}
      </select>
      <.error :for={msg <- @errors}>{@label} {msg}</.error>
    </div>
    """
  end

  def input(%{type: "textarea"} = assigns) do
    ~H"""
    <div class="mb-5">
      <.label for={@id}>{@label}</.label>
      <textarea
        id={@id}
        name={@name}
        class={[
          "block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500",
          @errors != [] && "border-red-500 dark:border-red-500"
        ]}
        {@rest}
      >{Phoenix.HTML.Form.normalize_value("textarea", @value)}</textarea>
      <.error :for={msg <- @errors}>{@label} {msg}</.error>
    </div>
    """
  end

  # All other inputs text, datetime-local, url, password, etc. are handled here...
  def input(assigns) do
    ~H"""
    <div class="mb-5">
      <.label for={@id}>{@label}</.label>
      <input
        type={@type}
        name={@name}
        id={@id}
        value={Phoenix.HTML.Form.normalize_value(@type, @value)}
        class={[
          "bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500",
          @errors != [] && "border-red-500 dark:border-red-500"
        ]}
        {@rest}
      />
      <.error :for={msg <- @errors}>{@label} {msg}</.error>
    </div>
    """
  end

  @doc """
  Renders a label with Flowbite styling.
  """
  attr :for, :string, default: nil
  slot :inner_block, required: true

  def label(assigns) do
    ~H"""
    <label for={@for} class="block mb-2 text-sm font-medium text-gray-900 dark:text-white">
      {render_slot(@inner_block)}
    </label>
    """
  end

  @doc """
  Generates a generic error message with Flowbite styling.
  """
  slot :inner_block, required: true

  def error(assigns) do
    ~H"""
    <p class="mt-2 text-sm text-red-600 dark:text-red-500">
      <span class="font-medium">{render_slot(@inner_block)}</span>
    </p>
    """
  end

  @doc """
  Renders a header with title using consistent styling.

  ## Examples

      <.header>
        Account Settings
        <:subtitle>Manage your account email address and password settings</:subtitle>
      </.header>
  """
  attr :class, :string, default: nil

  slot :inner_block, required: true
  slot :subtitle
  slot :actions

  def header(assigns) do
    ~H"""
    <div class={["text-center mb-8", @class]}>
      <h1 class="text-2xl font-bold mb-2 text-gray-900 dark:text-white">
        {render_slot(@inner_block)}
      </h1>
      <p :if={@subtitle != []} class="text-gray-600 dark:text-gray-400">
        {render_slot(@subtitle)}
      </p>
      <div :if={@actions != []} class="mt-3">
        {render_slot(@actions)}
      </div>
    </div>
    """
  end

  @doc """
  Renders a table with Flowbite styling.

  ## Examples

      <.table id="users" rows={@users}>
        <:col :let={user} label="id">{user.id}</:col>
        <:col :let={user} label="username">{user.username}</:col>
      </.table>
  """
  attr :id, :string, required: true
  attr :rows, :list, required: true
  attr :row_id, :any, default: nil, doc: "the function for generating the row id"
  attr :row_click, :any, default: nil, doc: "the function for handling phx-click on each row"

  attr :row_item, :any,
    default: &Function.identity/1,
    doc: "the function for mapping each row before calling the :col and :action slots"

  slot :col, required: true do
    attr :label, :string
  end

  slot :action, doc: "the slot for showing user actions in the last table column"

  def table(assigns) do
    assigns =
      with %{rows: %Phoenix.LiveView.LiveStream{}} <- assigns do
        assign(assigns, row_id: assigns.row_id || fn {id, _item} -> id end)
      end

    ~H"""
    <div class="relative overflow-x-auto shadow-md sm:rounded-lg">
      <table class="w-full text-sm text-left rtl:text-right text-gray-500 dark:text-gray-400">
        <thead class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
          <tr>
            <th :for={col <- @col} scope="col" class="px-6 py-3">
              {col[:label]}
            </th>
            <th :if={@action != []} scope="col" class="px-6 py-3">
              <span class="sr-only">{gettext("Actions")}</span>
            </th>
          </tr>
        </thead>
        <tbody
          id={@id}
          phx-update={match?(%Phoenix.LiveView.LiveStream{}, @rows) && "stream"}
        >
          <tr
            :for={row <- @rows}
            id={@row_id && @row_id.(row)}
            class="bg-white border-b dark:bg-gray-800 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600"
            phx-click={@row_click && @row_click.(row)}
          >
            <td
              :for={{col, i} <- Enum.with_index(@col)}
              class={[
                "px-6 py-4",
                @row_click && "cursor-pointer",
                i == 0 && "font-medium text-gray-900 whitespace-nowrap dark:text-white"
              ]}
            >
              {render_slot(col, @row_item.(row))}
            </td>
            <td :if={@action != []} class="px-6 py-4 text-right">
              <span :for={action <- @action} class="relative">
                {render_slot(action, @row_item.(row))}
              </span>
            </td>
          </tr>
        </tbody>
      </table>
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
      <.icon name="hero-information-circle-mini" class="flex-shrink-0 w-4 h-4 me-3" />
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
        <.icon name="hero-x-mark-solid" class="w-3 h-3" />
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
  Renders a card with Flowbite styling.

  ## Examples

      <.card>
        <.card_header>Card Title</.card_header>
        <p>Card content goes here.</p>
      </.card>
  """
  attr :class, :string, default: ""
  slot :inner_block, required: true

  def card(assigns) do
    ~H"""
    <div class={[
      "max-w-sm p-6 bg-white border border-gray-200 rounded-lg shadow dark:bg-gray-800 dark:border-gray-700",
      @class
    ]}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a card header.
  """
  attr :class, :string, default: ""
  slot :inner_block, required: true

  def card_header(assigns) do
    ~H"""
    <h5 class={["mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white", @class]}>
      {render_slot(@inner_block)}
    </h5>
    """
  end

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

  @doc """
  Renders a back navigation link.

  ## Examples

      <.back navigate={~p"/posts"}>Back to posts</.back>
  """
  attr :navigate, :any, required: true
  slot :inner_block, required: true

  def back(assigns) do
    ~H"""
    <div class="mt-4">
      <.link
        navigate={@navigate}
        class="inline-flex items-center text-blue-600 hover:text-blue-700 dark:text-blue-400 dark:hover:text-blue-500"
      >
        <.icon name="hero-arrow-left-solid" class="w-4 h-4 mr-1" />
        {render_slot(@inner_block)}
      </.link>
    </div>
    """
  end

  @doc """
  Renders a [Heroicon](https://heroicons.com).

  Heroicons come in three styles – outline, solid, and mini.
  By default, the outline style is used, but solid and mini may
  be applied by using the `-solid` and `-mini` suffix.

  You can customize the size and colors of the icons by setting
  width, height, and background color classes.

  Icons are extracted from the `deps/heroicons` directory and bundled within
  your compiled app.css by the plugin in your `assets/tailwind.config.js`.

  ## Examples

      <.icon name="hero-x-mark-solid" />
      <.icon name="hero-arrow-path" class="ml-1 w-3 h-3 animate-spin" />
  """
  attr :name, :string, required: true
  attr :class, :string, default: nil
  attr :id, :string, default: nil

  def icon(%{name: "hero-" <> _} = assigns) do
    ~H"""
    <span class={[@name, @class]} id={@id} />
    """
  end

  @doc """
  Renders a toggle switch component using Flowbite styling.

  ## Examples

      <.toggle name="notifications" label="Enable notifications" />
      <.toggle name="dark_mode" label="Dark mode" checked={true} />
  """
  attr :id, :string, default: nil
  attr :name, :string, required: true
  attr :label, :string, default: nil
  attr :checked, :boolean, default: false
  attr :class, :string, default: ""
  attr :rest, :global

  def toggle(assigns) do
    ~H"""
    <label class={["inline-flex items-center cursor-pointer", @class]}>
      <input
        type="checkbox"
        name={@name}
        id={@id}
        checked={@checked}
        class="sr-only peer"
        {@rest}
      />
      <div class="relative w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 dark:peer-focus:ring-blue-800 rounded-full peer dark:bg-gray-700 peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:start-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-gray-600 peer-checked:bg-blue-600"></div>
      <span :if={@label} class="ms-3 text-sm font-medium text-gray-900 dark:text-gray-300">
        {@label}
      </span>
    </label>
    """
  end

  @doc """
  Renders a dropdown component using Flowbite styling.

  ## Examples

      <.dropdown id="user-menu">
        <:trigger>
          <.button>Options</.button>
        </:trigger>
        <:item navigate={~p"/profile"}>Profile</:item>
        <:item navigate={~p"/settings"}>Settings</:item>
      </.dropdown>
  """
  attr :id, :string, required: true
  attr :class, :string, default: ""
  slot :trigger, required: true
  slot :item, required: true do
    attr :navigate, :string
    attr :method, :string
  end

  def dropdown(assigns) do
    ~H"""
    <div class={["relative inline-block text-left", @class]}>
      <div>
        <button
          type="button"
          class="inline-flex w-full justify-center gap-x-1.5"
          id={"#{@id}-button"}
          data-dropdown-toggle={@id}
          aria-expanded="false"
          aria-haspopup="true"
        >
          {render_slot(@trigger)}
        </button>
      </div>

      <div
        id={@id}
        class="hidden z-50 my-4 text-base list-none bg-white divide-y divide-gray-100 rounded-lg shadow dark:bg-gray-700 dark:divide-gray-600"
        data-dropdown-menu
      >
        <ul class="py-2" role="none">
          <li :for={item <- @item}>
            <.link
              :if={Map.get(item, :navigate)}
              navigate={item.navigate}
              method={Map.get(item, :method, "get")}
              class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 dark:text-gray-300 dark:hover:bg-gray-600 dark:hover:text-white"
              role="menuitem"
            >
              {render_slot(item)}
            </.link>
            <button
              :if={!Map.get(item, :navigate)}
              type="button"
              class="block w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 dark:text-gray-300 dark:hover:bg-gray-600 dark:hover:text-white"
              role="menuitem"
            >
              {render_slot(item)}
            </button>
          </li>
        </ul>
      </div>
    </div>
    """
  end

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

  def show_modal(js \\ %JS{}, id) when is_binary(id) do
    js
    |> JS.show(to: "##{id}")
    |> JS.show(
      to: "##{id}-bg",
      time: 300,
      transition: {"transition-all transform ease-out duration-300", "opacity-0", "opacity-100"}
    )
    |> show("##{id}-container")
    |> JS.add_class("overflow-hidden", to: "body")
    |> JS.focus_first(to: "##{id}-content")
  end

  def hide_modal(js \\ %JS{}, id) do
    js
    |> JS.hide(
      to: "##{id}-bg",
      transition: {"transition-all transform ease-in duration-200", "opacity-100", "opacity-0"}
    )
    |> hide("##{id}-container")
    |> JS.hide(to: "##{id}", transition: {"block", "block", "hidden"})
    |> JS.remove_class("overflow-hidden", to: "body")
    |> JS.pop_focus()
  end

  @doc """
  Translates an error message using gettext.
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
      Gettext.dngettext(MachineTalentsWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(MachineTalentsWeb.Gettext, "errors", msg, opts)
    end
  end

  @doc """
  Translates the errors for a field from a keyword list of errors.
  """
  def translate_errors(errors, field) when is_list(errors) do
    for {^field, {msg, opts}} <- errors, do: translate_error({msg, opts})
  end

  def translate_error(msg), do: msg
end