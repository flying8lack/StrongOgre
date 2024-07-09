# defmodule MySupervisor do
#   use Supervisor

#   def start_link(initial_child = []) do
#     Supervisor.start_link(__MODULE__, initial_child, name: __MODULE__)
#   end

#   @impl true
#   def init(children) do

#     SupervisorOptions = [
#       strategy: :one_for_one,
#       max_restarts: 5,
#       restart_frequency: 10_000,
#       child_recover: callback({__MODULE__, :handle_child_recover})
#     ]

#     {:ok, children, SupervisorOptions}
#   end

#   @callback [{atom, any()}, any()]
#   def handle_child_recover({:shutdown, _reason, %{__exception__: exception}}) do
#     {:shutdown, exception, {:info, "Child process crashed with reason: #{exception}"}}
#   end

#   def handle_child_recover({:info, :started, pid}) do
#     {:ok, pid, {:info, "Child process #{pid} restarted successfully"}}
#   end

#   def handle_child_recover({:info, :terminated, pid, reason, _data}) do
#     start_time = :ets.info(pid, :timestamp) || :undefined
#     current_time = Process.timestamp()

#     recovery_time = if start_time != :undefined do
#       current_time - start_time
#     else
#       :undefined
#     end

#     {:restart, reason, {:info, "Child process #{pid} terminated with reason: #{reason}. Recovery time: #{recovery_time}"}}
#   end
# end
