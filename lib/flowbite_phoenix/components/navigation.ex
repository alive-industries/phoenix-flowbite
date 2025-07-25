defmodule FlowbitePhoenix.Components.Navigation do
  @moduledoc """
  Navigation components for FlowbitePhoenix using Flowbite CSS framework.
  
  This module provides navigation-related components including dropdowns, 
  back links, and other navigation elements with consistent Flowbite styling.
  """
  
  use Phoenix.Component
  alias Phoenix.LiveView.JS

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
        <FlowbitePhoenix.Components.Layout.icon name="hero-arrow-left-solid" class="w-4 h-4 mr-1" />
        {render_slot(@inner_block)}
      </.link>
    </div>
    """
  end

  @doc """
  Renders a breadcrumb navigation component.

  ## Examples

      <.breadcrumb>
        <:item navigate={~p"/"}>Home</:item>
        <:item navigate={~p"/posts"}>Posts</:item>
        <:item>Current Page</:item>
      </.breadcrumb>
  """
  attr :class, :string, default: ""
  slot :item, required: true do
    attr :navigate, :string
  end

  def breadcrumb(assigns) do
    ~H"""
    <nav class={["flex", @class]} aria-label="Breadcrumb">
      <ol class="inline-flex items-center space-x-1 md:space-x-2 rtl:space-x-reverse">
        <li :for={{item, index} <- Enum.with_index(@item)} class="inline-flex items-center">
          <.link
            :if={Map.get(item, :navigate) && index > 0}
            navigate={item.navigate}
            class="inline-flex items-center text-sm font-medium text-gray-700 hover:text-blue-600 dark:text-gray-400 dark:hover:text-white"
          >
            <svg class="rtl:rotate-180 w-3 h-3 text-gray-400 mx-1" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 6 10">
              <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m1 9 4-4-4-4"/>
            </svg>
            {render_slot(item)}
          </.link>
          <.link
            :if={Map.get(item, :navigate) && index == 0}
            navigate={item.navigate}
            class="inline-flex items-center text-sm font-medium text-gray-700 hover:text-blue-600 dark:text-gray-400 dark:hover:text-white"
          >
            <svg class="w-3 h-3 me-2.5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 20 20">
              <path d="m19.707 9.293-2-2-7-7a1 1 0 0 0-1.414 0l-7 7-2 2a1 1 0 0 0 1.414 1.414L2 10.414V18a2 2 0 0 0 2 2h3a1 1 0 0 0 1-1v-4a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v4a1 1 0 0 0 1 1h3a2 2 0 0 0 2-2v-7.586l.293.293a1 1 0 0 0 1.414-1.414Z"/>
            </svg>
            {render_slot(item)}
          </.link>
          <span :if={!Map.get(item, :navigate) && index > 0} class="ms-1 text-sm font-medium text-gray-500 md:ms-2 dark:text-gray-400">
            <svg class="rtl:rotate-180 w-3 h-3 text-gray-400 mx-1" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 6 10">
              <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m1 9 4-4-4-4"/>
            </svg>
            {render_slot(item)}
          </span>
          <span :if={!Map.get(item, :navigate) && index == 0} class="text-sm font-medium text-gray-500 dark:text-gray-400">
            {render_slot(item)}
          </span>
        </li>
      </ol>
    </nav>
    """
  end

  @doc """
  Renders a pagination component.

  ## Examples

      <.pagination 
        current_page={@current_page} 
        total_pages={@total_pages}
        path_fn={fn page -> "/posts?page=" <> to_string(page) end}
      />
  """
  attr :current_page, :integer, required: true
  attr :total_pages, :integer, required: true
  attr :path_fn, :any, required: true, doc: "Function that takes a page number and returns a path"
  attr :class, :string, default: ""

  def pagination(assigns) do
    ~H"""
    <nav aria-label="Page navigation" class={@class}>
      <ul class="inline-flex -space-x-px text-sm">
        <li>
          <.link
            :if={@current_page > 1}
            navigate={@path_fn.(@current_page - 1)}
            class="flex items-center justify-center px-3 h-8 ms-0 leading-tight text-gray-500 bg-white border border-e-0 border-gray-300 rounded-s-lg hover:bg-gray-100 hover:text-gray-700 dark:bg-gray-800 dark:border-gray-700 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white"
          >
            Previous
          </.link>
          <span
            :if={@current_page == 1}
            class="flex items-center justify-center px-3 h-8 ms-0 leading-tight text-gray-300 bg-gray-100 border border-e-0 border-gray-300 rounded-s-lg cursor-not-allowed dark:bg-gray-700 dark:border-gray-600 dark:text-gray-500"
          >
            Previous
          </span>
        </li>

        <li :for={page <- pagination_pages(@current_page, @total_pages)}>
          <.link
            :if={page != @current_page && page != :ellipsis}
            navigate={@path_fn.(page)}
            class="flex items-center justify-center px-3 h-8 leading-tight text-gray-500 bg-white border border-gray-300 hover:bg-gray-100 hover:text-gray-700 dark:bg-gray-800 dark:border-gray-700 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white"
          >
            {page}
          </.link>
          <span
            :if={page == @current_page}
            class="flex items-center justify-center px-3 h-8 text-blue-600 border border-gray-300 bg-blue-50 hover:bg-blue-100 hover:text-blue-700 dark:border-gray-700 dark:bg-gray-700 dark:text-white"
          >
            {page}
          </span>
          <span
            :if={page == :ellipsis}
            class="flex items-center justify-center px-3 h-8 leading-tight text-gray-500 bg-white border border-gray-300 dark:bg-gray-800 dark:border-gray-700 dark:text-gray-400"
          >
            ...
          </span>
        </li>

        <li>
          <.link
            :if={@current_page < @total_pages}
            navigate={@path_fn.(@current_page + 1)}
            class="flex items-center justify-center px-3 h-8 leading-tight text-gray-500 bg-white border border-gray-300 rounded-e-lg hover:bg-gray-100 hover:text-gray-700 dark:bg-gray-800 dark:border-gray-700 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white"
          >
            Next
          </.link>
          <span
            :if={@current_page == @total_pages}
            class="flex items-center justify-center px-3 h-8 leading-tight text-gray-300 bg-gray-100 border border-gray-300 rounded-e-lg cursor-not-allowed dark:bg-gray-700 dark:border-gray-600 dark:text-gray-500"
          >
            Next
          </span>
        </li>
      </ul>
    </nav>
    """
  end

  # Helper function to generate page numbers for pagination
  defp pagination_pages(current, total) when total <= 7 do
    1..total |> Enum.to_list()
  end

  defp pagination_pages(current, total) when current <= 4 do
    [1, 2, 3, 4, 5, :ellipsis, total]
  end

  defp pagination_pages(current, total) when current >= total - 3 do
    [1, :ellipsis, total - 4, total - 3, total - 2, total - 1, total]
  end

  defp pagination_pages(current, total) do
    [1, :ellipsis, current - 1, current, current + 1, :ellipsis, total]
  end
end