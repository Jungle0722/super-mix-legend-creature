extends "res://ui/msgBase/msgBase.gd"

var btn = null
onready  var grid = $ScrollContainer / GridContainer

func _ready():
	pass
	
func init(btn):
	for i in talentData.infos:
		if sys.main.player.talentDs.has(i.id) == false and i.id.find("_al_") > -1:
			var bt = preload("res://ui/talentSelMsg/item.tscn").instance()
			bt.init(i.id)
			grid.add_child(bt)
			bt.connect("onXuexi", self, "runXuexi")
	self.btn = btn
	popup()
	
func initTupu():
	for i in talentData.infos:
		var bt = preload("res://ui/talentSelMsg/item.tscn").instance()
		bt.initTupu(i.id)
		
		grid.add_child(bt)
		bt.connect("onXuexi", self, "upLv")
	self.btn = btn
	$Label.show()
	upP()
	talentData.connect("changeP", self, "upP")
	popup()

func runXuexi(talent):
	btn.xueXi(talent)
	queue_free()

func upLv(talent):
	sys.newMsg("talentLvMsg").init(talent)
	
func upP():
	$Label.text = "魂：%d" % talentData.p
