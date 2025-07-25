# Contributing to FlowbitePhoenix

Thank you for your interest in contributing to FlowbitePhoenix! We welcome contributions from everyone.

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/your-username/flowbite_phoenix.git`
3. Install dependencies: `mix deps.get`
4. Run tests: `mix test`

## Development Process

### Making Changes

1. Create a new branch: `git checkout -b feature/your-feature-name`
2. Make your changes
3. Add or update tests as needed
4. Ensure all tests pass: `mix test`
5. Update documentation if needed
6. Commit your changes with a clear message

### Code Style

- Follow Elixir conventions and formatting
- Run `mix format` before committing
- Add documentation for public functions
- Keep component APIs consistent with existing patterns

### Testing

- Write tests for new components and functionality
- Ensure all existing tests continue to pass
- Test components in both light and dark modes when applicable

### Documentation

- Update README.md if adding new features
- Add examples to component documentation
- Update CHANGELOG.md for notable changes

## Component Guidelines

### Naming Conventions

- Use clear, descriptive names for components
- Follow Flowbite component naming when possible
- Use consistent parameter names across similar components

### Styling

- Use Flowbite classes whenever possible
- Support dark mode variants
- Make styling configurable through the config system
- Follow responsive design principles

### Attributes

- Document all component attributes with examples
- Use Phoenix.Component attribute validation
- Provide sensible defaults
- Support common HTML attributes through `rest` globals

## Pull Request Process

1. Update documentation and tests
2. Ensure your code follows the style guidelines
3. Create a pull request with a clear title and description
4. Reference any related issues
5. Wait for review and address feedback

## Reporting Issues

When reporting issues, please include:

- FlowbitePhoenix version
- Phoenix/LiveView versions
- Clear steps to reproduce
- Expected vs actual behavior
- Screenshots if applicable

## Code of Conduct

- Be respectful and inclusive
- Focus on constructive feedback
- Help others learn and grow
- Maintain a welcoming environment

## Questions?

Feel free to open an issue for questions about contributing or join discussions in existing issues.

Thank you for contributing to FlowbitePhoenix!