extends "../cazurlineF_4/cazurlineF_4.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「辅助」彩布里·Lv3"   #角色的名称
	attCoe.atkRan = 3  #攻击距离
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.mgiAtk += 1     #攻击力（每点代表8.5）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 3             #等级的设置
	evos = ["cex___al-purin2"]
	canCopy = false
	addSkill("回合开始时，20%概率将备战栏中的角色进化(有多条进化路线的角色取随机一个)", "Purin!")

	autoGetSkill()
	type = "sup"
	supportSpecEvo = 1
	setCamp("其他")
var p3 = 20
var innerCd = 0
func _onBattleStart():
	._onBattleStart()
	if innerCd > 0:
		innerCd -= 1
		return
	if sys.rndPer(p3):
		purin()

func purin():
	var chas = utils.getReadyChas()
	chas.shuffle()
	for cha in chas:
		if cha.lv == 4 or cha.evos.empty() or cha.get("tag") != "azurline":continue
		if cha.lv == 3:innerCd = 4
		var after = sys.main.newChara(sys.rndListItem(cha.evos))
		sys.main.player.addCha(after)
		cha.deleteSelf()
		omgCtrl.onEvo(after)
		print("彩布里触发进化成功：%s"%after.chaName)
		break
