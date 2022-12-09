extends "../azurline_base_item/azurline_rare_item.gd"
func init():
	.init()
	name = "[稀有]复读机"
	info = "佩戴者每次施放技能，会立即再施放一次\n一个角色只能携带一件本装备\n[color=#DC143C]同时装备两件时可升级[/color]\n[color=#C0C0C0]特效可被科研装备吞噬"
	price = 300
	att.atk = 100
	att.mgiAtk = 100
	
func _connect():
	._connect()
	for i in masCha.items:
		if i.id == id && i != self:
			delFromCha()
			return
	masCha.connect("onCastCdSkill", self, "onCastCdSkill")

var enable = true
func onCastCdSkill(id):
	if enable:
		var skill = masCha.getSkill(id)
		enable = false
		skill.nowTime += skill.cd/(1+masCha.att.cd)

func _upS():
	enable = true