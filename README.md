# FlowbitePhoenix

A comprehensive Phoenix LiveView component library using the Flowbite CSS framework. FlowbitePhoenix provides ready-to-use UI components with beautiful styling, dark mode support, and flexible theming options.

[![Hex Version](https://img.shields.io/hexpm/v/flowbite_phoenix.svg)](https://hex.pm/packages/flowbite_phoenix)
[![Documentation](https://img.shields.io/badge/documentation-blue)](https://hexdocs.pm/flowbite_phoenix)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Downloads](https://img.shields.io/hexpm/dt/flowbite_phoenix.svg)](https://hex.pm/packages/flowbite_phoenix)

## Features

- 🎨 **Beautiful Components**: Pre-styled with Flowbite's modern design system
- 🌙 **Dark Mode**: Full dark mode support out of the box
- 🎯 **Type Safe**: Built with Phoenix.Component for compile-time validation
- 🌍 **i18n Ready**: Optional Gettext integration with fallback strings
- 🔧 **Customizable**: Flexible theming and configuration system
- 📱 **Responsive**: Mobile-first responsive design
- ⚡ **LiveView Native**: Optimized for Phoenix LiveView

## Components

### Forms
- `input/1` - Text inputs, selects, textareas, checkboxes
- `button/1` - Buttons with variants, colors, and loading states
- `simple_form/1` - Form wrapper with styling
- `toggle/1` - Toggle switches
- `label/1` and `error/1` - Form labels and error messages

### Layout
- `modal/1` - Modal dialogs with backdrop
- `table/1` - Data tables with sorting and actions
- `card/1` and `card_header/1` - Content cards
- `header/1` - Page headers with titles and subtitles
- `icon/1` - Heroicons integration

### Feedback
- `flash/1` and `flash_group/1` - Flash messages
- `alert/1` - Contextual alerts
- `badge/1` - Status badges and labels
- `spinner/1` - Loading spinners

### Navigation
- `dropdown/1` - Dropdown menus
- `breadcrumb/1` - Breadcrumb navigation
- `pagination/1` - Pagination controls
- `back/1` - Back navigation links

## Installation

Add `flowbite_phoenix` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:flowbite_phoenix, "~> 0.1.1"}
  ]
end
```

Then fetch the dependencies:

```bash
mix deps.get
```

Then run the installation task:

```bash
mix flowbite_phoenix.install
```

This will:
- Add Flowbite CSS and JavaScript to your `root.html.heex`
- Generate example components
- Set up configuration (optional)

## Manual Setup

If you prefer manual setup, add these to your `root.html.heex`:

```html
<!-- In the <head> section -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/flowbite/2.2.1/flowbite.min.css" rel="stylesheet" />

<!-- Before closing </body> - Phoenix LiveView compatible version -->
<script src="https://cdn.jsdelivr.net/npm/flowbite@3.1.2/dist/flowbite.phoenix.min.js"></script>
```

### JavaScript Setup Options

#### Option 1: CDN (Recommended for quick setup)
Use the Phoenix LiveView compatible CDN version shown above.

> **⚠️ Important**: Always use `flowbite.phoenix.js` or `flowbite.phoenix.min.js` with Phoenix LiveView. The regular Flowbite JS doesn't properly handle LiveView page transitions and will cause interactive components (dropdowns, modals, etc.) to stop working after navigation.

#### Option 2: NPM Package (Recommended for production)
Install via npm and import in your `assets/js/app.js`:

```bash
npm install flowbite
```

Then in your `assets/js/app.js`:

```javascript
// Import Phoenix LiveView compatible Flowbite
import "flowbite/dist/flowbite.phoenix.js";
```

And configure your `assets/tailwind.config.js` to include Flowbite:

```javascript
module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/my_app_web.ex",
    "../lib/my_app_web/**/*.*ex",
    "./node_modules/flowbite/**/*.js"  // Add this line
  ],
  theme: {
    extend: {},
  },
  plugins: [
    require('flowbite/plugin')  // Add this line
  ],
}
```

## Usage

Import the components in your LiveView or templates:

```elixir
# Import all components
import FlowbitePhoenix.Components

