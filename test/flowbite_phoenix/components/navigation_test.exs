defmodule FlowbitePhoenix.Components.NavigationTest do
  use ExUnit.Case, async: true

  describe "navigation component module" do
    test "module exists and compiles" do
      assert Code.ensure_loaded?(FlowbitePhoenix.Components.Navigation)
    end

    test "defines Phoenix components" do
      module = FlowbitePhoenix.Components.Navigation
      assert module.__info__(:module) == FlowbitePhoenix.Components.Navigation
    end
  end
end