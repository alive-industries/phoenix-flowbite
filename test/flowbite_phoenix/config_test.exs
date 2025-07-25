defmodule FlowbitePhoenix.ConfigTest do
  use ExUnit.Case, async: true
  alias FlowbitePhoenix.Config

  describe "get_config/0" do
    test "returns default configuration" do
      config = Config.get_config()
      
      assert config.theme.primary_color == "blue"
      assert config.button.base_classes =~ "focus:ring-4"
      assert config.input.base_classes =~ "bg-gray-50"
    end

    test "merges with application config" do
      # This would require setting up application config in test
      # For now, we test the structure
      config = Config.get_config()
      
      assert is_map(config.theme)
      assert is_map(config.button)
      assert is_map(config.input)
    end
  end

  describe "get/1" do
    test "gets configuration by path" do
      primary_color = Config.get([:theme, :primary_color])
      assert primary_color == "blue"
      
      button_config = Config.get(:button)
      assert is_map(button_config)
      assert Map.has_key?(button_config, :base_classes)
    end

    test "returns nil for invalid paths" do
      result = Config.get([:nonexistent, :path])
      assert is_nil(result)
    end
  end

  describe "helper functions" do
    test "primary_color/0 returns primary color" do
      assert Config.primary_color() == "blue"
    end

    test "button_config/0 returns button configuration" do
      config = Config.button_config()
      assert is_map(config)
      assert Map.has_key?(config, :base_classes)
      assert Map.has_key?(config, :sizes)
    end

    test "input_config/0 returns input configuration" do
      config = Config.input_config()
      assert is_map(config)
      assert Map.has_key?(config, :base_classes)
    end

    test "component_config/1 returns component-specific config" do
      button_config = Config.component_config(:button)
      assert is_map(button_config)
      
      nonexistent_config = Config.component_config(:nonexistent)
      assert nonexistent_config == %{}
    end
  end

  describe "validate_config/0" do
    test "validates default configuration" do
      assert Config.validate_config() == :ok
    end
  end

  describe "available options" do
    test "available_colors/0 returns valid colors" do
      colors = Config.available_colors()
      assert is_list(colors)
      assert "blue" in colors
      assert "red" in colors
      assert "green" in colors
    end

    test "available_sizes/0 returns valid sizes" do
      sizes = Config.available_sizes()
      assert is_list(sizes)
      assert "xs" in sizes
      assert "sm" in sizes
      assert "default" in sizes
      assert "lg" in sizes
      assert "xl" in sizes
    end
  end
end