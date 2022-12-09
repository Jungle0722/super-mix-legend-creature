extends Talent

var buffUtil = globalData.infoDs["g_azurlineBuffs"]
func init():
	name = "后效强化"
func _connect():
	sys.main.connect("onCharaAddBuff",self,"run")

var includes = ["b_freeze", "b_blindness", "b_zhonDu_r", "b_shaoZhuo_r", "b_moYu_r", "b_diYu_r", "b_liuXue_r", "b_jiSu_r", "b_kuangNu_r",
"b_zhonDu", "b_shaoZhuo", "b_moYu", "b_diYu", "b_liuXue", "b_jiSu", "b_kuangNu", "b_shiMing", "b_jieShuang", "b_shaoShi", "b_huoLi", "b_zhenFen"]
func run(buff:Buff):
	if includes.has(buff.id):
		if buff.isNegetive && buff.masCha.team == 2 || not buff.isNegetive && buff.masCha.team == 1:
			buff.pw = 1.3

func get_info():
	return "BUFF效果提高30%(对所有原版BUFF及<致盲><霜冻><烧蚀><活力>有效)\n[color=#DC143C]此天赋不需要升级，仅限碧蓝MOD使用"

