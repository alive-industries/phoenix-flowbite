defmodule FlowbitePhoenix.Gettext do
  @moduledoc """
  Gettext backend for FlowbitePhoenix.
  
  This module provides internationalization support for FlowbitePhoenix components.
  It can work with or without Gettext depending on what's available in the host application.
  """

  @doc """
  Translates a string using gettext if available, otherwise returns the default.
  
  This function provides fallback translations when Gettext is not available.
  """
  def gettext(message, default \\ nil)

  def gettext(message, default) do
    backend = Application.get_env(:flowbite_phoenix, :gettext_backend)
    
    case backend do
      nil ->
        # Fallback to default string if no backend configured
        default || default_translation(message)
      
      backend_module ->
        # Use the configured gettext backend
        try do
          Gettext.gettext(backend_module, message)
        rescue
          # Fallback if gettext fails
          _ -> default || default_translation(message)
        end
    end
  end

  @doc """
  Translates a string with domain using gettext if available.
  """
  def dgettext(domain, message, bindings \\ %{})

  def dgettext(domain, message, bindings) do
    backend = Application.get_env(:flowbite_phoenix, :gettext_backend)
    
    case backend do
      nil ->
        # Fallback to default string
        interpolate(default_translation(message), bindings)
      
      backend_module ->
        try do
          Gettext.dgettext(backend_module, domain, message, bindings)
        rescue
          _ -> interpolate(default_translation(message), bindings)
        end
    end
  end

  @doc """
  Translates plural forms using gettext if available.
  """
  def dngettext(domain, msgid, msgid_plural, n, bindings \\ %{})

  def dngettext(domain, msgid, msgid_plural, n, bindings) do
    backend = Application.get_env(:flowbite_phoenix, :gettext_backend)
    
    case backend do
      nil ->
        # Simple plural fallback
        message = if n == 1, do: msgid, else: msgid_plural
        interpolate(default_translation(message), bindings)
      
      backend_module ->
        try do
          Gettext.dngettext(backend_module, domain, msgid, msgid_plural, n, bindings)
        rescue
          _ -> 
            message = if n == 1, do: msgid, else: msgid_plural
            interpolate(default_translation(message), bindings)
        end
    end
  end

  # Provides default English translations for common UI messages
  defp default_translation(message) do
    case message do
      "Success!" -> "Success!"
      "Error!" -> "Error!"
      "close" -> "close"
      "Close" -> "Close"
      "Actions" -> "Actions"
      "We can't find the internet" -> "We can't find the internet"
      "Attempting to reconnect" -> "Attempting to reconnect"
      "Something went wrong!" -> "Something went wrong!"
      "Hang in there while we get back on track" -> "Hang in there while we get back on track"
      "Loading..." -> "Loading..."
      "Previous" -> "Previous"
      "Next" -> "Next"
      _ -> message
    end
  end

  # Simple string interpolation for bindings
  defp interpolate(string, bindings) when is_map(bindings) do
    Enum.reduce(bindings, string, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end

  defp interpolate(string, _bindings), do: string
end