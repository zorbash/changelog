defmodule Changelog.FormatterTest do
  use ExUnit.Case

  alias Changelog.Formatter

  describe "format/2" do
    @changelog """
    # Changelog

    ## 1.6.4

    - Fix for false positive in `MaxLineLength`
    - Fix a bug in `Credo.Check.Refactor.PipeChainStart`
    - Fix error message in `gen.check` command

    ## 1.6.0

    - Fix an error in changelog parsing
    """

    test "it does not remove any versions from the changelog when the version is not present" do
      assert Formatter.format(@changelog, "1.5.0") == """
             ## 1.6.4

             - Fix for false positive in `MaxLineLength`
             - Fix a bug in `Credo.Check.Refactor.PipeChainStart`
             - Fix error message in `gen.check` command

             ## 1.6.0

             - Fix an error in changelog parsing
             """
    end

    test "it alters the changelog when the version is present" do
      assert Formatter.format(@changelog, "1.6.0") == """
             ## 1.6.4

             - Fix for false positive in `MaxLineLength`
             - Fix a bug in `Credo.Check.Refactor.PipeChainStart`
             - Fix error message in `gen.check` command

             """
    end

    @changelog """
    # Changelog

    ## [1.6.4] - 2022-02-27

    - Fix for false positive in `MaxLineLength`
    - Fix a bug in `Credo.Check.Refactor.PipeChainStart`
    - Fix error message in `gen.check` command

    ## [1.6.0] - 2022-02-21

    - Fix an error in changelog parsing
    """
    test "it can detect version numbers in brackets" do
      assert Formatter.format(@changelog, "1.6.0") == """
             ## [1.6.4] - 2022-02-27

             - Fix for false positive in `MaxLineLength`
             - Fix a bug in `Credo.Check.Refactor.PipeChainStart`
             - Fix error message in `gen.check` command

             """
    end
  end
end
