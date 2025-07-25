defmodule FlowbitePhoenix.Config do
  @moduledoc """
  Configuration management for FlowbitePhoenix.
  
  This module provides centralized configuration management for themes,
  colors, and other customizable aspects of FlowbitePhoenix components.
  """

  @default_config %{
    theme: %{
      primary_color: "blue",
      secondary_color: "gray",
      success_color: "green",
      warning_color: "yellow",
      error_color: "red",
      info_color: "blue"
    },
    button: %{
      base_classes: "focus:ring-4 focus:outline-none font-medium rounded-lg text-center inline-flex items-center",
      sizes: %{
        xs: "px-3 py-2 text-xs",
        sm: "px-3 py-2 text-sm",
        default: "px-5 py-2.5 text-sm",
        lg: "px-5 py-3 text-base",
        xl: "px-6 py-3.5 text-base"
      }
    },
    input: %{
      base_classes: "bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500",
      error_classes: "border-red-500 dark:border-red-500"
    },
    alert: %{
      base_classes: "flex items-center p-4 mb-4 text-sm rounded-lg"
    },
    badge: %{
      base_classes: "inline-flex items-center font-medium me-2 px-2.5 py-0.5 rounded"
    }
  }

  @doc """
  Gets the complete configuration for FlowbitePhoenix.
  
  Merges application configuration with defaults.
  """
  def get_config do
    app_config = Application.get_env(:flowbite_phoenix, :theme, %{})
    deep_merge(@default_config, %{theme: app_config})
  end

  @doc """
  Gets a specific configuration value by path.
  
  ## Examples
  
      FlowbitePhoenix.Config.get([:theme, :primary_color])
      # => "blue"
      
      FlowbitePhoenix.Config.get([:button, :base_classes])
      # => "focus:ring-4 focus:outline-none..."
  """
  def get(path) when is_list(path) do
    get_in(get_config(), path)
  end

  def get(key) when is_atom(key) do
    get([key])
  end

  @doc """
  Gets the primary color from theme configuration.
  """
  def primary_color do
    get([:theme, :primary_color])
  end

  @doc """
  Gets button configuration.
  """
  def button_config do
    get(:button)
  end

  @doc """
  Gets input configuration.
  """
  def input_config do
    get(:input)
  end

  @doc """
  Gets alert configuration.
  """
  def alert_config do
    get(:alert)
  end

  @doc """
  Gets badge configuration.  
  """
  def badge_config do
    get(:badge)
  end

  @doc """
  Gets the Gettext backend if configured.
  """
  def gettext_backend do
    Application.get_env(:flowbite_phoenix, :gettext_backend)
  end

  @doc """
  Checks if dark mode is enabled in configuration.
  """
  def dark_mode_enabled? do
    Application.get_env(:flowbite_phoenix, :dark_mode, true)
  end

  @doc """
  Gets component-specific configuration.
  """
  def component_config(component) when is_atom(component) do
    get([component]) || %{}
  end

  # Private helper for deep merging maps
  defp deep_merge(left, right) do
    Map.merge(left, right, &deep_resolve/3)
  end

  defp deep_resolve(_key, %{} = left, %{} = right) do
    deep_merge(left, right)
  end

  defp deep_resolve(_key, _left, right) do
    right
  end

  @doc """
  Validates the configuration and returns any errors.
  """
  def validate_config do
    config = get_config()
    errors = []

    # Validate theme colors
    errors = 
      case get_in(config, [:theme, :primary_color]) do
        color when color in ~w(blue gray red green yellow indigo purple pink) -> errors
        _ -> ["Invalid primary_color. Must be one of: blue, gray, red, green, yellow, indigo, purple, pink" | errors]
      end

    case errors do
      [] -> :ok
      errors -> {:error, errors}
    end
  end

  @doc """
  Returns available color options for components.
  """
  def available_colors do
    ~w(blue gray red green yellow indigo purple pink)
  end

  @doc """
  Returns available size options for components.
  """
  def available_sizes do
    ~w(xs sm default lg xl)
  end
end