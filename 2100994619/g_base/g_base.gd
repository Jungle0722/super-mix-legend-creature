var name = "g_base"
var test = false
var g_sys = {"leader.three":true}
var file = File.new()
var ctrl = null

signal onPickCha    #选角色界面时发射信号
signal onPickItem   #选道具界面时发射信号
signal onNewGame    #初次进入游戏界面时发射信号
signal onLoadGame   #读取进入游戏界面时发射信号
signal onSaveGame   #退回标题页面时发射信号

func _init():
    sys.get_node("/root/Control/Panel2/Panel/Button").connect("pressed",self,"gameInit",["gameSet",true])
    sys.get_node("/root/Control/Panel2/Panel/jiXuBtn").connect("pressed",self,"gameInit",["gameStart",false])
func gameInit(name, sel):
    if name == "gameSet":
        call_deferred("gameSet")
    elif name == "gameStart":
        call_deferred("gameStart",sel)
func gameSet():
    sys.get_node("/root/topUi").get_children()[-1].connect("tree_exited",self,"gamePickCha")
func gamePickCha():
    if sys.has_node("../main"):
        sys.get_node("/root/topUi").find_node("?msgBaseX*",false,false).get_node("btn_start").connect("button_down",self,"gamePickItem")
        emit_signal("onPickCha")
func gamePickItem():
    sys.get_node("/root/topUi/msgBaseX").get_node("btn_start").connect("button_down",self,"gameInit",["gameStart",true])
    emit_signal("onPickItem")
func gameStart(sel):
    if sel:
        initData()
        emit_signal("onNewGame")
    else:
        loadData()
        emit_signal("onLoadGame")
    sys.main.connect("tree_exited",self,"gameExit")
func gameExit():
    saveData()
    emit_signal("onSaveGame")
    _init()

func initData():
    g_sys = {"leader.three":true}
    if test: print("Data:Init %s" % name)
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

func loadImg(path,imgPath) -> ImageTexture:
    var im = Image.new()
    im.load("%s/%s" % [path,imgPath])
    var imt = ImageTexture.new()
    imt.create_from_image(im)
    return imt

func find_file(path:String, filter:Array, flip:bool = false) -> Array:
    var file_list = []
    var dir = Directory.new()
    if dir.open(path) == OK:
        dir.list_dir_begin(true)
        var file_name = dir.get_next()
        while file_name != "":
            if dir.current_is_dir():
                file_list += find_file(path + "/" + file_name, filter, flip)
            else:
                if flip:
                    if not file_name.split(".")[-1] in filter:
                        file_list.append(path + "/" + file_name)
                else:
                    if file_name.split(".")[-1] in filter:
                        file_list.append(path + "/" + file_name)
            file_name = dir.get_next()
    else:
        print("错误：查找路径"+ path +"时出错")
    return file_list

# .rndPool.items
# .infoDs
# sys
# config
# chaData
# itemData
# guanKaData
# jinJieData
# talentData
# globalData
# topUi
# audio
# godotsteam
# Control

# .import
# Images.xcassets
# core
# ex
# godotSteam
# mods
# res
# ui
# control.gd.remap
# control.gdc
# control.tscn
# default_bus_layout.tres
# default_env.tres
# godotsteam.gdnlib
# ico.png
# ico.png.import
# ico16.ico
# ico32.ico
# main.gd.remap
# main.gdc
# main.tscn
# project.binary
# test.tscn