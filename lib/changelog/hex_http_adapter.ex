defmodule Changelog.HexHTTPAdapter do
  @moduledoc """
  An HTTP adapter for Hex to avoid using the default one based on httpc
  @see https://github.com/hexpm/hex_core#configuration
  """

  alias Req.Request

  @doc false
  def request(method, url, req_headers, _body, _adapter_config) do
    {_req, resp} =
      Request.new(method: method, url: url, headers: Map.to_list(req_headers))
      |> Request.run_request()

    {:ok, {resp.status, Map.new(resp.headers), resp.body}}
  end
end
