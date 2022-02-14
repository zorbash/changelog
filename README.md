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

## Example

```
mix changelog tailwind

Package: tailwind
Current version: 0.1.4
Latest version:  0.1.5
Hexdiff: https://diff.hex.pm/diff/tailwind/0.1.4..0.1.5

# CHANGELOG

## v0.1.5 (2022-01-18)
  * Prune app.js css import to remove required manual step on first install

```

## License

Copyright (c) 2022 Dimitris Zorbas, MIT License.
See [LICENSE.txt](https://github.com/zorbash/changelog/blob/master/LICENSE.txt) for further details.
