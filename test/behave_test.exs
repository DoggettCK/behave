defmodule BehaveTest do
  use ExUnit.Case
  doctest Behave

  describe "behaviour_implemented?/2" do
    test "fails when implementation_module is not a module" do
      assert {:error, :not_a_module, "not a module"} =
               Behave.behaviour_implemented?("not a module", BehaviourModule)
    end

    test "fails when behaviour_module is not a module" do
      assert {:error, :not_a_module, "not a module"} =
               Behave.behaviour_implemented?(ImplementationModule, "not a module")
    end

    test "fails when implementation_module doesn't implement behaviour_module's behaviour" do
      assert {:error, :behaviour_not_implemented} =
               Behave.behaviour_implemented?(NoImplementationModule, BehaviourModule)
    end

    test "verifies that implementation_module implements behaviour_module's behaviour" do
      assert :ok = Behave.behaviour_implemented?(ImplementationModule, BehaviourModule)
    end
  end
end

defmodule BehaviourModule do
  @callback register() :: {name :: term, configuration :: map()}
end

defmodule ImplementationModule do
  @behaviour BehaviourModule

  def register do
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
