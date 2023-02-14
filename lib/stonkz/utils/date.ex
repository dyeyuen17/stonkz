defmodule Stonkz.Utils.Date do
  def parse(timestamp) when is_integer(timestamp) do
    {:ok, datetime} = DateTime.from_unix(timestamp, :millisecond)
    day = String.pad_leading("#{datetime.day}", 2, "0")

    "#{datetime.month}-#{day}-#{datetime.year}"
  end
end
