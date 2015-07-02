defmodule YogashalaSlack.Bot do
  use Slack

  def start_link(initial_state) do
    Slack.start_link(__MODULE__, System.get_env("SLACK_BOT_API_TOKEN"), initial_state)
  end

  def init(initial_state, slack) do
    {:ok, initial_state ++ %{restraunts: HashSet.new} }
  end

  def handle_message({:type, "message", %{channel: channel, text: "yogabot: " <> command}}, slack, state) do

    case command do
      "lunchme" -> state.restraunts |> pick_random |> Slack.send_message(channel, slack)
      "lunchme list" -> 
        Slack.send_message("#{inspect state.restraunts}", channel, slack)
      "lunchme add " <> restraunt -> 
        state = put_in state.restraunts, Set.put(state.restraunts, restraunt)
        Slack.send_message("Added restraunt #{restraunt}. Count is now #{Enum.count(state.restraunts)}", channel, slack)
      "lunchme remove " <> restraunt -> 
        state = put_in state.restraunts, Set.delete(state.restraunts, restraunt)
        Slack.send_message("Removed restraunt #{restraunt}. Count is now #{Enum.count(state.restraunts)}", channel, slack)        
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
end
