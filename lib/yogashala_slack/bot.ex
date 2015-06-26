defmodule YogashalaSlack.Bot do
  use Slack

  def start_link(initial_state) do
    Slack.start_link(__MODULE__, System.get_env("SLACK_BOT_API_TOKEN"), initial_state)
    Agent.start_link(fn -> %{restraunts: ["Ekim"]} end, name: __MODULE__)
  end

  def init(initial_state, slack) do
    {:ok, initial_state}
  end

  def handle_message({:type, "hello", response}, slack, state) do
    {:ok, state}
  end

  def handle_message({:type, "message", response}, slack, state) do

    case response.text do
      "yogabot: lunchme add " <> restraunt ->
        Agent.update __MODULE__, &(put_in(&1.restraunts, [ restraunt | &1.restraunts ]))
        Slack.send_message("Added restraunt #{restraunt}. Count is now #{Enum.count(restraunts)}", response.channel, slack)
      "yogabot: " <> command -> Slack.send_message(do_command(command, state), response.channel, slack)
      _ -> true
    end

    {:ok, state}
  end

  def handle_message({:type, type, _response}, _slack, state) do
    {:ok, state}
  end

  ## Private
  defp pick_random(list) do
    :random.seed(:erlang.monotonic_time, :erlang.unique_integer, :erlang.monotonic_time)
    Enum.at(list, :random.uniform(length(list)) - 1)
  end

  defp restraunts do
    Agent.get __MODULE__, &(&1.restraunts)
  end

  defp do_command("lunchme", state) do
    pick_random restraunts
  end

  defp do_command(command, _state) do
    "Unsupported command `#{command}`"
  end
end
