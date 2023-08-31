extends Node2D

const PORT = 8080
const MAX_PLAYERS = 200

var peer = ENetMultiplayerPeer.new()
@export var player_scene : PackedScene

func _ready():
	multiplayer.get
	peer.create_server(PORT, MAX_PLAYERS)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	print(multiplayer.is_server())

func add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	add_child(player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
