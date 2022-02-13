defmodule Mix.Tasks.Changelog do
  use Mix.Task

  @shortdoc "Fetch changelogs (use `--help` for options)"
  @moduledoc @shortdoc

  def run(argv) do
    Changelog.CLI.main(argv)
  end
end
