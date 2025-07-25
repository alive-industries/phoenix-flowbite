defmodule Mix.Tasks.FlowbitePhoenix.Install do
  @moduledoc """
  Installs FlowbitePhoenix in a Phoenix application.

  This task configures your Phoenix application to use FlowbitePhoenix components
  by adding the necessary CSS and JavaScript assets, and optionally generating
  example components.

      mix flowbite_phoenix.install

  ## Options

    * `--no-assets` - Skip adding Flowbite CSS/JS assets to root.html.heex
    * `--no-examples` - Skip generating example components
    * `--gettext` - Configure Gettext backend for translations

  ## What it does

  1. Adds Flowbite CSS and JavaScript to your root.html.heex template
  2. Creates example components demonstrating usage
  3. Optionally configures Gettext backend
  4. Provides usage instructions

  """

  use Mix.Task

  @shortdoc "Installs FlowbitePhoenix in a Phoenix application"

  @switches [
    no_assets: :boolean,
    no_examples: :boolean,
    gettext: :boolean
  ]

  @impl Mix.Task
  def run(args) do
    {opts, _} = OptionParser.parse!(args, switches: @switches)

    unless File.exists?("mix.exs") do
      Mix.raise("mix.exs not found. Please run this task from the root of your Phoenix project.")
    end

    project_name = get_project_name()
    
    Mix.shell().info("Installing FlowbitePhoenix...")

    unless opts[:no_assets] do
      install_assets(project_name)
    end

    if opts[:gettext] do
      configure_gettext(project_name)
    end

    unless opts[:no_examples] do
      generate_examples(project_name)
    end

    print_next_steps(opts)
  end

  defp get_project_name do
    Mix.Project.config()[:app]
    |> Atom.to_string()
    |> Macro.camelize()
  end

  defp install_assets(project_name) do
    Mix.shell().info("Adding Flowbite assets to root.html.heex...")
    
    root_template_paths = [
      "lib/#{Macro.underscore(project_name)}_web/components/layouts/root.html.heex",
      "lib/#{Macro.underscore(project_name)}_web/templates/layout/root.html.heex"
    ]

    root_template_path = Enum.find(root_template_paths, &File.exists?/1)

    case root_template_path do
      nil ->
        Mix.shell().error("Could not find root.html.heex template. Please add Flowbite assets manually:")
        print_manual_asset_instructions()

      path ->
        add_assets_to_template(path)
    end
  end

  defp add_assets_to_template(path) do
    content = File.read!(path)
    
    # Check if Flowbite CSS is already present
    if String.contains?(content, "flowbite") do
      Mix.shell().info("Flowbite assets already present in #{path}")
    else
      # Add CSS before closing </head>
      css_link = ~s(    <link href="https://cdnjs.cloudflare.com/ajax/libs/flowbite/2.2.1/flowbite.min.css" rel="stylesheet" />)
      
      updated_content = 
        content
        |> String.replace("</head>", "#{css_link}\n  </head>")

      # Add JS before closing </body>
      js_script = ~s(    <script src="https://cdn.jsdelivr.net/npm/flowbite@3.1.2/dist/flowbite.phoenix.min.js"></script>)
      
      final_content = 
        updated_content
        |> String.replace("</body>", "#{js_script}\n  </body>")

      File.write!(path, final_content)
      Mix.shell().info("✓ Added Flowbite CSS and Phoenix-compatible JS to #{path}")
      Mix.shell().info("  Note: Using flowbite.phoenix.js for proper LiveView support")
    end
  end

  defp configure_gettext(project_name) do
    Mix.shell().info("Configuring Gettext backend...")
    
    config_path = "config/config.exs"
    
    if File.exists?(config_path) do
      config_content = File.read!(config_path)
      gettext_config = """

# Configure FlowbitePhoenix to use your Gettext backend
config :flowbite_phoenix,
  gettext_backend: #{project_name}Web.Gettext
"""

      unless String.contains?(config_content, "flowbite_phoenix") do
        updated_config = config_content <> gettext_config
        File.write!(config_path, updated_config)
        Mix.shell().info("✓ Added FlowbitePhoenix configuration to config/config.exs")
      else
        Mix.shell().info("FlowbitePhoenix configuration already present")
      end
    end
  end

  defp generate_examples(project_name) do
    Mix.shell().info("Generating example components...")
    
    examples_dir = "lib/#{Macro.underscore(project_name)}_web/live/examples"
    File.mkdir_p!(examples_dir)

    # Generate example LiveView
    example_live_path = Path.join(examples_dir, "flowbite_examples_live.ex")
    
    unless File.exists?(example_live_path) do
      example_content = example_live_content(project_name)
      File.write!(example_live_path, example_content)
      Mix.shell().info("✓ Created #{example_live_path}")
    end

    # Generate example template
    example_template_path = Path.join(examples_dir, "flowbite_examples_live.html.heex")
    
    unless File.exists?(example_template_path) do
      template_content = example_template_content()
      File.write!(example_template_path, template_content)
      Mix.shell().info("✓ Created #{example_template_path}")
    end

    # Generate router entry suggestion
    Mix.shell().info("""

    Add this route to your router.ex to view the examples:

        live "/flowbite-examples", #{project_name}Web.Examples.FlowbiteExamplesLive
    """)
  end

  defp example_live_content(project_name) do
    """
defmodule #{project_name}Web.Examples.FlowbiteExamplesLive do
  use #{project_name}Web, :live_view
  import FlowbitePhoenix.Components

  def mount(_params, _session, socket) do
    {:ok, 
     socket
     |> assign(:show_modal, false)
     |> assign(:form, to_form(%{"email" => "", "message" => ""}))}
  end

  def handle_event("show_modal", _, socket) do
    {:noreply, assign(socket, :show_modal, true)}
  end

  def handle_event("hide_modal", _, socket) do
    {:noreply, assign(socket, :show_modal, false)}
  end

  def handle_event("validate", %{"form" => params}, socket) do
    {:noreply, assign(socket, :form, to_form(params))}
  end

  def handle_event("submit", %{"form" => params}, socket) do
    # Handle form submission
    {:noreply, 
     socket
     |> put_flash(:info, "Form submitted successfully!")
     |> assign(:form, to_form(%{"email" => "", "message" => ""}))}
  end
end
"""
  end

  defp example_template_content do
    """
<div class="p-8 max-w-4xl mx-auto">
  <.header>
    FlowbitePhoenix Examples
    <:subtitle>Explore the available components</:subtitle>
  </.header>

  <!-- Buttons Section -->
  <div class="mb-8">
    <h2 class="text-xl font-semibold mb-4 text-gray-900 dark:text-white">Buttons</h2>
    <div class="flex gap-2 flex-wrap">
      <.button color="blue">Primary</.button>
      <.button variant="outline" color="blue">Outline</.button>
      <.button color="green">Success</.button>
      <.button color="red">Danger</.button>
      <.button loading={true}>Loading</.button>
    </div>
  </div>

  <!-- Form Section -->
  <div class="mb-8">
    <h2 class="text-xl font-semibold mb-4 text-gray-900 dark:text-white">Forms</h2>
    <.simple_form for={@form} phx-change="validate" phx-submit="submit" class="max-w-md">
      <.input field={@form[:email]} type="email" label="Email" required />
      <.input field={@form[:message]} type="textarea" label="Message" rows="4" />
      <.toggle name="newsletter" label="Subscribe to newsletter" />
      
      <:actions>
        <.button type="submit">Submit</.button>
      </:actions>
    </.simple_form>
  </div>

  <!-- Alerts Section -->
  <div class="mb-8">
    <h2 class="text-xl font-semibold mb-4 text-gray-900 dark:text-white">Alerts</h2>
    <.alert color="blue" class="mb-2">This is an info alert</.alert>
    <.alert color="green" class="mb-2">This is a success alert</.alert>
    <.alert color="red" class="mb-2">This is an error alert</.alert>
    <.alert color="yellow">This is a warning alert</.alert>
  </div>

  <!-- Badges Section -->
  <div class="mb-8">
    <h2 class="text-xl font-semibold mb-4 text-gray-900 dark:text-white">Badges</h2>
    <div class="flex gap-2 flex-wrap">
      <.badge color="blue">Default</.badge>
      <.badge color="green">Success</.badge>
      <.badge color="red">Error</.badge>
      <.badge color="yellow">Warning</.badge>
      <.badge color="purple">Purple</.badge>
    </div>
  </div>

  <!-- Cards Section -->
  <div class="mb-8">
    <h2 class="text-xl font-semibold mb-4 text-gray-900 dark:text-white">Cards</h2>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      <.card>
        <.card_header>Card Title</.card_header>
        <p class="text-gray-700 dark:text-gray-400">
          This is a card with some example content to demonstrate the styling.
        </p>
      </.card>
      
      <.card>
        <.card_header>Another Card</.card_header>
        <p class="text-gray-700 dark:text-gray-400">
          Cards are great for displaying related information in a clean format.
        </p>
      </.card>
    </div>
  </div>

  <!-- Modal Section -->
  <div class="mb-8">
    <h2 class="text-xl font-semibold mb-4 text-gray-900 dark:text-white">Modal</h2>
    <.button phx-click="show_modal">Show Modal</.button>
    
    <.modal id="example-modal" show={@show_modal} on_cancel={JS.push("hide_modal")}>
      <:title>Example Modal</:title>
      <p>This is an example modal using FlowbitePhoenix components.</p>
      <div class="mt-4">
        <.button phx-click="hide_modal">Close</.button>
      </div>
    </.modal>
  </div>

  <!-- Spinner Section -->
  <div class="mb-8">
    <h2 class="text-xl font-semibold mb-4 text-gray-900 dark:text-white">Spinners</h2>
    <div class="flex gap-4 items-center">
      <.spinner size="sm" />
      <.spinner />
      <.spinner size="lg" />
    </div>
  </div>

  <!-- Navigation Section -->
  <div class="mb-8">
    <h2 class="text-xl font-semibold mb-4 text-gray-900 dark:text-white">Navigation</h2>
    
    <div class="mb-4">
      <h3 class="text-lg font-medium mb-2 text-gray-800 dark:text-gray-200">Breadcrumb</h3>
      <.breadcrumb>
        <:item navigate="/">Home</:item>
        <:item navigate="/examples">Examples</:item>
        <:item>FlowbitePhoenix</:item>
      </.breadcrumb>
    </div>

    <div class="mb-4">
      <h3 class="text-lg font-medium mb-2 text-gray-800 dark:text-gray-200">Back Link</h3>
      <.back navigate="/">Back to Home</.back>
    </div>
  </div>
</div>
"""
  end

  defp print_manual_asset_instructions do
    Mix.shell().info("""

    Please add these lines to your root.html.heex template:

    In the <head> section:
      <link href="https://cdnjs.cloudflare.com/ajax/libs/flowbite/2.2.1/flowbite.min.css" rel="stylesheet" />

    Before the closing </body> tag (Phoenix LiveView compatible):
      <script src="https://cdn.jsdelivr.net/npm/flowbite@3.1.2/dist/flowbite.phoenix.min.js"></script>
    """)
  end

  defp print_next_steps(opts) do
    Mix.shell().info("""

    ✅ FlowbitePhoenix installation complete!

    Next steps:
    1. Import components in your templates:
       import FlowbitePhoenix.Components

    2. Start using components:
       <.button>Click me</.button>
       <.alert color="green">Success!</.alert>

    #{if opts[:no_examples] do
      "3. Generate examples with: mix flowbite_phoenix.install --no-assets"
    else
      "3. Visit /flowbite-examples to see component examples"
    end}

    4. Read the documentation: https://hexdocs.pm/flowbite_phoenix

    ⚠️  Important: We've added flowbite.phoenix.js (not regular flowbite.js)
       This ensures interactive components work properly with LiveView.

    For more information, visit: https://github.com/flowbite/flowbite_phoenix
    """)
  end
end