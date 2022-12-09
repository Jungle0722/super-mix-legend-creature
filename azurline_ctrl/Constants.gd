extends Node

func _init():
	pass

const itemsPhy=["i_azurline_203skc", "i_azurline_hkld", "i_azurline_1c", "i_azurline_381", "i_al_406MK5", "i_al_406MK6", "i_al_406Test", "i_al_380", "i_azurline_155"]
const itemsMgi=["i_azurline_1386", "i_azurline_czd", "i_azurline_113", "i_azurline_127", "i_al_127Single", "i_al_152MK17", "i_al_410Test", "i_azurline_533", "i_azurline_zhmk"]
const itemsDef=["i_azurline_glgl", "i_azurline_zzzl", "i_azurline_fylgc", "i_azurline_fuhuo", "i_azurline_battery", "i_azurline_hjmc", "i_azurline_huangyouyou", "i_azurline_vh"]
const itemsRare=["i_Hide_al_repeater", "i_Hide_al_liquidMetal", "i_Hide_al_umbrella", "i_Hide_al_nanoAlloy", "i_Hide_al_hotSteel", "i_Hide_al_100AirOil",
"i_Hide_al_fightProve", "i_Hide_al_projector", "i_Hide_al_candyBullet","i_Hide_al_mindcube", "i_Hide_al_heAmmo", "i_Hide_al_rndWord", "i_Hide_al_ddydj",
"i_Hide_al_rndEvo", "i_Hide_al_lightLance", "i_Hide_al_voodooDoll","i_Hide_al_mieHuoQi", "i_Hide_al_catPaw", "i_Hide_al_suSteelArmor", "i_Hide_al_adjustableArm",
"i_Hide_al_dmgCtrl", "i_Hide_al_awakeningPeal", "i_Hide_al_kongPao", "i_Hide_al_ring", "i_Hide_al_explorerMedal", "i_Hide_al_fi282", "i_Hide_al_gaiLiangSN",
"i_Hide_al_highMagnet", "i_Hide_al_goldFinger", "i_Hide_al_heartKey", "i_Hide_al_equipBox", "i_Hide_al_piggyBank", "i_Hide_al_98delay", "i_Hide_al_heartChains",
"i_Hide_al_ciwei", "i_Hide_al_tuoluo", "i_Hide_al_chryDart", "i_Hide_al_beacon", "i_Hide_al_repairKit", "i_Hide_al_sg", "i_Hide_al_zdj", "i_Hide_al_steering",
"i_Hide_al_jinGangZuan", "i_Hide_al_emp"
]
#特殊道具
const itemsSpecial = ["i_Hide_al_μEquip", "i_Hide_al_warriorExp", "i_Hide_al_shineSong", "i_Hide_al_hotSong", "i_Hide_al_ring", "i_Hide_al_forgetEquip",
"i_Hide_al_dice", "i_Hide_al_dragonKing"]
#药剂
const medis = ["i_Hide_alm_atk", "i_Hide_alm_mgiAtk", "i_Hide_alm_cri", "i_Hide_alm_cd", "i_Hide_alm_spd", "i_Hide_alm_def"]
const rareMedis = ["i_Hide_alm_suck", "i_Hide_alm_dod", "i_Hide_alm_pen"]	

const flags = ["i_Hide_al_flagcy", "i_Hide_al_flagz", "i_Hide_al_flagx", "i_Hide_al_flagby", "i_Hide_al_flaghj"]

var itemAll = itemsPhy + itemsMgi + itemsDef + itemsSpecial + medis + rareMedis + flags + miuEquips + itemsRare

var miuEquips = ["i_Hide_al_hotSong", "i_Hide_al_shineSong"]

#官方天赋
var officialTalents = ["t_bf_diYu", "t_bf_jiSu", "t_bf_jieShuang", "t_bf_kuangNu", "t_bf_liuXue", "t_bf_moYu", "t_bf_shaoZhuo", "t_bf_shiMing", "t_bf_zhonDu", 
"t_c_1", "t_c_2", "t_c_3", "t_c_4", "t_c_5", "t_c_6", "t_c_7", "t_c_8", "t_c_9", "t_hp", "t_jinBi", "t_jinYan", "t_s_1", "t_s_2", "t_s_3", "t_s_4", "t_s_5", "t_s_6"]

