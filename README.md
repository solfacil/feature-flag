# FeatureFlag

FeatureFlag is project to abstract the communication with [Launch Darkly SDK](https://github.com/launchdarkly/erlang-server-sdk).

## Installation

Add git repository `feature_flag` in your `mix.exs`:

```elixir
defp deps do
  [
    ...,
    # To use newest version
    {:feature_flag, git: "https://github.com/solfacil/feature-flag.git", branch: "main"}
    # To use a specific git tag version
    {:feature_flag, git: "https://github.com/solfacil/feature-flag.git", tag: "x.x.x"}
  ]
end
```

For details about git repository in `deps`, read [Git options](https://hexdocs.pm/mix/1.12/Mix.Tasks.Deps.html#module-git-options-git).

## Usage

A client instance must be started for feature flag evaluation to work. We recommend use `FeatureFlag.Server` to start a client instance on application startup and then feel free to use `FeatureFlag.check/3` function to get feature flag value.

**Below is a suggestion how to use the lib**

Use `config/<env>.exs` to set the Launch Darkly secret key.

```elixir
config :my_app, :feature_flag, secret_key: "ld-secret-key"
```

Add `FeatureFlag.Server` to your `MyApp.Application` to start a client instance.

```elixir
defmodule MyApp.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {FeatureFlag.Server, [secret_key: secret_key()]}
    ]

    opts = [strategy: :one_for_one, name: MyApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp secret_key, do: Application.get_env(:my_app, :feature_flag)[:secret_key]
end
```
> If no `:secret_key` option are given, an error will be thrown.

Now you are ready to go. Use `FeatureFlag.check/3` to evaluate given flag value for given user.

```elixir
iex> user = %FeatureFlag.User{key: "123abc", name: "John", email: "john@example.com"}
iex> FeatureFlag.check("admin-report", user)
true
```
