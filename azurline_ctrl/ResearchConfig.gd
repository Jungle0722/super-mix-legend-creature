extends Node
func _init():
	pass

var charaData = [
	"cex___alr-chester",
	"cex___alr-drake",
	"cex___alr-azuma",
	"cex___alr-mainz",
	"cex___alr-georgia",
	"cex___alr-kitakaze",
	"cex___alr-anchorage",
	"cex___alr-hakuryu",
	"cex___alr-aijier",
]

var equipData = [
	"i_Hide_alr_120Mk11",
	"i_Hide_alr_203Mk15",
	"i_Hide_alr_203Mk9",
	"i_Hide_alr_234",
	"i_Hide_alr_406MkD",
	"i_Hide_alr_410",
	"i_Hide_alr_457",
	"i_Hide_alr_torpedoMk20",
	"i_Hide_alr_torpedo533",
	"i_Hide_alr_p_bumblebee",
	"i_Hide_alr_p_XSB3C",
	"i_Hide_alr_p_flyDragon",
	"i_Hide_alr_catapult",
	"i_Hide_alr_zaiShengArmor",
	"i_Hide_alr_millionClass",
	"i_Hide_alr_phaseSplit",
	"i_Hide_alr_nanoCloud",

]

var guideText = """
[color=#BDB76B]科研数据：[/color]
游戏中击败普通塞壬，获得3点科研数据，
击败挑战BOSS，获得30点科研数据，
击败守关BOSS，获得30点科研数据。
[color=#BDB76B]舰船研发：[/color]
花费100点科研数据，随机抽取3名科研舰娘，玩家3选1并直接获得3级的该舰娘
已获得的科研舰娘不可重复获得，兑换科研舰娘后，再次兑换所需的点数+100
[color=#BDB76B]装备研发：[/color]
花费100点科研数据，随机抽取3件科研装备，玩家3选1并直接获得该装备的图纸
将【辅料】装备放入小卖部装备栏首位，图纸放入第二位，
即可自动合成该科研装备
每次研发科研装备后，都会使下次研发费用+10
[color=#BDB76B]辅料：[/color]
任意道具，若为碧蓝航线MOD的装备，则吸收其特效(升级后的装备依然吸收其基础特效，部分装备特效效果吸收后会调整数值)及30%属性，
若为非碧蓝航线装备或无法吸收特效的装备，则吸收其50%属性，科研装备、技能书、军旗不能作为辅料
稀有装备的特效能否被吸收请留意该装备的说明文字
[color=#BDB76B]科研阵营：[/color]
如果玩家点了阵营特化天赋，那么科研船自动加入该阵营
"""