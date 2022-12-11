extends Node
func _init():
	initHttpClient()
		
var http

var host = "123.60.45.196"
# var host = "127.0.0.1"
# var host = "212.64.85.172"

func initHttpClient():
	http = HTTPClient.new()
	var err = http.connect_to_host(host, 8080) # Connect to host/port.
	assert(err == OK)
	while http.get_status() == HTTPClient.STATUS_CONNECTING or http.get_status() == HTTPClient.STATUS_RESOLVING:
		http.poll()
		yield(sys.get_tree().create_timer(0.5), "timeout")
	assert(http.get_status() == HTTPClient.STATUS_CONNECTED)
	print("连接碧蓝航线服务器成功！")

func connectServer():
	var err = http.connect_to_host(host, 8080) # Connect to host/port.
	assert(err == OK)
	var count = 0
	while (http.get_status() == HTTPClient.STATUS_CONNECTING or http.get_status() == HTTPClient.STATUS_RESOLVING) and count < 20:
		http.poll()
		count += 1
		if not OS.has_feature("web"):
			OS.delay_msec(100)
		else:
			yield(Engine.get_main_loop(), "idle_frame")
	assert(http.get_status() == HTTPClient.STATUS_CONNECTED)
	print("服务器重连成功！")

func sendRequest(path, method = HTTPClient.METHOD_GET, body = "", reSendCount = 0):
	if http.get_status() != HTTPClient.STATUS_CONNECTED:
		print("服务器断开，重连服务器中...")
		#connectServer()
	var headers
	if method == HTTPClient.METHOD_POST:
		headers = [
			"User-Agent: Pirulo/1.0 (Godot)",
			"Accept: */*",
			"Content-Type: application/json; charset=UTF-8"
		]
	else:
		headers = [
			"User-Agent: Pirulo/1.0 (Godot)",
			"Accept: */*",
			"Content-Type: application/x-www-form-urlencoded"
		]
	var err = http.request(method, path, headers, body) # Request a page from the site (this one was chunked..)
	assert(err == OK) # Make sure all is OK.
	while http.get_status() == HTTPClient.STATUS_REQUESTING:
		http.poll()
		if not OS.has_feature("web"):
			OS.delay_msec(100)
		else:
			yield(Engine.get_main_loop(), "idle_frame")
	if  http.get_status() != HTTPClient.STATUS_BODY and http.get_status() != HTTPClient.STATUS_CONNECTED:
			print("接受服务器返回信息失败，重新请求服务器中...")
			if reSendCount < 3:
				sendRequest(path, method, body, reSendCount + 1)

	if http.has_response():
		headers = http.get_response_headers_as_dictionary() # Get response headers.
		if http.is_response_chunked():
			pass
		else:
			var bl = http.get_response_body_length()
		var rb = PoolByteArray() # Array that will hold the data.
		while http.get_status() == HTTPClient.STATUS_BODY:
			http.poll()
			var chunk = http.read_response_body_chunk() # Get a chunk.
			if chunk.size() == 0:
				OS.delay_usec(1000)
			else:
				rb = rb + chunk
		var text = rb.get_string_from_utf8()
		return text