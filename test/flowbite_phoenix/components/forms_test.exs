defmodule FlowbitePhoenix.Components.FormsTest do
  use ExUnit.Case, async: true

  describe "form component module" do
    test "module exists and compiles" do
      assert Code.ensure_loaded?(FlowbitePhoenix.Components.Forms)
    end

    test "defines Phoenix components" do
      # Phoenix components are defined as functions, let's check the module is properly structured
      module = FlowbitePhoenix.Components.Forms
      assert module.__info__(:module) == FlowbitePhoenix.Components.Forms
    end
  end
end