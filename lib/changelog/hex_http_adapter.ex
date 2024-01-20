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

    # 0.1.3 - 2024-01-15: updating parsing of returned headers to match the expected format
    # by the :hex_core src/hex_api.erl module for :hex_api.request/4
    # The expected format of the headers is a Map with %{k::binary(), v::binary()}
    # The above run_request() was returning a header map of the format:
    # %{k::binary(), v::list[binary()]}
    resp_headers =
      resp.headers
      |> Map.new()
      |> Enum.reduce(%{}, fn {k, v}, acc -> Map.put(acc, k, :erlang.list_to_binary(v)) end)

    {:ok, {resp.status, resp_headers, resp.body}}
  end
end
