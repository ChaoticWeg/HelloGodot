class_name ServerConnection
extends Node

@export var websocket_url = "wss://localhost:32769/ws"
@export var handshake_headers: PackedStringArray
@export var supported_protocols: PackedStringArray
var tls_options: TLSOptions = null

var socket := WebSocketPeer.new()
var last_state := WebSocketPeer.STATE_CLOSED

var is_socket_open: bool:
	get: return last_state == WebSocketPeer.STATE_OPEN

signal connected_to_server()
signal connection_closed()
signal message_received(message: Variant)

func open() -> int:
	socket.supported_protocols = supported_protocols
	socket.handshake_headers = handshake_headers
	
	var err := socket.connect_to_url(websocket_url, tls_options)
	if err != OK: return err
	
	last_state = socket.get_ready_state()
	return OK

func close(code: int = 1000, reason: String = "") -> void:
	socket.close(code, reason)
	last_state = socket.get_ready_state()
	
func send_game_state(state: GameState) -> int:
	return socket.send_text(JSON.stringify(state.as_dict))

func get_message() -> Variant:
	if socket.get_available_packet_count() < 1:
		return null
	var pkt := socket.get_packet()
	return pkt.get_string_from_utf8()

#region Lifecycle methods

func poll() -> void:
	if socket.get_ready_state() != socket.STATE_CLOSED:
		socket.poll()
		
	var state := socket.get_ready_state()
	
	if last_state != state:
		last_state = state
		
		if state == socket.STATE_OPEN:
			connected_to_server.emit()
		elif state == socket.STATE_CLOSED:
			connection_closed.emit()
	
	while socket.get_ready_state() == socket.STATE_OPEN and socket.get_available_packet_count():
		message_received.emit(get_message())

func _process(_delta: float) -> void:
	poll()

#endregion
