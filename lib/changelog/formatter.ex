defmodule Changelog.Formatter do
  @moduledoc """
  A simple formatter for changelogs.
  """

  @doc "It removes changes older than the given version"
  def format(changelog, version) do
    changelog
    |> String.replace(~r/# Changelog(\n+)?/si, "")
    |> String.replace(~r/##? +v?\[?#{version}\]?.*/s, "")
  end
end
