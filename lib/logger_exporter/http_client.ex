defmodule LoggerExporter.HTTPClient do
  alias LoggerExporter.{Config, Event}

  @spec batch([Event.t()]) :: :ok | :error

  def batch(events) do
    # TODO: Add telemetry
    exporter = Config.exporter()

    headers =
      exporter.headers()
      |> merge_default_headers()

    body = exporter.body(events)

    Finch.build(:post, Config.host(), headers, body)
    |> Finch.request(FinchHTTPClient)
    |> IO.inspect(label: "response")
  end

  defp merge_default_headers(headers) do
    [
      {"Content-Type", "application/json"}
    ] ++ headers
  end
end
