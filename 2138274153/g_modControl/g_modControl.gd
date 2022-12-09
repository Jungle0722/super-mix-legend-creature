var g_sys = {"leader.three":true}
var path=""
var name = "g_modControl"
var setMsg#设置弹窗
var setBtn#设置按钮
var okBtn
var file = File.new()
signal onControlReady   #全mod设置加载完成
signal onBoxReady   #个人MOD设置加载完成
signal pressed2   #按下按钮

var test=true
func _init():	
	yield(sys.get_tree().create_timer(0.1),"timeout")
	call_deferred("setss")
	call_deferred("gameInit")
	sys.get_node("/root/Control/Panel2/Panel/Button").connect("pressed",self,"gameInit",["gameSet",true])   #当按下新游戏的时候连接到gameinit并传参
	sys.get_node("/root/Control/Panel2/Panel/jiXuBtn").connect("pressed",self,"gameInit",["gameStart",false]) #当按下继续游戏的时候连接到gameinit并传参

func gameInit(name,sel):
	if name == "gameSet":
		call_deferred("gameSet") #延迟到自身空闲再响应gameset
	elif name == "gameStart":
		call_deferred("gameStart",sel) #延迟到自身空闲再响应gamestart

func gameSet():
	sys.get_node("/root/topUi").get_children()[-1].connect("tree_exited",self,"gamePickCha") #topui结束后调用

func gamePickCha():
	if sys.has_node("../main"):
		sys.get_node("/root/topUi").find_node("?msgBaseX*",false,false).get_node("btn_start").connect("button_down",self,"gamePickItem")
		
func gamePickItem():
	sys.get_node("/root/topUi/msgBaseX").get_node("btn_start").connect("button_down",self,"gameInit",["gameStart",true])

func gameStart(sel):
	sys.main.connect("tree_exited",self,"gameExit")

func gameExit():
	redo2()

func redo2():
	var n=0
	while sys.has_node("/root/Control/Panel2/Panel")==false:
		n+=1
		yield(sys.get_tree().create_timer(0.5),"timeout")
		if n>=10:
			return
	call_deferred("redo3")
func redo3():
	if sys.has_node("/root/Control/Panel2/Panel"):
		setss()
	sys.get_node("/root/Control/Panel2/Panel/Button").connect("pressed",self,"gameInit",["gameSet",true])   #当按下新游戏的时候连接到gameinit并传参
	sys.get_node("/root/Control/Panel2/Panel/jiXuBtn").connect("pressed",self,"gameInit",["gameStart",false]) #当按下继续游戏的时候连接到gameinit并传参


func setss():
	loadData()
	if sys.has_node("/root/Control/Panel2/Panel/Modsetbtn")==false:
		setBtn = Button.new()
		setBtn.text = "mod配置"
		setBtn.name="Modsetbtn"
		setBtn.connect("pressed",self,"peizhi")	
		sys.get_node("/root/Control/Panel2/Panel").add_child(setBtn)

		setMsg=WindowDialog.new()
		setMsg.name="Modset"
		sys.get_node("/root/Control").add_child(setMsg)
		setMsg.set_size(Vector2(500,500))

		var setPanel=Panel.new()
		setPanel.name="Panel"
		setPanel.set_h_size_flags(3)
		setPanel.set_v_size_flags(3)
		setPanel.set_size(Vector2(500,500))
		setPanel.add_stylebox_override("panel",StyleBoxEmpty.new())
		setMsg.add_child(setPanel)

		var msgTittle=Label.new()
		msgTittle.align=1
		msgTittle.name="Label"
		msgTittle.text="MOD内部设置"
		msgTittle.set_anchors_preset(10)
		msgTittle.set_margin(1,-25)
		setPanel.add_child(msgTittle)

		var msgScroll=ScrollContainer.new()
		msgScroll.name="Scroll"
		msgScroll.set_anchors_preset(15)
		msgScroll.set_margin(0,30)
		msgScroll.set_margin(1,20)

		setPanel.add_child(msgScroll)

		var msgVBox=VBoxContainer.new()
		msgVBox.name="Vbox"
		msgVBox.set_custom_minimum_size(Vector2(450,400))
		msgVBox.set_h_size_flags(4)
		msgVBox.set_alignment(1)
		msgVBox.set_draw_behind_parent(true)
		msgScroll.add_child(msgVBox)
	emit_signal("onControlReady")
