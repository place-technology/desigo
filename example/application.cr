require "../src/desigo"

client = Desigo::Client.new(base_url: "https://127.0.0.1:8080/api", username: "admin", password: "admin")

spawn do
  loop do
    client.heartbeat.signal
    sleep 60
  end
end

command_inputs_for_execution = [
  {
    "Name"     => "Value",
    "DataType" => "ExtendedEnum",
    "Value"    => "1",
  },
]

client.commands.execute(id: "System1.ManagementView:ManagementView.A.B.C.D.E", property_name: "Present_Value", command_id: "Write", command_inputs_for_execution: command_inputs_for_execution)
