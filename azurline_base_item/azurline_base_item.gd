extends Item
var azurCtrl = globalData.infoDs["g_azurline"]
var utils = globalData.infoDs["g_azurlineUtils"]
var skillPool = globalData.infoDs["g_azurlineSkills"]
var omg = globalData.infoDs["g_azurlineOMG"]
var base = globalData.infoDs["g_azurlineBase"]
var relic = globalData.infoDs["g_azurlineRelic"]
var research = globalData.infoDs["g_azurlineResearch"]
var difficult = globalData.infoDs["g_azurlineDifficult"]
var itemSkills = globalData.infoDs["g_azurlineItemSkills"]
var buffUtil = globalData.infoDs["g_azurlineBuffs"]
var aroundCells = [Vector2(-1,0),Vector2(1,0),Vector2(0,1),Vector2(0,-1),Vector2(1,1),Vector2(-1,-1),Vector2(1,-1),Vector2(-1,1)]
var achi = false
#额外绑定的技能
var skills = []
var tag = "azurline"
var ronglian:int = 0
func init():
	type = config.EQUITYPE_EQUI
	attInit()
	utils = globalData.infoDs["g_azurlineUtils"]
	skillPool = globalData.infoDs["g_azurlineSkills"]

func delSelf():
	yield(sys.get_tree().create_timer(0.2), "timeout")
	sys.main.player.delItem(self)

func delFromCha():
	yield(sys.get_tree().create_timer(0.2), "timeout")
	masCha.delItem(self)

#军旗合成进化
func upgradeCheck():
	yield(sys.get_tree().create_timer(0.2), "timeout")
	if checkFlagAll():return
	checkAchi()
	if masCha.isSumm or not achi:return
	if masCha == null:return
	var n = 0
	var waitEvoItem
	for i in masCha.items:
		if i.id == id:
			n += 1
		if i.get("level") != null and i.get("level") > 1:
			waitEvoItem = i

	if n == 3 and waitEvoItem == null:waitEvoItem = masCha.items[0]
	if n == 3 and waitEvoItem != null:
		waitEvoItem.levelUp()
		var index = masCha.items.size()-1
		while(index>=0):
			var i = masCha.items[index]
			if i != waitEvoItem and i != self:
				i.delSelf()
			index -= 1
		if self != waitEvoItem:
			delSelf()
		
#纳尔逊的旗语，检查
func checkFlagAll():
	var its = []
	for i in masCha.items:
		if i.get("itemTag") == "flag" and not its.has(i.id):
			its.append(i.id)

	if its.size() == 3:
		sys.main.player.addItem(sys.newItem("i_Hide_al_flagAll"))
		var index = masCha.items.size() - 1
		while(index>=0):
			masCha.items[index].delSelf()
			index -= 1
		return true
	return false

func checkAchi():
	if not base.getSetting("achiCamp", []).empty():
		achi = true

func toJson():
	var attJson = to_json(att)
	var json = {}
	if get("upgraded") != null:
		json["upgraded"] = get("upgraded")
	if get("level") != null:
		json["level"] = get("level")
	if get("state") != null:
		json["state"] = get("state")
	if get("num") != null:
		json["num"] = get("num")

	if get("planeId") != null:
		json["planeId"] = get("planeId")
	if get("rare") != null:
		json["rare"] = get("rare")
	if get("equipId") != null:
		json["equipId"] = get("equipId")
	json["id"] = id
	json["att"] = attToJson()
	json["tag"] = "azurline"
	json["skills"] = skills
	json["info"] = info
	json["ronglian"] = ronglian
	return json

func afterFromJson(json):
	if get("upgraded") != null:
		set("upgraded", bool(json["upgraded"]))
		if bool(json["upgraded"]) and has_method("upgrade"):
			call("upgrade")
	elif get("itemTag") == "flag":
		call("upgrade")
	if json.get("num") != null:
		set("num", int(json["num"]))
	for i in json.att.keys():
		att.set(i, json.att.get(i))	

func fromJson(json):
	#还原属性
	if json.get("level") != null:
		set("level", int(json["level"]))
	if json.get("state") != null:
		set("state", int(json["state"]))
	if json.get("num") != null:
		set("num", int(json["num"]))
	if json.get("skills") != null:
		set("skills", json["skills"])
	if json.get("ronglian") != null:
		set("ronglian", json["ronglian"])

	#还原舰载机
	if json.get("planeId") != null:
		set("planeId", json["planeId"])
		set("rare", json["rare"])
		if not has_method("refresh") and has_method("repair"):
			call("repair", get("rare"), get("planeId"))
	#还原科研图纸
	info = json["info"]
	if json.get("equipId") != null:
		# set("equipConf", json["equipConf"])
		call("repair", json["equipId"])

	# for i in json.att.keys():
	# 	att.set(i, json.att.get(i))
	
func attToJson():
	var tmp = {}
	tmp["hp"] = att.hp
	tmp["maxHp"] = att.maxHp
	tmp["atk"] = att.atk
	tmp["def"] = att.def
	tmp["atkRan"] = att.atkRan
	tmp["mgiAtk"] = att.mgiAtk
	tmp["mgiDef"] = att.mgiDef
	tmp["pen"] = att.pen
	tmp["mgiPen"] = att.mgiPen
	tmp["defL"] = att.defL
	tmp["penL"] = att.penL
	tmp["criR"] = att.criR
	tmp["defR"] = att.defR
	tmp["cri"] = att.cri
	tmp["suck"] = att.suck
	tmp["mgiSuck"] = att.mgiSuck
	tmp["reHp"] = att.reHp
	tmp["spd"] = att.spd
	tmp["cd"] = att.cd
	tmp["dod"] = att.dod
	tmp["maxHpL"] = att.maxHpL
	tmp["atkL"] = att.atkL
	tmp["mgiAtkL"] = att.mgiAtkL
	tmp["mgiDefL"] = att.mgiDefL
	tmp["mgiPenL"] = att.mgiPenL
	tmp["mgiSuck"] = att.mgiSuck
	tmp["atkR"] = att.atkR
	return tmp

func learnRndSkill():
	if masCha == null or masCha.get("tag") != "azurline":return
	var sk = skillPool.getRandomSkill(3, masCha.prefer)
	while sk.excludeChas.has(masCha.id):
		sk = skillPool.getRandomSkill(3, masCha.prefer)
	masCha.exSkillSlot.append(sk)
	sk.setCha(masCha)

func getAroundChas(cell, allys = true):
	var chas = []
	for i in aroundCells:
		var cha = masCha.matCha(cell+i)
		if cha != null && (allys && cha.team == masCha.team || not allys && cha.team != masCha.team):
			chas.append(cha)
	return chas	