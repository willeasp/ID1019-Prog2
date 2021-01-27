defmodule Src do
  @moduledoc """
  Documentation for Src.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Src.hello()
      :world

  """
  def hello do
    IO.inspect(Test.reverse([1,2,3]))
    :world
  end
end

Src.hello()
