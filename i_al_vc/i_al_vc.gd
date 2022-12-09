extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "VC装甲钢板"
	att.def = 100
	att.mgiDef = 100
	info = "免疫<重创><烧蚀><中毒><破甲><霜冻>\n[color=#DC143C]同时装备三件时可升级[/color]\n基础属性数值随机浮动"
func _connect():
	masCha.connect("onAddBuff",self,"onAddBuff")
	utils.itemUpgrade(self)

var includes = ["b_zhongChang", "b_shaoShi", "b_zhonDu", "b_zhonDu_r", "b_perforation", "b_louShui", "b_freeze"]
func onAddBuff(buff:Buff):
	if buff.isNegetive && p || includes.has(buff.id):
		buff.isDel = true

var p = false
var upgraded = false
func upgrade():
	name = "[color=#FFFF00]VC装甲钢板·改"
	info = "免疫负面状态"
	att.def = 200 * relic.equipBonus
	att.mgiDef = 200 * relic.equipBonus
	p = true

