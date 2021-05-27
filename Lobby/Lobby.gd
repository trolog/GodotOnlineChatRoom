extends CanvasLayer

onready var joinbutton = $vbxLobbyContainer/btnJoin
onready var hostbutton = $vbxLobbyContainer/btnHost
onready var status = $hbxStatusContainer/lblStatus
onready var colors = $vbxLobbyContainer/hbxIPContainer2/optColors
onready var ip_address = $vbxLobbyContainer/hbxIPContainer/txtIP
onready var user_name = $vbxLobbyContainer/hbxNameContainer/txtName

func _ready() -> void:
	compile_colors()
	get_tree().connect("connection_failed", self, "connected_fail")
	
#populate the option list with colors
func compile_colors():
	colors.add_item("red")
	colors.add_item("green")
	colors.add_item("yellow")
	colors.add_item("blue")
	colors.add_item("black")
	colors.add_item("purple")

func _on_btnHost_pressed() -> void:
	Network.create_server()
	status.text = "Hosting"
	Network.user_name = user_name.text
	#put our username and ID in the dictionary
	Network.user_list[str(get_tree().get_network_unique_id())] = Network.user_name

func _on_btnJoin_pressed() -> void:
	#Create a  client that will connect to the server
	var client : NetworkedMultiplayerENet = NetworkedMultiplayerENet.new()
	client.create_client(ip_address.text,9999)
	get_tree().set_network_peer(client)
	
	#Disable buttons while we wait
	joinbutton.disabled = true
	hostbutton.disabled = true
	
	#Update status and username for chatroom
	status.text = "Trying to join to " + ip_address.text
	Network.user_name = user_name.text
	
#failed to connect check ip? check server is open?
func connected_fail():
	print("Failed to connect")
	status.text = "Couldn't connect try again, or host?"
	#Connection failed so allow user to try again
	joinbutton.disabled = false
	hostbutton.disabled = false

#Update our users colour to be used in the chatroom
func _on_optColors_item_selected(index: int) -> void:
	Network.user_color = colors.text
