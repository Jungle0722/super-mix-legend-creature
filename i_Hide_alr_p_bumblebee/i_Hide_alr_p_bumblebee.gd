extends "../i_Hide_plane/i_Hide_plane.gd"
func init():
	.init()
	name = "[color=#DC143C][传说·战斗机]海大黄蜂"
	info = "技能组：\n每6秒尝试向血量最低的敌方单位发起突击\n每次突进后嘲讽周围2格的敌人，并获得50%减伤\n每次受到非特效伤害，赋予攻击者2层<剧毒>\n受到的暴击伤害降低50%\n[color=#DC143C]给航母装备后消失，航母将在战斗中召唤此型号的舰载机\n"

func refresh():
	planeId = "cex___plane-Bumblebee"