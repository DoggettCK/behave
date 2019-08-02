defmodule Behave.MixProject do
  use Mix.Project

  def project do
    [
      app: :behave,
      version: "0.1.0",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      name: "Behave",
      source_url: "https://github.com/DoggettCK/behave",
      package: package(),
      docs: docs(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 0.10.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.20", only: :dev},
      {:mix_test_watch, "~> 0.5", only: :dev, runtime: false}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp description() do
    """
    `Behave` checks whether a module implements the behaviour defined in
    another module.
    """
  end

  defp package() do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE.md"],
      maintainers: ["Chris Doggett"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/DoggettCK/behave"}
    ]
  end

  defp docs() do
    [
      main: "Behave",
      source_url: "https://github.com/DoggettCK/behave"
    ]
  end
end