const planes = [""]
	
const buttonConfig = {
	"ptToGold": {
		"text": "购买100金币",
		"conn": "ptToGold",
	},
}

var helpText = """
[color=#BDB76B]建议反馈交流:[/color]
传奇生物官方Q群：172860952，大部分MOD作者都在此群，欢迎来反馈问题、提供建议、无聊吹水
[color=#BDB76B]难度切换:[/color]
在游戏主界面的MOD设置中，可以设置MOD难度(和原版难度设置不同)
[color=#BDB76B]PT点:[/color]
击杀敌方非召唤物单位即可获得1点PT点，用于活动商店消费，塞壬会掉落更多的PT点
[color=#BDB76B]角色图鉴:[/color]
游戏中，控制面板-传奇图鉴中，可以看到所有的舰娘及其进化树
[color=#BDB76B]传奇生物基础知识:[/color]
众所周知，传奇生物中，有有三种攻击类型：普攻、技能、特效
有三种伤害类型：物理（黄字伤害）、魔法（蓝字伤害）、真实（白字伤害）
有多种属性：攻击、法强、护甲、魔抗（这四个合称四维）等等...
角色的普攻伤害，均由攻击属性决定，普攻频率，由攻速决定
角色的技能伤害，具体参看这个技能的伤害系数由什么决定的
========================================================================================
[color=#BDB76B]技能槽系统:[/color]
3-4级舰娘均拥有[一个]空白技能槽，可学习技能书以填充此槽位，获得对应的技能
[color=#BDB76B]技能书:[/color]
敌方概率掉落，技能书中的技能从技能池中随机得来,拥有空技能槽的舰娘阅读后即可获得对应技能，阅读后消失
角色升级后，技能所学的技能
========================================================================================
[color=#BDB76B]U盘:[/color]
游戏中最重要的道具之一，请珍惜开局送你的U盘！
它能使一个角色变成另一个角色，帮助你快速合成进化
详细的使用说明请查看U盘上的文字，如果看不懂，还可以在MOD说明里面打开U盘使用教程.gif
========================================================================================
[color=#BDB76B]指挥官:[/color]
开局即赠送的指挥官单位，会在战斗中逐渐升级，属性会越来越高，还能学习随机技能
技能倾向选框决定随机技能的抽取范围
请好好珍惜上天赐予的指挥官吧！
========================================================================================
更多更详细的说明，请查看控制面板-MOD说明！
"""

const colorRed = "[color=#DC143C]"
const colorGold = "[color=#BDB76B]"
const colorGrey = "[color=#C0C0C0]"
const colorGreen = "[color=#33ff33]"

const helpUrl = "http://note.youdao.com/noteshare?id=5adfbee07531c6fc8c51b271e1cba406"

#阵营字典 key:名称，value：角色数量
var camps = {"白鹰":15,"皇家":17,"重樱":21,"铁血":11,"自由鸢尾":7,"北方联合":4,"其他":4}

var campsMerged = ["白鹰","皇家","重樱","铁血","自由鸢尾/北方联合/其他"]
#舰种字典 ， 去掉了航母
var shipType = {"驱逐":"dd","轻巡":"cl","重巡":"ca","战列":"bb","辅助":"sup", "航母":"cv"}
#难度字典
var diffDic = {1: "简单", 2:"普通", 3:"进阶", 4:"困难", 5:"极难", 6:"地狱", 7:"创世"}

#遗物舰娘
var relicChas = [
	{
		"objId":"cex___alcamp-merkuria",
		"name":"水星纪念",
	},
	{
		"objId":"cex___alcamp-sandiego",
		"name":"圣地亚哥",
	},
	{
		"objId":"cex___alcamp-zeppelin",
		"name":"齐柏林伯爵",
	},
]

var bossStep

var subMarines = ["cex___als-u372", "cazurlineF_1_1_1", "cazurlineF_1_2_1", "cazurlineF_1_3_1"]
