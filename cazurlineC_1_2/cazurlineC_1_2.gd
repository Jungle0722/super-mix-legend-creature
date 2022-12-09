extends "../cazurlineC_1/cazurlineC_1.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「重巡」久远"   #角色的名称
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2     #攻击力（每点代表8.5）
	attCoe.def += 1
	attCoe.mgiDef += 1
	attCoe.atkRan = 5
	lv = 3             #等级的设置
	evos = ["cazurlineC_1_2_1"]
	addSkill("击杀目标后，若处于敌方半场，则后撤至我方半场并获得20层<狂怒>，若处于我方半场，\n则突进至血量最低的敌人身边对其发动鱼雷连射", "四神变换")
	ename = "jiuyuan"
	autoGetSkill()
	setCamp("其他")

func _onKillChara(atkInfo):
	._onKillChara(atkInfo)	
	if atkInfo.hitCha == self:return
	if cell.x > 4 and team == 1 or cell.x <= 4 and team == 2:
		#敌半场
		yield(reTimer(0.2),"timeout")
		chetui()
	else:
		var vs = [Vector2(0,0),Vector2(1,0),Vector2(-1,0),Vector2(0,1),Vector2(0,-1),Vector2(1,1),Vector2(-1,1),Vector2(-1,-1),Vector2(1,-1)]
		var cha = getFirstCha(1, "sortByNowHp")
		if cha != null:
			if not unlock:
				hurtChara(cha, att.atk, Chara.HurtType.PHY, Chara.AtkType.SKILL)
				return
			var mv = Vector2(cha.cell.x ,cha.cell.y)
			for i in vs:
				var v = mv+i
				if matCha(v) == null && sys.main.isMatin(v) and setCell(v):
					var pos = sys.main.map.map_to_world(cell)
					ying(pos)
					position = pos
					aiCha = cha
					gx_ylls()
					break

#撤退至我方半场
func chetui():
	for i in utils.getAllyCells(team):
		if matCha(i) == null && sys.main.isMatin(i) and setCell(i):
			var pos = sys.main.map.map_to_world(i)
			ying(pos)
			position = pos
			addBuff(buffUtil.b_kuangNu_r.new(20))
			return

