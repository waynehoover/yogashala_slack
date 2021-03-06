defmodule YogashalaSlack.Mixfile do
  use Mix.Project

  def project do
    [app: :yogashala_slack,
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :slack, :dotenv],
     mod: {YogashalaSlack, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:slack, "~> 0.0.5", git: "git://github.com/waynehoover/Elixir-Slack.git"},
      {:dotenv, "~> 1.0.0"},
      {:websocket_client, git: "git://github.com/jeremyong/websocket_client.git"}
    ]
  end
end
