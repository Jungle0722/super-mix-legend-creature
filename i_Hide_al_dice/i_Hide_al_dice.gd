extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "[稀有]赌神的骰子"
	info = "本局游戏中，每购买一次彩票，暴击伤害提高20%(上限400%)\n来源：成就奖励"
	price = 100
	att.criR = 1
	att.cri = 0.2
	
func buyLottery():
	if att.criR < 4:
		att.criR += 0.2

func _connect():
	azurCtrl.connect("buyLottery", self, "buyLottery")
