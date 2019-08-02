# Behave

[![Hex Version][hex-img]][hex] [![Hex Downloads][downloads-img]][downloads] [![License][license-img]][license]

[hex-img]: https://img.shields.io/hexpm/v/behave.svg
[hex]: https://hex.pm/packages/behave
[downloads-img]: https://img.shields.io/hexpm/dt/behave.svg
[downloads]: https://hex.pm/packages/behave
[license-img]: https://img.shields.io/badge/license-MIT-blue.svg
[license]: https://opensource.org/licenses/MIT

## Description

`Behave` allows you to check whether one Elixir Module implements a given
[Behaviour](https://elixir-lang.org/getting-started/typespecs-and-behaviours.html).

Elixir will show you at compile-time (via a warning) if you haven't implemented
a required function in a Behaviour. However, there is no way to determine
whether or not a given Module implements another Module's Behaviour.

I needed this so I could pass a list of Modules to a function and safely call a
function on them, or log a warning if that function didn't exist.

## Examples

```elixir
defmodule BehaviourModule do
  @doc """
  Get registration information for a module.

  Should return 2-tuple containing name and configuration map.
  """
  @callback registration() :: {name :: term, configuration :: map()}
end

defmodule ImplementationModule do
  @behaviour BehaviourModule

  def registration do
    config = %{
      version: "4.2.0",
      log_level: :warn
    }

    {"module_name", config}
  end
end

defmodule NoImplementationModule do
  def install do
    # Doesn't matter
  end
end

defmodule Server do
  use GenServer

  require Behave
  require Logger

  def start_link(modules_to_register) do
    GenServer.start_link(__MODULE__, modules_to_register, name: __MODULE__)
  end

  def init(modules_to_register) do
    state = Enum.reduce(modules_to_register, %{}, &register_or_warn/2)

    {:ok, state}
  end

  defp register_or_warn(module, state) do
    case Behave.behaviour_implemented?(module, BehaviourModule) do
      {:error, :not_a_module, ^module} ->
        Logger.warn("Could not register (#{module}) because it is not a Module")

        state

      {:error, :behaviour_not_implemented} ->
        Logger.warn("Could not register (#{module}) because it doesn't implement #{BehaviourModule}")

        state

      :ok ->
        {name, config} = module.registration()

        Map.put(state, name, config)
    end
  end
end
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `behave` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:behave, "~> 0.1.0"}
  ]
end
```

## Documentation

Documentation can be found at [https://hexdocs.pm/behave](https://hexdocs.pm/behave).
