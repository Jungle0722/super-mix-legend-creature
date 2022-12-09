extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "[稀有]星云舞裙"
	att.atk = 100
	att.mgiAtk = 100
	info = text%0
func _connect():
	if masCha == null || masCha.get("itemEvoCha2") == null || not utils.inBattle(masCha) || azurCtrl.miuChas.has(masCha.get("itemEvoCha2")):return
	sys.main.connect("onBattleEnd",self,"end")
	num = 0
	info = text%num
	var achiOther = base.getSetting("achiOther", [])
	if achiOther.has("miu"):
		doEvo()

const text = "每参加一场战斗，获得10点经验，累积经验100，可将携带者转化为μ兵装形态\n更换携带者会清空经验，当前经验:%d\n支持转化的角色：[color=#DC143C]克利夫兰、赤城、希佩尔海军上将、黛朵、光辉、罗恩、恶毒、大凤、塔什干、加斯科涅[/color]\n[color=#DC143C]已获得的μ兵装舰娘不能重复获得[/color]\n来源：PT商店"
var num = 0
func end():
	if masCha == null || masCha.get("itemEvoCha2") == null || not utils.inBattle(masCha) || azurCtrl.miuChas.has(masCha.get("itemEvoCha2")):return
	num += 10
	info = text%num
	if num >= 100: 
		doEvo()

func doEvo():
	sys.main.player.addCha(sys.main.newChara(masCha.id))
	sys.main.player.addCha(sys.main.newChara(masCha.id))
	var cha = sys.main.evoChara(masCha, masCha.get("itemEvoCha2"))
	cha.isDrag = true
	cha.delItem(self)
	yield(sys.get_tree().create_timer(0.1), "timeout")
	sys.main.player.delItem(self)
	azurCtrl.miuChas.append(cha.id)
