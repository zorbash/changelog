defmodule Changelog.HexHTTPAdapter do
  @moduledoc """
  An HTTP adapter for Hex to avoid using the default one based on httpc
  @see https://github.com/hexpm/hex_core#configuration
  """

  @doc false
  def request(method, uri, req_headers, _body, _adapter_config) do
    resp =
      Req.build(method, uri, headers: req_headers)
      |> Req.run!()

    {:ok, {resp.status, Map.new(resp.headers), resp.body}}
  end
end
