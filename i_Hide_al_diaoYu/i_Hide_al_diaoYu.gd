extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "[特殊]钓鱼竿"
	info = "若佩戴者存活至回合结束，则有概率钓起来一些东西\n可能钓出的产物：稀有装备、科研材料、舰载机、爱酱、潜水艇......"
	price = 200
	
func _connect():
	if masCha.id == "cex___al-merchant":
		delFromCha()
		return
	sys.main.connect("onBattleEnd",self,"onBattleEnd")
	masCha.connect("onDeath", self, "onDeath")

var flag = true

#稀有装备、舰载机、爱酱、潜水艇、普通装备、轮空
var rnds = [30, 10, 2, 1, 7, 76]
func onBattleEnd():
	if flag:
		var rnd = sys.rndRan(1, 100)
		if rnd <= rnds[0]:
			print("钓鱼成功：获得装备")
			sys.main.player.addItem(sys.newItem(utils.getRandomItem("RARE")))
		elif rnd <= rnds[0] + rnds[1]:
			print("钓鱼成功：获得舰载机")
			var item = sys.newItem("i_Hide_plane")
			item.repair(false)
			sys.main.player.addItem(item)
		elif rnd <= rnds[0] + rnds[1] + rnds[2]:
			print("钓鱼成功：获得爱酱")
			sys.main.player.addCha(sys.main.newChara("cazurlineF_5_1"))
		elif rnd <= rnds[0] + rnds[1] + rnds[2] + rnds[3]:
			print("钓鱼成功：获得潜艇")
			sys.main.player.addCha(sys.main.newChara("cazurlineF_1_2"))
		elif rnd <= rnds[0] + rnds[1] + rnds[2] + rnds[3] + rnds[4]:
			print("钓鱼成功：获得普通装备")
			sys.main.player.addItem(sys.newItem(itemData.rndPool.rndItem().id))
	flag = true		

func onDeath(atkInfo):
	if masCha.isDeath:
		flag = false