func peizhi():
	setMsg.popup_centered()	

func modBtn(text,id,event1="",obj=null,event2="",binds=[]):#如果不输入event1采用默认构造方法，返回一个button实例
	path="/root/Control/Modset/Panel/Scroll/Vbox"
	var box=sys.get_node(path)
	var modBtn=Button.new()
	modBtn.text=text
	modBtn.name=id+"Btn"
	if obj==null:
		modBtn.set_h_size_flags(4)
		modBtn.connect("pressed",self,"modControl",[id])
	else:
		modBtn.connect(event1,obj,event2,binds)

	box.add_child(modBtn)
	return modBtn	
func modControl(id):#生成单个mod控制器实例，然后发送一个含有box参数和mod文本的信号用于额外操作
	var modMsg=WindowDialog.new()
	modMsg.set_size(Vector2(400,500))
	modMsg.name=id+"Msg"
	sys.get_node("/root/Control").add_child(modMsg)
	var modVBox=VBoxContainer.new()
	modVBox.name="VBox"
	modVBox.set_alignment(1)
	modVBox.rect_position=Vector2(50,50)
	modMsg.add_child(modVBox)	
	loadData()
	okBtn=Button.new()
	okBtn.text="保存"
	okBtn.name="SaveBtn"
	okBtn.set_anchors_preset(7)
	okBtn.set_margin(1,-70)
	okBtn.set_margin(3,-45)
	okBtn.set_margin(0,-20)
	modMsg.add_child(okBtn)
	modMsg.popup_centered()
	emit_signal("onBoxReady",modVBox,id)

func newUpdateBtn(id,parent,infoId="",path=""):
	var infoBtn=Button.new()
	infoBtn.text=infoId
	infoBtn.connect("pressed",self,"infoMsg",[id,infoId,path])	
	infoBtn.set_h_size_flags(3)
	parent.add_child(infoBtn)

func newCheck(text,parent,name="",pressed=false,disabled=false,event1="",obj=null,event2="",binds=[],selfIf=false):
	#text显示文本，parent挂载的父节点，name控件ID，pressed是否选择，disabled是否被禁用，selIf是否在链接事件参数内增加check实例参数
	var c=CheckBox.new()
	c.text=text
	c.disabled=disabled
	c.pressed=pressed
	if name!="":
		c.name=name
	parent.add_child(c)
	if event1!="":
		var b=binds
		if selfIf==true:
			b.append(c)
		c.connect(event1,obj,event2,b)
	return c

func loadData():
	if file.file_exists("user://data1/%s.save" % name):
		file.open("user://data1/%s.save" % name, File.READ)
		if file.get_len() > 0:
			g_sys = parse_json(file.get_line())
			if test: print("Data:Load %s" % name)
		file.close()
	
func saveData():
	file.open("user://data1/%s.save" % name, File.WRITE)
	file.store_line(to_json(g_sys))
	if test: print("Data:Save %s" % name)
	file.close()

func loadInfo(path):
	if file.file_exists(path):
		file.open(path,File.READ)
		var pkmInfo=file.get_as_text()
		file.close()
		return pkmInfo
	else:
		return "更新文档不存在"
	
func infoMsg(id,infoId,path):
	var infoMsg=WindowDialog.new()
	infoMsg.set_size(Vector2(1000,600))
	infoMsg.name=id+"Info"
	sys.get_node("/root/Control").add_child(infoMsg)
	var pkmvBox=VBoxContainer.new()
	pkmvBox.name=id+"Vbox"
	#msgVBox.set_custom_minimum_size(Vector2(450,400))
	pkmvBox.set_alignment(1)
	infoMsg.add_child(pkmvBox)
	pkmvBox.rect_position=Vector2(25,30)
	var info=RichTextLabel.new()
	info.bbcode_text=loadInfo(path)
	info.bbcode_enabled=true
	info.set_custom_minimum_size(Vector2(950,500))
	pkmvBox.add_child(info)
	var title=Label.new()
	title.text=infoId
	title.align=1
	title.set_anchors_preset(10)
	title.set_margin(1,-25)
	infoMsg.add_child(title)
	infoMsg.popup_centered()