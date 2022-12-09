extends "res://ui/msgBaseX/msgBaseX.gd"

onready var box = $Panel / ScrollContainer / GridContainer
var sel_item_file = "user://data1/sel_item.save"
var n = 30
var ids = []
var itms = {}
var sel_dic = []

func _ready():
	$test_save.connect("button_down", self, "save_sel")
	$test_load.connect("button_down", self, "load_sel")
	$Panel / Label2.text = str(n)
	sys.sel_item_num = 40
	for i in itemData.infos:
		if i.hide == false and (i.id.find("_azurline_") > -1 or i.id.find("_al_") > -1):
			var item = preload("res://ui/startItemMsg/startItem.tscn").instance()
			box.add_child(item)
			item.init(i.id)
			item.rect_size = Vector2(150, 150)
			itms[i.id] = item
			item.connect("selCha", self, "selCha")
	load_sel()
		
func init():
	popup()

func selCha(item):
	if item.is_sel == true:
		ids.append(item.it.id)
		sys.sel_item_num -= 1
		n -= 1
	else :
		ids.erase(item.it.id)
		n += 1
		sys.sel_item_num += 1

	if n > 0:
		
		for i in itms.values():
			if i.is_sel == false:
				i.set_true()
		
		$btn_start.visible = false

	else :
		$btn_start.visible = true
		
		for i in itms.values():
			if i.is_sel == false:
				i.set_false()
	$Panel / Label2.text = str(n)
	pass

func _on_btn_start_button_down():
	$btn_start.hide()
	save_sel()
	queue_free()
	itemData.rndPoolRsl = ids
	sys.main.initSt()

func save_sel():
	var f = File.new()
	f.open(sel_item_file, File.WRITE)
	f.store_var(ids)
	f.close()
	
func load_sel():
	var f = File.new()
	if f.file_exists(sel_item_file):
		f.open(sel_item_file, File.READ)
		var s = f.get_var()
		f.close()
		for i in s:
			if itms.has(i):itms[i]._on_Button_pressed()

func _on_btn_rnd_button_down():
	if sys.sel_item_num <= 0:return 
	var f = n
	for fw in f:
		var inx = sys.rndRan(0, box.get_child_count() - 1)
		var item = box.get_child(inx)
		while item.is_sel == true:
			inx = sys.rndRan(0, box.get_child_count() - 1)
			item = box.get_child(inx)

		item._on_Button_pressed()

func _on_btn_exit_button_down():
	save_sel()
	sys.main.isEnd = true
	sys.main.exit()
	queue_free()

func _on_btn_rnd2_pressed():
	for i in box.get_children():
		if i.is_sel:
				i._on_Button_pressed()
