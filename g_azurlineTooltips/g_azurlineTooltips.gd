extends Node
func _ready():
	pass
func _init():
	call_deferred("init")
var utils = null
var azurCtrl = null
var base = null
var path = null
var btn_script = load(self.get_script().get_path().get_base_dir() + "/itemBtnEx.gd")
var sprite_script = load(self.get_script().get_path().get_base_dir() + "/spriteEx.gd")
var sprite_original = load("res://core/sprite.gd")
func init():
	if globalData.infoDs.has("g_azurlineBase"):
		base = globalData.infoDs["g_azurlineBase"]
		path = chaData.infoDs["cazurlineA"].dir
	if base != null:
		#初始化
		utils = globalData.infoDs["g_azurlineUtils"]
		azurCtrl = globalData.infoDs["g_azurline"]
		call_deferred("_connect")

var theme
var stylebox
func _connect():
	if globalData.infoDs.has("g_tooltips"):return
	sys.get_tree().connect("node_added", self, "on_node_added")
	theme = sys.get_node("/root/Control").theme
	stylebox = theme.get_stylebox("pressed", "Button").duplicate()
	stylebox.content_margin_left = 20
	stylebox.content_margin_right = 20
	stylebox.content_margin_top = 20
	stylebox.content_margin_bottom = 20

func on_node_added(node):
	if node is ItemBt:
		utils.changeScript(node, btn_script)
		
func new_msgbox():
	var result = RichTextLabel.new() 
	result.bbcode_enabled = true
	result.scroll_active = false
	result.scroll_following = false
	result.theme = theme
	result.set("custom_styles/normal", stylebox)
	result.mouse_filter = Control.MOUSE_FILTER_IGNORE
	result.rect_min_size = Vector2(400, 0)
	result.name = "itemMsgBox"
	return result

func calc_poistion_and_size(msgbox, node):
	fit_content(msgbox)
	msgbox.rect_position = node.rect_global_position
	msgbox.rect_position.x += node.rect_size.x 
	msgbox.rect_position.y += node.rect_size.y
	if msgbox.rect_position.x + msgbox.rect_size.x > sys.get_viewport().get_size_override().x:
		msgbox.rect_position.x -= msgbox.rect_size.x + node.rect_size.x
	if msgbox.rect_position.y + msgbox.rect_size.y > sys.get_viewport().get_size_override().y:
		msgbox.rect_position.y -= msgbox.rect_position.y + msgbox.rect_size.y - OS.window_size.y + 40


func fit_content(label):
	var font = label.theme.default_font
	var panel = label.get("custom_styles/normal")

	var lines = label.text.split('\n')
	while(lines.size() and lines[-1] == ""):
		lines.remove(lines.size()-1)
	var line_cnt = lines.size()

	for line in lines:
		var text_length = font.get_string_size(line).x
		var label_width = label.rect_min_size.x - (panel.content_margin_left + panel.content_margin_right)
		if text_length > label_width:
			line_cnt += int(text_length/label_width)
	
	label.rect_min_size.y = line_cnt * (font.get_height()+font.get_descent())
	label.rect_min_size.y += panel.content_margin_top + panel.content_margin_bottom - font.get_descent()