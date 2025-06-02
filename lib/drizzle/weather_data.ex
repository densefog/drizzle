defmodule Drizzle.WeatherData do
  @moduledoc """
  Updated by Weather module. Contains stored array of recent weather data.
  """
  use GenServer

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_state) do
    # low, high, precipitation
    state = {50, 50, 0}

    {:ok, state}
  end

  def update(low, high, precipitation) do
    GenServer.call(__MODULE__, {:update, {low, high, precipitation}})
  end

  def reset() do
    GenServer.call(__MODULE__, :reset)
  end

  def current_state() do
    GenServer.call(__MODULE__, :current_state)
  end

  def handle_call({:update, new_weather}, _from, _state) do
    {:reply, :ok, new_weather}
  end

  def handle_call(:reset, _from, _state) do
    state = {50, 50, 0}
    {:reply, :ok, state}
  end

  def handle_call(:current_state, _from, state) do
    {:reply, state, state}
  end
end
