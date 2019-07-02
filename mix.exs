defmodule ExEnv.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_env,
      version: "VERSION" |> File.read!() |> String.trim(),
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      # excoveralls
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.travis": :test,
        "coveralls.circle": :test,
        "coveralls.semaphore": :test,
        "coveralls.post": :test,
        "coveralls.detail": :test,
        "coveralls.html": :test
      ],
      # dialyxir
      dialyzer: [
        ignore_warnings: ".dialyzer_ignore",
        plt_add_apps: [
          :mix
        ]
      ],
      # ex_doc
      name: "ExEnv",
      source_url: "https://github.com/coingaming/ex_env",
      homepage_url: "https://github.com/coingaming/ex_env",
      docs: [main: "readme", extras: ["README.md"]],
      # hex.pm stuff
      description: "Tool provides support of Elixir terms in system env variables",
      package: [
        licenses: ["Apache 2.0"],
        files: ["lib", "priv", "mix.exs", "README*", "VERSION*"],
        maintainers: ["tim2CF"],
        links: %{
          "GitHub" => "https://github.com/coingaming/ex_env"
        }
      ]
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
      # development tools
      {:excoveralls, "~> 0.8", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.5", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.19", only: [:dev, :test], runtime: false},
      {:credo, "~> 0.9", only: [:dev, :test], runtime: false},
      {:boilex, "~> 0.2.7", only: [:dev, :test], runtime: false}
    ]
  end
end
