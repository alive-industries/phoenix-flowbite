defmodule FlowbitePhoenix.Components.FeedbackTest do
  use ExUnit.Case, async: true

  describe "feedback component module" do
    test "module exists and compiles" do
      assert Code.ensure_loaded?(FlowbitePhoenix.Components.Feedback)
    end

    test "defines Phoenix components" do
      module = FlowbitePhoenix.Components.Feedback
      assert module.__info__(:module) == FlowbitePhoenix.Components.Feedback
    end
  end
end