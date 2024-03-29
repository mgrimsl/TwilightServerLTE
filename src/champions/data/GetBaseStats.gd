extends HTTPRequest

var id 

# Called when the node enters the scene tree for the first time.
func getChampion(id):
	self.id = id
	request_completed.connect(_on_request_completed)
	request("http://20.115.123.255:8081/api/collections/champions/records/" + id)

func getAbilityData(id):
	pass
	#request_completed.connect(_)
	#request("http://20.115.123.255:8081/api/collections/champions/records/" + id)

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	get_parent().updateBaseStats(json["baseStats"])
	#get_parent().get_node("AbilityHandler").loadAbilities({"A1": json["A1"],"A2" :json["A2"], "A3" :json["A3"],"A4" :json["A4"] ,"AA": json["AA"] })
	request_completed.connect(_abilities)
	request_completed.disconnect(_on_request_completed)
	request("http://20.115.123.255:8081/api/collections/abilities/records/?filter=(champion=\'"+id+"\')")
	
func _abilities(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	get_parent().AH.loadAbilities(json["items"])
