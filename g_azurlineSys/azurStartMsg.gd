extends "res://ui/msgBaseX/msgBaseX.gd"

onready  var box = $Panel / ScrollContainer / GridContainer
var sel_file = "user://data1/sel.save"

var n = 6
var ids = []
var itms = {}
var sel_dic = []
signal sel_complete(sit)

func _ready():
	sys.sel_num = n
	for i in chaData.rndPoolRal:
		if i.find("azurline") == -1:continue
		var item = preload("res://ui/startMsg/startItem.tscn").instance()
		item.init(i)
		box.add_child(item)
		itms[item.cha.id] = item
		item.connect("selCha", self, "selCha")
	load_sel()
	$Button3.connect("button_down", self, "load_sel")
	$save_btn.connect("button_down", self, "save_sel")

func init():
	popup()

func selCha(item):
	if item.is_sel == true:
		ids.append(item.cha.id)
		sys.sel_num -= 1
		n -= 1
	else :
		ids.erase(item.cha.id)
		n += 1
		sys.sel_num += 1
		
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

func _on_Button_pressed():
	if sys.sel_num <= 0:return 
	var f = n
	for fw in f:
		var inx = sys.rndRan(0, box.get_child_count() - 1)
		var item = box.get_child(inx)
		while item.is_sel == true:
			inx = sys.rndRan(0, box.get_child_count() - 1)
			item = box.get_child(inx)

		item._on_Button_pressed()
		
func _on_Button2_pressed():
	save_sel()
	sys.main.isEnd = true
	sys.main.exit()
	queue_free()


func _on_btn_start_button_down():
	save_sel()
	queue_free()
	chaData.rndPoolRsl = ids
	
	pass


func save_sel():
	var f = File.new()
	f.open(sel_file, File.WRITE)
	f.store_var(ids)
	f.close()
	pass
	
func load_sel():
	var f = File.new()
	if f.file_exists(sel_file):
		f.open(sel_file, File.READ)
		var s = f.get_var()
		f.close()
		for i in s:
			if itms.has(i):itms[i]._on_Button_pressed()

func _on_Button4_pressed():
	for i in box.get_children():
		if i.is_sel:
				i._on_Button_pressed()
