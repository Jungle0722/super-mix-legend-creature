extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "技能书"
	info = "一本空白技能书，没有任何作用"
	price = 50
var itemTag = "skillbook"
#状态：0损坏1正常2进阶
var state = 0
#战斗场数
var num = 0
var itemType = "skillbook"
var skill
func _connect():
	if skill==null or masCha.get("type") == "npc":return
	if not masCha.has_method("setSkill"):
		delFromCha()
		return
	if masCha.has_method("setSkill"):
		masCha.setSkill(skill, self)

#修复技能书
func repair(rarity, sid = null):
	skill = skillPool.getRandomSkill(rarity)
	if sid != null:
		skill = skillPool.getSkill(sid, rarity)

	if skill == null or skill.text == null or skill.sname == null:return
	info = skill.text + "\n3-4级舰娘才能读书，若目标人物已学过其他技能，阅读本书则会将其覆盖\n[color=#C0C0C0]重复阅读同等级的同名技能将提升技能等级[/color]"
	name = getPrefix(rarity) + skill.sname + "·技能书"
	
func getPrefix(rarity):
	match rarity:
		1:
			return "[普通]"
		2:
			return "[color=#FF00FF][稀有]"
		3: 
			return "[color=#FFFF00][传说]"

func toJson():
	var json = .toJson()
	if skill != null:
		json["skId"] = skill.sid
		json["skLv"] = skill.rarity
	return json

func fromJson(json):
	.fromJson(json)
	if json.get("skId") != null:
		repair(int(json.get("skLv")), int(json.get("skId")))