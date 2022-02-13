defmodule Changelog.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    Application.ensure_all_started(:req)

    opts = [strategy: :one_for_one, name: Changelog.Supervisor]

    Supervisor.start_link([], opts)
  end
end
