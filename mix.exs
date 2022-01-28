defmodule FeatureFlag.MixProject do
  use Mix.Project

  def project do
    [
      app: :feature_flag,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ldclient, "~> 1.3", hex: :launchdarkly_server_sdk}
    ]
  end
end
