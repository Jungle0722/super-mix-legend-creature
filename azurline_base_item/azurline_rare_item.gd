extends "../azurline_base_item/azurline_base_item.gd"

func _connect():
	itemUpgrade()

	for i in skills:
		var sks = itemSkills.skills.get(i)
		for j in sks:
			var sk = j.new()
			sk.setItem(self)
var upgraded = false
func itemUpgrade():
	if masCha.isSumm || get("upgraded") == null || upgraded:return
	yield(sys.get_tree().create_timer(0.2), "timeout")
	var n = 0
	for i in masCha.items:
		if  i.id == id:
			n += 1
	if n == 2:
		var newItem = sys.newItem(id)
		newItem.upgraded = true
		newItem.getRndSkill()
		sys.main.player.addItem(newItem)
		var index = masCha.items.size() - 1
		var num = 0
		var cha = masCha
		while(index >= 0 and num < 2):
			var i = cha.items[index]
			if i.id == id:
				sys.main.player.delItem(i)
				num += 1
			index -= 1
		cha.addItem(newItem)

func getRndSkill():
	var key = sys.rndListItem(itemSkills.skills.keys())
	var sk = itemSkills.skills.get(key)[0].new()
	skills.append(key)
	info = info.replace("同时装备两件时可升级", "额外随机特效：%s"%sk.text)
	name += "·改"