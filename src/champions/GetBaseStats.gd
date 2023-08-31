extends HTTPRequest


# Called when the node enters the scene tree for the first time.
func getChampion(id):
	request_completed.connect(_on_request_completed)
	request("http://127.0.0.1:8090/api/collections/champions/records/" + id)

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	get_parent().sendChampDataToClient(json)

