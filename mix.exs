defmodule CurrencyConversion.Mixfile do
  @moduledoc false

  use Mix.Project

  @version "1.0.0"

  def project do
    [
      app: :currency_conversion,
      docs: docs(),
      version: @version,
      elixir: "~> 1.7",
      description: description(),
      package: package(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.travis": :test
      ],
      dialyzer: [
        plt_add_apps: [:httpotion, :jason]
      ]
    ]
  end

  defp description do
    """
    Convert Money Amounts between currencies.
    """
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:money, "~> 1.2"},
      {:httpotion, "~> 3.1", optional: true},
      {:jason, "~> 1.1", optional: true},
      {:mock, "~> 0.2", only: [:test]},
      {:ex_doc, ">= 0.0.0", only: [:dev], runtime: false},
      {:excoveralls, "~> 0.4", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:credo, "~> 1.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp package do
    [
      name: :currency_conversion,
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Jonatan Männchen"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/jshmrtn/currency-conversion"}
    ]
  end

  def docs do
    [source_ref: "v#{@version}", source_url: "https://github.com/jshmrtn/currency-conversion"]
  end
end
