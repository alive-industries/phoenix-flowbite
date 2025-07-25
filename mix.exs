defmodule FlowbitePhoenix.MixProject do
  use Mix.Project

  @version "0.1.1"
  @source_url "https://github.com/flowbite/flowbite_phoenix"

  def project do
    [
      app: :flowbite_phoenix,
      version: @version,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      docs: docs(),
      name: "FlowbitePhoenix",
      source_url: @source_url
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix, "~> 1.7"},
      {:phoenix_live_view, "~> 0.20"},
      {:gettext, "~> 0.20", optional: true},
      {:phoenix_html, "~> 4.0"},
      
      # Dev/test dependencies
      {:ex_doc, "~> 0.31", only: :dev, runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev], runtime: false}
    ]
  end

  defp description do
    """
    A comprehensive Phoenix LiveView component library using Flowbite CSS framework.
    Provides ready-to-use UI components with consistent Flowbite styling and theming support.
    """
  end

  defp package do
    [
      name: "flowbite_phoenix",
      files: ~w(lib mix.exs README* LICENSE* CHANGELOG*),
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url,
        "Flowbite" => "https://flowbite.com"
      },
      maintainers: ["Flowbite Team"]
    ]
  end

  defp docs do
    [
      main: "FlowbitePhoenix",
      source_ref: "v#{@version}",
      source_url: @source_url,
      extras: ["README.md", "CHANGELOG.md", "CONTRIBUTING.md", "LICENSE"],
      groups_for_modules: [
        "Components": [
          FlowbitePhoenix.Components.Forms,
          FlowbitePhoenix.Components.Layout,
          FlowbitePhoenix.Components.Feedback,
          FlowbitePhoenix.Components.Navigation
        ]
      ]
    ]
  end
end
