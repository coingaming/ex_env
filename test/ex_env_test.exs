defmodule ExEnvTest do
  use ExUnit.Case
  doctest ExEnv

  test "greets the world" do
    assert ExEnv.hello() == :world
  end
end
