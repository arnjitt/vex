defmodule VexTest do
  use ExUnit.Case
  doctest Vex

  test "greets the world" do
    assert Vex.hello() == :world
  end
end
