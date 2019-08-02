defmodule Behave do
  @moduledoc """
  `Behave` allows you to check whether one Elixir module implements a
  given
  [Behaviour](https://elixir-lang.org/getting-started/typespecs-and-behaviours.html).
  """

  @doc """
  Determines whether a given `implementation_module` is both a module and
  implements the behaviour required by `behaviour_module`.

  Unfortunately, Elixir doesn't have an `is_module` guard, and you have to use
  `is_atom`, as Modules are considered atoms.

  ```
  iex> is_atom(SomeModule)
  true
  ```

  Elixir will show you at compile-time (via a warning) if you haven't
  implemented a required function in a Behaviour. However, there is no way to
  determine whether or not a given Module implements another Module's
  Behaviour.

  ## Return values
  | **Value** | **Meaning** |
  | :ok | `module` meets the criteria for the `behaviour_module` |
  | {:error, :not_a_module, module} | `module` is not actually a Module |
  | {:error, :behaviour_not_implemented} | `module` does not implement `behaviour_module` |
  """
  @spec behaviour_implemented?(implementation_module :: module, behaviour_module :: module) ::
          :ok | {:error, :not_a_module, value :: term} | {:error, :behaviour_not_implemented}
  def behaviour_implemented?(implementation_module, behaviour_module) do
    cond do
      not is_module?(implementation_module) ->
        {:error, :not_a_module, implementation_module}

      not is_module?(behaviour_module) ->
        {:error, :not_a_module, behaviour_module}

      true ->
        implements_behaviour?(implementation_module, behaviour_module)
    end
  end

  defp is_module?(module) when is_atom(module) do
    case Code.ensure_loaded(module) do
      {:module, ^module} ->
        true

      _ ->
        false
    end
  end

  defp is_module?(_), do: false

  defp implements_behaviour?(implementation_module, behaviour_module) do
    implements_behaviour =
      :attributes
      |> implementation_module.module_info()
      |> Keyword.get(:behaviour, [])
      |> Enum.member?(behaviour_module)

    if implements_behaviour do
      :ok
    else
      {:error, :behaviour_not_implemented}
    end
  end
end
