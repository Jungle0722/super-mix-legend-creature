var id = ""         #此MOD创意工坊ID，可选，暂不使用
var name = "g_test" #此文件名称
var test = false    #是否开启测试，推荐格式，非必要
var data = []       #想要支持硬盘保存的数据，也可以改成字典或其他类型
var base = null     #基础工具变量名
var path = null     #本MOD的地址

func _init():
    #读取完毕后初始化，可解决创意工坊后于本地mod调用的问题
    call_deferred("testInit")
func testInit():
    #检测是否有依赖的工具
    if globalData.infoDs.has("g_base"):
        #获取基础工具对象
        base = globalData.infoDs["g_base"]
        #获取本MOD地址，本测试工具用工具人实现，实际应用请选择你MOD实际存在的角色ID
        path = chaData.infoDs["cex___toolman"].dir
    else:
        #在游戏内抛出异常
        var ctrl = sys.get_node("../Control")
        var label = Label.new()
        label.text = "本MOD依赖BaseTools工具，请在创意工坊内订阅，该MOD必需物品栏可直接找到链接"
        print(label.text)
        ctrl.add_child(label)
    if base != null:
        pass
        #在基础工具内注册的数据，建议使用name注册，以提高与其他mod的兼容性
        #base.g_sys[name] = data
        #连接基础工具信号，建议使用以下三段连接方式，否则可能导致存档失效
        #base.connect("onNewGame",self,"testNewGame")
        #base.connect("onNewGame",self,"testGameCtrl")
        #base.connect("onLoadGame",self,"testGameCtrl")
func testNewGame():
    #这里是新开始游戏的初始化操作，可以给全局变量赋值、增加装备角色等
    sys.main.player.addItem(sys.newItem("i_dun"))
func testGameCtrl():
    #这里是新游戏和读取游戏都会经过的函数，可以读取base.g_sys到自己的全局变量、连接sys.main信号、调整开局状态等
    if base.g_sys.has(name):
        data = base.g_sys[name]
    sys.main.connect("onBattleStart",self,"testBattleStart")
    #这里绘制战斗页面需要的UI
    #bgdBattleUI()

func bgdBattleUI():
    #战斗背景绘制，loadImg函数需要提交当前MOD地址和图片相对地址
    sys.main.get_node("scene/bg/bg").set_texture(base.loadImg(path,"cex___toolman/cha.png"))

func testBattleStart():
    pass