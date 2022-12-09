extends "../azurline_base_item/azurline_base_item.gd"

func _connect():
	var flag = true
	for i in masCha.items:
		if i.id != self.id and i.id.find("Hide_alr_") > -1:
			flag = false
			sys.newBaseMsg("提示", "一个角色只能装备一件科研装备")

	if not flag:
		delFromCha()
		return
	for i in skills:
		var sks = itemSkills.skills.get(i)
		for j in sks:
			var sk = j.new()
			sk.setItem(self)