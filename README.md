# Changelog

A mix task to fetch changelogs of updatable packages.

## Installation

Add `:changelog` as a dependency to your project's `mix.exs`:

```elixir
defp deps do
  [
    {:changelog, "~> 0.1", only: [:dev, :test], runtime: false}
  ]
end
```

Then you can run it with:

```bash
mix deps.get

# Will retrieve the changelogs of all the packages in mix.lock
mix changelog
```

To run it only for some packages:

```bash
# Will only fetch the changelogs of jason and phoenix packages
mix changelog jason phoenix
```

## License

Copyright (c) 2022 Dimitris Zorbas, MIT License.
See [LICENSE.txt](https://github.com/zorbash/changelog/blob/master/LICENSE.txt) for further details.
