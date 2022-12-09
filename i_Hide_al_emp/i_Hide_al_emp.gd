extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "[稀有]EMP"
	info = "下回合开始时，使敌方所有角色损失2件装备，对塞壬效果减半\n[color=#C0C0C0]一次性消耗品，拖到小卖部上即可生效"
	price = 0
var itemTag = "tmp"
func _connect():
	if masCha.id != "cex___al-merchant":
		delFromCha()
		return
	var sk = itemSkills.Skill_200.new()
	sk.setItem(self)
	delSelf()

	
