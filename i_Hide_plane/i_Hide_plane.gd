extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "量产型舰载机"
	info = "使用最为广泛的多用途量产型战机，以其性价比而闻名于世"
	price = 0
func _connect():
	if self.has_method("refresh"):
		call("refresh")
	if masCha.getSkill("castPlane") == null:
		if masCha.id != "cex___al-merchant":
			delFromCha()
	else:
		masCha.crewEquip = planeId
		masCha.crewEquipName = name
		masCha.crewLv = int(masCha.crewLv)
		yield(masCha.reTimer(0.1), "timeout")
		sys.main.player.delItem(self)

var rare:bool = false
var planeId
func repair(rare = false, id = null):
	if id == null:
		planeId = utils.getRndPlane(rare)
	else:
		planeId = id
	var chara = sys.main.newChara(planeId)
	chara._extInit()
	if rare:
		self.rare = true
		name = "[color=#FFFF00][稀有]" + chara.chaName
	else:
		name = chara.chaName
	info = "技能组：\n"
	for i in chara.skillStrs:
		info += i + "\n"
	info += "[color=#DC143C]给航母装备后消失，航母将在战斗中召唤此型号的舰载机"