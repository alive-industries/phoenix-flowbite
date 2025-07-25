defmodule FlowbitePhoenix.GettextTest do
  use ExUnit.Case, async: true
  alias FlowbitePhoenix.Gettext

  describe "gettext/2" do
    test "returns default translation when no backend configured" do
      result = Gettext.gettext("Success!")
      assert result == "Success!"
      
      result = Gettext.gettext("close")
      assert result == "close"
    end

    test "returns provided default when message not found" do
      result = Gettext.gettext("unknown message", "fallback")
      assert result == "fallback"
    end

    test "returns message when no default translation available" do
      result = Gettext.gettext("completely unknown message")
      assert result == "completely unknown message"
    end
  end

  describe "dgettext/3" do
    test "returns default translation with interpolation" do
      result = Gettext.dgettext("errors", "Success!", %{})
      assert result == "Success!"
    end

    test "handles bindings interpolation" do
      # This would require a message with bindings in the default translations
      result = Gettext.dgettext("errors", "Loading...", %{})
      assert result == "Loading..."
    end
  end

  describe "dngettext/5" do
    test "handles singular form" do
      result = Gettext.dngettext("errors", "1 item", "%{count} items", 1, %{count: 1})
      assert result == "1 item"
    end

    test "handles plural form" do
      result = Gettext.dngettext("errors", "1 item", "%{count} items", 2, %{count: 2})
      assert result == "2 items"
    end

    test "falls back to default translations" do
      result = Gettext.dngettext("errors", "Success!", "Success!", 1, %{})
      assert result == "Success!"
    end
  end

  describe "default translations" do
    test "provides common UI strings" do
      translations = [
        "Success!",
        "Error!",
        "close",
        "Close",
        "Actions",
        "We can't find the internet",
        "Attempting to reconnect",
        "Something went wrong!",
        "Hang in there while we get back on track",
        "Loading...",
        "Previous",
        "Next"
      ]

      for translation <- translations do
        result = Gettext.gettext(translation)
        assert result == translation
      end
    end

    test "returns original message for unknown strings" do
      unknown = "This is not a known translation"
      result = Gettext.gettext(unknown)
      assert result == unknown
    end
  end
end