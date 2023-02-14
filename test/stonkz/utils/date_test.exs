defmodule Stonkz.Utils.DateTest do
  use ExUnit.Case

  alias Stonkz.Utils.Date

  describe "parse/1 function tests" do
    test "converts unix timestamp into a readable format" do
      assert Date.parse(1_676_246_400_000) == "02-13-2023"
    end

    test "returns value when not an integer" do
      assert Date.parse("123") == "123"
    end
  end
end