# Or import specific modules
import FlowbitePhoenix.Components.Forms
import FlowbitePhoenix.Components.Layout
import FlowbitePhoenix.Components.Feedback
import FlowbitePhoenix.Components.Navigation
```

### Basic Examples

**Buttons:**
```heex
<.button>Default Button</.button>
<.button color="green">Success</.button>
<.button variant="outline" color="red">Delete</.button>
<.button loading={true}>Loading...</.button>
```

**Forms:**
```heex
<.simple_form for={@form} phx-change="validate" phx-submit="save">
  <.input field={@form[:email]} type="email" label="Email" />
  <.input field={@form[:message]} type="textarea" label="Message" />
  <.toggle name="newsletter" label="Subscribe to newsletter" />
  
  <:actions>
    <.button type="submit">Save</.button>
  </:actions>
</.simple_form>
```

**Alerts:**
```heex
<.alert color="green">Success! Your changes have been saved.</.alert>
<.alert color="red" dismissible={true}>Error! Something went wrong.</.alert>
```

**Modal:**
```heex
<.modal id="confirm-modal" show={@show_modal}>
  <:title>Confirm Action</:title>
  <p>Are you sure you want to continue?</p>
  <div class="mt-4 flex gap-2">
    <.button phx-click="confirm">Confirm</.button>
    <.button variant="outline" phx-click="cancel">Cancel</.button>
  </div>
</.modal>
```

## Configuration

Configure FlowbitePhoenix in your `config.exs`:

```elixir
config :flowbite_phoenix,
  # Optional: Set your Gettext backend for translations
  gettext_backend: MyAppWeb.Gettext,
  
  # Optional: Customize theme colors and styling
  theme: %{
    primary_color: "blue",
    secondary_color: "gray",
    success_color: "green",
    warning_color: "yellow", 
    error_color: "red"
  },
  
  # Optional: Customize component defaults
  button: %{
    base_classes: "custom-button-classes",
    sizes: %{
      sm: "px-2 py-1 text-sm",
      default: "px-4 py-2 text-base"
    }
  }
```

## Internationalization

FlowbitePhoenix supports internationalization through Gettext with automatic fallbacks:

```elixir
# In your config.exs
config :flowbite_phoenix,
  gettext_backend: MyAppWeb.Gettext
```

The library provides English fallbacks for all UI text, so Gettext is completely optional.

## Troubleshooting

### Interactive Components Not Working

If dropdowns, modals, or other interactive components stop working after LiveView navigation:

1. **Check JavaScript Version**: Ensure you're using `flowbite.phoenix.js` not `flowbite.js`
2. **Verify Script Loading**: Check browser DevTools to confirm the script is loading
3. **Clear Browser Cache**: Sometimes cached versions of the old script can cause issues

### Components Not Styled Correctly

1. **Verify CSS**: Ensure Flowbite CSS is properly loaded in your `root.html.heex`
2. **Check Tailwind Config**: Make sure Flowbite is included in your Tailwind config
3. **Purge Issues**: Ensure your Tailwind purge settings include Flowbite classes

## Theming and Customization

### CSS Custom Properties

You can override Flowbite's CSS custom properties to match your brand:

```css
:root {
  --color-primary-50: /* your colors */;
  --color-primary-500: /* your colors */;
  /* etc... */
}
```

### Component Configuration

Override default component styling through configuration:

```elixir
config :flowbite_phoenix,
  button: %{
    base_classes: "your-custom-classes",
    sizes: %{
      default: "your-default-size-classes"
    }
  }
```

## Development

To set up the development environment:

```bash
git clone https://github.com/flowbite/flowbite_phoenix.git
cd flowbite_phoenix
mix deps.get
mix test
```

### Running Tests

```bash
mix test
```

### Generating Documentation

```bash
mix docs
```

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Flowbite](https://flowbite.com) - For the beautiful CSS framework
- [Phoenix Framework](https://phoenixframework.org/) - For the amazing web framework
- [Tailwind CSS](https://tailwindcss.com/) - For the utility-first CSS framework
- [Heroicons](https://heroicons.com/) - For the beautiful icons

## Links

- [Documentation](https://hexdocs.pm/flowbite_phoenix)
- [Hex Package](https://hex.pm/packages/flowbite_phoenix)
- [GitHub Repository](https://github.com/flowbite/flowbite_phoenix)
- [Flowbite Documentation](https://flowbite.com/docs/)
- [Phoenix Components Guide](https://hexdocs.pm/phoenix/components.html)

