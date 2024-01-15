defmodule Changelog.MixProject do
  use Mix.Project

  def project do
    [
      app: :changelog,
      version: "0.1.3",
      elixir: "~> 1.12",
      escript: [main_module: Changelog.CLI],
      start_permanent: Mix.env() == :prod,
      build_embedded: Mix.env() == :prod,
      description:
        "A task to make package updates easier by retrieving relevant changelog entries",
      source_url: "https://github.com/zorbash/changelog",
      deps: deps(),
      package: package(),
      docs: [
        extras: ["CHANGELOG.md", "README.md"],
        main: "readme",
        source_url: "https://github.com/zorbash/changelog"
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Changelog.Application, []},
      extra_applications: [:logger, :inets, :hex, :req]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:hex_core, "~> 0.10.0"},
      {:req, "~> 0.4.0"},
      {:ex_doc, "~> 0.25", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE.txt", ".formatter.exs"],
      maintainers: ["Dimitris Zorbas"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/zorbash/changelog",
        "Changelog" => "https://github.com/zorbash/changelog/blob/master/CHANGELOG.md"
      }
    ]
  end
end
