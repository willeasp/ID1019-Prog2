defmodule Raytracer do
    use Mix.Task
  @moduledoc """
  Documentation for Raytracer.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Raytracer.hello()
      :world

  """
    def run(_) do
        IO.puts("HELLO WORLD")
        Snap.snap(0)
    end
end
