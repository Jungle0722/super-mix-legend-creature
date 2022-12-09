var base
var modId
var c0
var c1
var c2
var pressedList=[false,true,false]
var test=true
func _init():
	if test==false:return
	call_deferred("modInit")

func modInit():
	modId="test"#定义mod的ID名字,可以帮助寻找自己的控件节点
	base=globalData.infoDs["g_modControl"]#获取控制台文件
	base.connect("onControlReady",self,"btnInit")#获取mod配置按钮初始化完成信号
	base.connect("onBoxReady",self,"addControl")#获取你的modbtn被点击信号

func btnInit():
	print("btninit成功")
	base.modBtn("mod配置测试",modId)#建立你的modbtn，按钮为mod配置测试，modbtn也支持连接事件操作
	print("bt")

func addControl(box,id):
	if id!=modId:#如果打开的不是你的mod返回
		return 
	saveAndLoad("load")#读取信息
	var path=chaData.infoDs["c_HideTest"].dir
	base.newUpdateBtn(modId,box,"更新测试",path+"/info.txt")
	c0=base.newCheck("默认构造测试",box)#建立一个新的check在你的控制窗口里，默认是竖排版
	c1=base.newCheck("禁用测试",box,"c1",pressedList[1],true)#建立一个新的check在你的控制窗口里，其中是否勾选根据pressedList[1]，true是勾选false是未勾选，下一个参数是是否禁用，true禁用
	c2=base.newCheck("链接测试",box,"c2",pressedList[2],false,"pressed",self,"printInfo")#最后几个参数是connect，可以再加个参数binds数组，表示传输参数，binds后加入一个selif参数表示是否在参数结尾传入刚新建的newcheck自身
	var okBtn=base.okBtn#获取保存按钮
	if okBtn.is_connected("pressed",self,"saveAndLoad")==false:
		okBtn.connect("pressed",self,"saveAndLoad",["save"])

func saveAndLoad(s):
	print("baocun")
	if s=="load":
		base.loadData()
		var y=base.g_sys.get("testSettings",[false,true,false])
		pressedList[0]=y[0]
		pressedList[1]=y[1]
		pressedList[2]=y[2]
	else:
		base.g_sys["testSettings"]=[c0.pressed,c1.pressed,c2.pressed]
		base.saveData()

func printInfo():
	var strs="当前未勾选"
	if c2.pressed:
		strs="当前已勾选"
	print(strs)