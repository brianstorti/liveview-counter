defmodule CounterWeb.Counter do
  use Phoenix.LiveView

  @topic "live"

  def render(assigns) do
    ~L"""
    <div>
      <h1>The count is: <%= @val %></h1>
      <button phx-click="dec">-</button>
      <button phx-click="inc">+</button>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    CounterWeb.Endpoint.subscribe(@topic)
    {:ok, assign(socket, :val, 0)}
  end

  def handle_event(action = "inc", _, socket) do
    {:noreply,
      socket
      |> update(:val, &(&1 + 1))
      |> broadcast(action)
    }
  end

  def handle_event(action = "dec", _, socket) do
    {:noreply,
      socket
      |> update(:val, &(&1 - 1))
      |> broadcast(action)
    }
  end

  def handle_info(msg, socket) do
    {:noreply, assign(socket, val: msg.payload.val)}
  end

  defp broadcast(socket, action) do
    CounterWeb.Endpoint.broadcast_from(self(), @topic, action, socket.assigns)
    socket
  end
end
