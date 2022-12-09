extends "../i_Hide_plane/i_Hide_plane.gd"
func init():
	.init()
	name = "[color=#DC143C][传说·鱼雷机]飞龙"
	info = "技能组：\n每6秒获得8层<魔力>，并使自身所有技能的冷却时间降低0.5秒\n每5秒，向随机3名敌人发射航空鱼雷，分别对直线上的敌人造成[双攻*0.1]的真实伤害，并附带5层漏水\n任意友军单位死亡，均会提高20点法强及2%冷却速度\n[color=#DC143C]给航母装备后消失，航母将在战斗中召唤此型号的舰载机\n"

func refresh():
	planeId = "cex___plane-FlyDragon"
