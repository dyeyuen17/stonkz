defmodule StonkzTest do
  use ExUnit.Case
  doctest Stonkz

  test "greets the world" do
    assert Stonkz.hello() == :world
  end
end
