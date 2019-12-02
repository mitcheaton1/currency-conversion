defmodule CurrencyConversion.UpdateWorkerTest do
  use ExUnit.Case, async: true

  alias CurrencyConversion.UpdateWorker

  doctest UpdateWorker

  defmodule Source do
    @moduledoc false

    @behaviour CurrencyConversion.Source

    def load(opts) do
      case Keyword.fetch(opts, :caller_pid) do
        {:ok, pid} -> send(pid, :load)
        _ -> nil
      end

      {:ok, %CurrencyConversion.Rates{base: :CHF, rates: %{}}}
    end
  end

  test "initial load called", %{test: test_name} do
    name = Module.concat(__MODULE__, test_name)
    start_supervised!({UpdateWorker, source: Source, name: name})

    assert UpdateWorker.get_rates(name) == %CurrencyConversion.Rates{base: :CHF, rates: %{}}
  end

  test "refresh load called", %{test: test_name} do
    name = Module.concat(__MODULE__, test_name)

    start_supervised!(
      {UpdateWorker, source: Source, name: name, refresh_interval: 1_000, caller_pid: self()}
    )

    assert_received :load
    assert_receive :load, 1_100
  end
end
