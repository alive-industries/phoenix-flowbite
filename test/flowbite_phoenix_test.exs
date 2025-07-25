defmodule FlowbitePhoenixTest do
  use ExUnit.Case
  doctest FlowbitePhoenix

  describe "version/0" do
    test "returns version from mix.exs" do
      version = FlowbitePhoenix.version()
      assert is_binary(version)
      assert version =~ ~r/\d+\.\d+\.\d+/
    end
  end

  describe "translate_error/1" do
    test "translates error tuples" do
      error = {"is required", []}
      result = FlowbitePhoenix.translate_error(error)
      assert is_binary(result)
    end

    test "translates errors with count" do
      error = {"should be at least %{count} character(s)", [count: 3]}
      result = FlowbitePhoenix.translate_error(error)
      assert is_binary(result)
    end

    test "passes through string errors" do
      error = "simple error message"
      result = FlowbitePhoenix.translate_error(error)
      assert result == error
    end
  end

  describe "gettext/2" do
    test "delegates to FlowbitePhoenix.Gettext" do
      result = FlowbitePhoenix.gettext("Success!")
      assert result == "Success!"
    end

    test "uses default when provided" do
      result = FlowbitePhoenix.gettext("unknown", "default")
      assert result == "default"
    end
  end

  describe "translate_errors/2" do
    test "translates field errors from keyword list" do
      errors = [email: {"is required", []}, name: {"is too short", [count: 3]}]
      result = FlowbitePhoenix.translate_errors(errors, :email)
      
      assert is_list(result)
      assert length(result) == 1
    end

    test "returns empty list for field with no errors" do
      errors = [name: {"is required", []}]
      result = FlowbitePhoenix.translate_errors(errors, :email)
      
      assert result == []
    end

    test "handles multiple errors for same field" do
      errors = [
        email: {"is required", []}, 
        email: {"is not valid", []}
      ]
      result = FlowbitePhoenix.translate_errors(errors, :email)
      
      assert is_list(result)
      assert length(result) == 2
    end
  end
end
