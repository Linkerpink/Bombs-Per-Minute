extends Node

var api_url = "http://localhost/bombs-per-minute/api.php"

func send_score():
	var data = {
		"user": globals.current_user,
		"map": globals.current_map,
		"rank": globals.cm_rank,
		"accuracy": globals.cm_accuracy,
		"score": globals.cm_score,
		"best_combo": globals.cm_best_combo,
		"notes_hit": globals.cm_notes_hit,
		"bombs_hit": globals.cm_bombs_hit,
		"notes_missed": globals.cm_notes_missed
	}

	var http := HTTPRequest.new()
	add_child(http)

	var body    = _dict_to_query_string(data)
	var headers = ["Content-Type: application/x-www-form-urlencoded"]

	http.request(api_url, headers, HTTPClient.METHOD_POST, body)
	http.request_completed.connect(_on_request_completed)


func _dict_to_query_string(d: Dictionary) -> String:
	var parts: Array[String] = []
	for k in d.keys():
		var key   = str(k).uri_encode()
		var value = str(d[k]).uri_encode()
		parts.append("%s=%s" % [key, value])
	return "&".join(parts)


func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var text = body.get_string_from_utf8()
		var parsed = JSON.parse_string(text)
		if typeof(parsed) == TYPE_DICTIONARY:
			print("Insert OK, id:", parsed.get("insert_id"))
		else:
			print("Unexpected response:", text)
	else:
		print("HTTP Error:", response_code)
