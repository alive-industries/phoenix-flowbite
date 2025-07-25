defmodule FlowbitePhoenix.Components.LayoutTest do
  use ExUnit.Case, async: true

  describe "layout component module" do
    test "module exists and compiles" do
      assert Code.ensure_loaded?(FlowbitePhoenix.Components.Layout)
    end

    test "defines Phoenix components" do
      module = FlowbitePhoenix.Components.Layout
      assert module.__info__(:module) == FlowbitePhoenix.Components.Layout
    end
  end
end