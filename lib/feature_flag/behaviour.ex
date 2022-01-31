defmodule FeatureFlag.Behaviour do
  @doc """
  Start a client instance.
  """
  @callback start_client(String.t()) :: :ok

  @doc """
  Stop a client instance.
  """
  @callback stop_client() :: :ok

  @doc """
  Evaluate a flag name for given user.
  """
  @callback check(String.t(), FeatureFlag.User.t(), boolean()) :: FeatureFlag.check_t()
end
