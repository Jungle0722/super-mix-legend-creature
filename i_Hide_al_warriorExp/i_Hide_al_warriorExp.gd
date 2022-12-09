extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "[稀有]战士的心得"
	att.atk = 100
	att.mgiAtk = 100
	att.spd = 0.3
	att.cri = 0.3
	info = "每参加一场战斗，获得10点经验，累积经验100，可将携带者特殊进化\n更换携带者会清空经验，当前经验:0\n支持进化的角色：[color=#DC143C]厌战(Lv3)、金布里(Lv2)、明石(任意型号)[/color]"
func _connect():
	sys.main.connect("onBattleEnd",self,"end")
	num = 0
	info = text%num
	var achiOther = base.getSetting("achiOther", [])
	if achiOther.has("warrior"):
		achi = true
const text = "每参加一场战斗，获得10点经验，累积经验100，可将携带者特殊进化\n更换携带者会清空经验，当前经验:%d\n支持进化的角色：[color=#DC143C]厌战(Lv3)、金布里(Lv2)、明石(任意型号)[/color]"
var num = 0
func end():
	if masCha == null || masCha.get("itemEvoCha") == null || not utils.inBattle(masCha):return
	num += 10
	if achi:num += 10
	info = text%num
	if num >= 100: 
		sys.main.player.addCha(sys.main.newChara(masCha.id))
		sys.main.player.addCha(sys.main.newChara(masCha.id))
		var cha = sys.main.evoChara(masCha, masCha.get("itemEvoCha"))
		cha.isDrag = true
		cha.delItem(self)
		yield(sys.get_tree().create_timer(0.2), "timeout")
		sys.main.player.delItem(self)