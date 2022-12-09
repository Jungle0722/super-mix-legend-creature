extends "../cex___warship/cex___warship.gd"

func _extInit():
	._extInit()
	setGunAndArmor("要塞级","超重型")
	type = "siren"
	autoGetSkill()
	setCamp("塞壬")
	canCopy = false

func sr():
	for i in buffs:
		if i.isNegetive:
			i.isDel = true

# func _onBattleEnd():
# 	._onBattleEnd()
# 	if type != "siren":return
# 	battleExp += 1
# 	if gSiren.sirenAwaken:
# 		battleExp += 1
# 		if sys.rndPer(35):
# 			battleExp += 1
# 	if gSiren.darkFood and sys.rndPer(50):
# 		battleExp += 1
# 	if lv == 4:
# 		if level < 20 and battleExp >= 5:
# 			self.levelUp()
# 			battleExp -= 6
# 	else:
# 		if battleExp >= 18:
# 			utils.evoCha(self, self.evos[0])
		
func getSkillEffect(name):
	.getSkillEffect(name)
	if name == "余烬":
		return att.atk * 0.5
	if name == "强袭":
		return att.atk * 2
	if name == "势如破竹":
		return att.atk * 1.5
	if name == "编织噩梦":
		return att.mgiAtk * 3