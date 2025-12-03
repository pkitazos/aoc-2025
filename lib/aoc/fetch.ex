defmodule Aoc.Fetch do
  @year 2025

  def fetch_input(day) do
    session = get_session()

    if is_nil(session) do
      {:error, "AOC_SESSION environment variable not set"}
    else
      url = "https://adventofcode.com/#{@year}/day/#{day}/input"

      case Req.get(url, headers: [{"cookie", "session=#{session}"}]) do
        {:ok, %{status: 200, body: body}} -> {:ok, body}
        {:ok, %{status: status}} -> {:error, "HTTP #{status}"}
        {:error, reason} -> {:error, reason}
      end
    end
  end

  defp get_session do
    case System.get_env("AOC_SESSION") do
      nil ->
        # Load environment variables from .env file, merging with existing system env vars
        env = Dotenvy.source!([".env", System.get_env()])

        # Set each environment variable in the system so they're available via System.get_env/1
        Enum.each(env, fn {key, value} -> System.put_env(key, value) end)
        System.get_env("AOC_SESSION")

      session ->
        session
    end
  end
end
