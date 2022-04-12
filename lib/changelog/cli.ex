defmodule Changelog.CLI do
  @moduledoc "Shared entrypoint for the task and escript"

  alias Changelog.Formatter

  def main(argv \\ []) do
    run(argv)
  end

  @doc false
  def run(["help"]) do
    IO.puts("""
    Usage: mix changelog <package>

    Run without any arguments to fetch the changelogs of all packages.
    """)
  end

  def run(argv) do
    Changelog.Application.start(nil, nil)

    lock = Mix.Dep.Lock.read()
    packages = Hex.Mix.packages_from_lock(lock)

    case argv do
      [] ->
        print(lock, fetch_changelogs(packages))

      only_packages ->
        print(
          lock,
          fetch_changelogs(Enum.filter(packages, fn {_, package} -> package in only_packages end))
        )
    end
  end

  defp print(lock, changelogs) do
    for {package_name, %{changelog: changelog, latest_version: latest_version}} <- changelogs do
      version = lock_file_version(lock, package_name)

      if version != latest_version do
        IO.puts("""
        Package: #{package_name}
        Current version: #{version}
        Latest version:  #{latest_version}
        Hexdiff: https://diff.hex.pm/diff/#{package_name}/#{version}..#{latest_version}

        #{Formatter.format(changelog, version)}
        --------------------------
        """)
      end
    end
  end

  defp lock_file_version(lock, package_name) do
    lookup_name = String.to_atom(package_name)

    package_info =
      cond do
        package_info = lock[lookup_name] ->
          package_info

        package_info = find_package_info_by_app_name(lock, lookup_name) ->
          package_info

        true ->
          Mix.raise("Unable to find #{package_name}'s version in the mix.lock file")
      end

    elem(package_info, 2)
  end

  defp find_package_info_by_app_name(lock, app_name) do
    Enum.find_value(lock, fn {_key, package} ->
      if elem(package, 1) == app_name, do: package
    end)
  end

  defp fetch_changelogs(packages) do
    hex_config =
      put_in(:hex_core.default_config(), [:http_adapter], {Changelog.HexHTTPAdapter, []})

    for {_, package} <- packages, into: %{} do
      case :hex_api_package.get(hex_config, package) do
        {:ok,
         {_status, _headers, %{"latest_version" => latest_version, "meta" => %{"links" => links}}}} ->
          {package, %{latest_version: latest_version, changelog: fetch_changelog(links)}}

        _ ->
          {package, %{}}
      end
    end
  end

  defp fetch_changelog(links) do
    {_, github_url} = Enum.find(links, fn {k, _} -> k =~ ~r/github/i end)

    do_fetch_changelog(github_url, :master) ||
      do_fetch_changelog(github_url, :main) ||
      "Changelog not found"
  end

  defp do_fetch_changelog("https://github.com/" <> repo, branch) do
    case Req.get!("https://raw.githubusercontent.com/#{repo}/#{branch}/CHANGELOG.md") do
      %{status: 200, body: body} -> body
      _ -> nil
    end
  end

  defp do_fetch_changelog(_, _), do: nil
end
