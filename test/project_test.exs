defmodule ProjectTest do
  alias Task.Supervised
  use ExUnit.Case
  doctest Project

  test "test setting data" do
    p = Project.init()

    Setting.set_data("test", 16)
    assert Setting.get_data("test") == 16
    Supervisor.stop(p)
  end
end
