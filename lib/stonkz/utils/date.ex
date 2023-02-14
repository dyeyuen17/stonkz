defmodule Stonkz.Utils.Date do
  def parse(timestamp) when is_integer(timestamp) do
    {:ok, datetime} = DateTime.from_unix(timestamp, :millisecond)
    
    month = String.pad_leading("#{datetime.month}", 2, "0")
    day = String.pad_leading("#{datetime.day}", 2, "0")

    "#{month}-#{day}-#{datetime.year}"
  end
end
