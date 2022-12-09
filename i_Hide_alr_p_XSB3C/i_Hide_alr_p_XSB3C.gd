extends "../i_Hide_plane/i_Hide_plane.gd"
func init():
	.init()
	name = "[color=#DC143C][传说·轰炸机]实验型XSB3C-1"
	info = "技能组：\n每6秒对当前目标发起3次普攻\n每普攻10次，自身进入<狂化>状态，持续3秒\n当自身处于狂化状态时，免疫所有负面状态，暴击爆伤提高100%\n[color=#DC143C]给航母装备后消失，航母将在战斗中召唤此型号的舰载机\n"

func refresh():
	planeId = "cex___plane-XSB3C"
	