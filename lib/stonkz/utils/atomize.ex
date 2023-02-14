defmodule Stonkz.Utils.Atomize do
  def to_atom(string) when is_binary(string) do
    String.to_existing_atom(string)
  rescue
    _ -> String.to_atom(string)
  end

  def to_atom(value), do: value
end
