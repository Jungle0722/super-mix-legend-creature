extends ImgBtn

var utils = globalData.infoDs["g_azurlineUtils"]
var talent:Talent = null
var state = 0
onready  var anim = $AnimationPlayer
var talentSelMsgScript = load(self.get_script().get_path().get_base_dir() + "/azurTalentSelMsg.gd")
var tw = Tween.new()
func _ready():
	add_child(tw)
	connect("onPressed", self, "_on_item_pressed")
	
func dianHide():$Sprite.hide()
func dianShow():$Sprite.show()

var w = 1.5
func enter():
	tw.interpolate_property(self, "rect_scale", Vector2(1, 1), Vector2(w, w), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tw.start()

func exit():
	tw.interpolate_property(self, "rect_scale", Vector2(w, w), Vector2(1, 1), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tw.start()

func init(talent = null):
	if talent != null:
		self.talent = talent
		setImg()
		setStage(2)

func xueXi(talent):
	self.talent = talent
	setImg()
	setStage(2)
	sys.main.player.addTalent(talent)

func setImg():
	if talentData.infoDs[talent.id].dir.left(8) != "res://ex":
			var im = Image.new()
			im.load("%s/%s/ico.png" % [talentData.infoDs[talent.id].dir, talent.id])
			var imt = ImageTexture.new()
			imt.flags = 4
			imt.create_from_image(im)
			texture = imt
			
	else :texture = load("res://ex/talent/%s/ico.png" % talent.id)

func _on_item_pressed():
	if state == 1:
		var msg = sys.newMsg("talentSelMsg")
		utils.changeScript(msg, talentSelMsgScript)
		msg.init(self)
	elif state == 2 and talent != null:
		var infos = "[color=#4080c6]%s[/color]" % talent.info
		for i in config.bfDir.keys():
			infos = infos.replace("%s" % i, "[color=#ffff55][url={id}]{id}[/url][/color]".format({id = i}))
		sys.newBaseMsg(tr(talent.name) + ("(lv:%d)" % [talent.lv + 1]), infos)
	elif state == 0:
		sys.newBaseMsg("提示", "提升等级后才能学习")
		
func setStage(val):
	state = val
	if anim != null:anim.play("idle")
	if state == 0:
		texture = load("ui/talentBtn/0.png")
	elif state == 1:
		texture = load("ui/talentBtn/1.png")
		anim.play("jia")
		
