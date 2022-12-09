extends Reference
class_name AzurAtt

signal onChange(id)

var hp setget set_hp, get_hp
var maxHp setget set_maxHp, get_maxHp
var atk setget set_atk, get_atk
var def setget set_def, get_def
var atkRan setget set_atkRan, get_atkRan
var mgiAtk setget set_mgiAtk, get_mgiAtk
var mgiDef setget set_mgiDef, get_mgiDef
var pen setget set_pen, get_pen
var mgiPen setget set_mgiPen, get_mgiPen

var cri setget set_cri, get_cri
var criR setget set_criR, get_criR
var suck setget set_suck, get_suck
var mgiSuck setget set_mgiSuck, get_mgiSuck
var reHp setget set_reHp, get_reHp
var spd setget set_spd, get_spd
var cd setget set_cd, get_cd
var dod setget set_dod, get_dod
var reHpM setget set_reHpM, get_reHpM
var atkR setget set_atkR, get_atkR
var defR setget set_defR, get_defR

var maxHpL setget set_maxHpL, get_maxHpL
var atkL setget set_atkL, get_atkL
var defL setget set_defL, get_defL
var mgiAtkL setget set_mgiAtkL, get_mgiAtkL
var mgiDefL setget set_mgiDefL, get_mgiDefL
var penL setget set_penL, get_penL
var mgiPenL setget set_mgiPenL, get_mgiPenL

var info = {
	"hp":-1.0, 
	"maxHp":-1.0, 
	"atk":-1.0, 
	"def":-1.0, 
	"mgiAtk":-1.0, 
	"mgiDef":-1.0, 
	"pen":-1.0, 
	"mgiPen":-1.0, 
	"cri":-1.0, 
	"criR":-1.0, 
	"suck":-1.0, 
	"mgiSuck":-1.0, 
	"reHp":-1.0, 
	"spd":-1.0, 
	"cd":-1.0, 
	"dod":-1.0, 
	"reHpM":-1.0, 
	"atkR":-1.0, 
	"defR":-1.0, 
	"maxHpL":-1.0, 
	"atkL":-1.0, 
	"defL":-1.0, 
	"mgiAtkL":-1.0, 
	"mgiDefL":-1.0, 
	"penL":-1.0, 
	"mgiPenL":-1.0, 
	"atkRan":-1.0
}

var minLimit = {
	"hp":0, 
	"maxHp":0, 
	"atk":0, 
	"def":0, 
	"mgiAtk":0, 
	"mgiDef":0, 
	"pen":-99999, 
	"mgiPen":-99999, 
	"cri":0, 
	"criR":-1.0, 
	"suck":-1.0, 
	"mgiSuck":-1.0, 
	"reHp":-1.0, 
	"spd":-0.8, 
	"cd":-0.8, 
	"dod":0, 
	"reHpM":-1.0, 
	"atkR":-1, 
	"defR":-999999, 
	"maxHpL":-1.0, 
	"atkL":-1.0, 
	"defL":-1.0, 
	"mgiAtkL":-1.0, 
	"mgiDefL":-1.0, 
	"penL":-1.0, 
	"mgiPenL":-1.0, 
	"atkRan":-30
}

func getList():
	return info.values()

func plus(at):
	for i in range(config.attKeys.size()):
		var key = config.attKeys[i]
		info[key] += at.info[key]

func sub(at):
	for i in range(config.attKeys.size()):
		var key = config.attKeys[i]
		info[key] -= at.info[key]
	
func clear():
	for i in range(config.attKeys.size()):
		var key = config.attKeys[i]
		info[key] = 0.0
	
func inc(at1, at2):
	for i in range(config.attKeys.size()):
		var key = config.attKeys[i]
		info[key] = at1.info[key] * at2.info[key]
	
func inc2(at1, at2, pel):
	for i in range(config.attKeys.size()):
		var key = config.attKeys[i]
		info[key] = at1.info[key] * at2.info[key] * pel
		
func setInfo(id, val):
	info[id] = val
	emit_signal("onChange", id)

func set_hp(val):
	info["hp"] = val;
func get_hp():
	return info["hp"]
func set_maxHp(val):
	info["maxHp"] = val;emit_signal("onChange", "hp")
func get_maxHp():
	return info["maxHp"]
func set_atk(val):
	info["atk"] = val;emit_signal("onChange", "atk")
func get_atk():
	return info["atk"]
func set_atkRan(val):
	info["atkRan"] = val;emit_signal("onChange", "atkRan")
func get_atkRan():
	return info["atkRan"]
func set_def(val):
	info["def"] = val;emit_signal("onChange", "def")
func get_def():
	return info["def"]
func set_mgiAtk(val):
	info["mgiAtk"] = val;emit_signal("onChange", "mgiAtk")
func get_mgiAtk():
	return info["mgiAtk"]
func set_mgiDef(val):
	info["mgiDef"] = val;emit_signal("onChange", "mgiDef")
func get_mgiDef():
	return info["mgiDef"]
func set_pen(val):
	info["pen"] = val;emit_signal("onChange", "pen")
func get_pen():
	return info["pen"]
func set_mgiPen(val):
	info["mgiPen"] = val;emit_signal("onChange", "mgiPen")
func get_mgiPen():
	return info["mgiPen"]
func set_cri(val):
	info["cri"] = val;emit_signal("onChange", "cri")
func get_cri():
	return info["cri"]
func set_criR(val):
	info["criR"] = val;emit_signal("onChange", "criR")
func get_criR():
	return info["criR"]
func set_suck(val):
	info["suck"] = val;emit_signal("onChange", "suck")
func get_suck():
	return info["suck"]
func set_mgiSuck(val):
	info["mgiSuck"] = val;emit_signal("onChange", "mgiSuck")
func get_mgiSuck():
	return info["mgiSuck"]
func set_reHp(val):
	info["reHp"] = val;emit_signal("onChange", "reHp")
func get_reHp():
	return info["reHp"]
func set_spd(val):
	info["spd"] = val;emit_signal("onChange", "spd")
func get_spd():
	return info["spd"]
func set_cd(val):
	info["cd"] = val;emit_signal("onChange", "cd")
func get_cd():
	return info["cd"]
func set_dod(val):
	info["dod"] = val;emit_signal("onChange", "dod")
func get_dod():
	return info["dod"]
func set_reHpM(val):
	info["reHpM"] = val;emit_signal("onChange", "reHpM")
func get_reHpM():
	return info["reHpM"]
func set_atkR(val):
	info["atkR"] = val;emit_signal("onChange", "atkR")
func get_atkR():
	return info["atkR"]
func set_defR(val):
	info["defR"] = val;emit_signal("onChange", "defR")
func get_defR():
	return info["defR"]
func set_maxHpL(val):
	info["maxHpL"] = val;emit_signal("onChange", "maxHpL")
func get_maxHpL():
	return info["maxHpL"]
func set_atkL(val):
	info["atkL"] = val;emit_signal("onChange", "atkL")
func get_atkL():
	return info["atkL"]
func set_defL(val):
	info["defL"] = val;emit_signal("onChange", "defL")
func get_defL():
	return info["defL"]
func set_mgiAtkL(val):
	info["mgiAtkL"] = val;emit_signal("onChange", "mgiAtkL")
func get_mgiAtkL():
	return info["mgiAtkL"]
func set_mgiDefL(val):
	info["mgiDefL"] = val;emit_signal("onChange", "mgiDefL")
func get_mgiDefL():
	return info["mgiDefL"]
func set_penL(val):
	info["penL"] = val;emit_signal("onChange", "penL")
func get_penL():
	return info["penL"]
func set_mgiPenL(val):
	info["mgiPenL"] = val;emit_signal("onChange", "mgiPenL")
func get_mgiPenL():
	return info["mgiPenL"]
