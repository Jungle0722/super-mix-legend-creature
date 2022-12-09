extends "res://ui/msgBaseX/msgBaseX.gd"

onready  var txt = $Panel / RichTextLabel

func _ready():
	pass

func init(win = true):
	var sbs = ""
	if win:
		$Panel / Label.text = "通关！"
	else :
		$Panel / Label.text = "失败！"
		if sys.main.player.hp > 0:
			sbs = tr("队伍全灭！")
		else :sbs = tr("玩家生命值为0！！")
	
	txt.bbcode_text = sbs
	
	txt.bbcode_text += """
	{jinjieLvT}：{jinJieLv}
	[color=#b87850]{lvT}： {lv}
	{sresT}：{sres}
	{shpT}:{shp}
	{skaT}：{ska}
	{sbT}：{sb}[/color]
	
	[color=#ffe762]{ssT}：{ss}
	
	{sgT}：{ss}[/color]
	"""
	var lv = sys.main.guankaMsg.lvStep - 2
	var sres = getSs()
	if sres > (sys.main.batLLv + 1) * 250:
		sres = 0
	var ska = lv * 10
	var sb = sys.main.batLLv * 100
	var shp = sys.main.player.hp * 2
	if sys.main.player.hp > 100:
		shp = 0
	var ss = (sres + ska + sb + shp) * (1 + jinJieData.nowLv * 0.3)
	if lv < 1:ss = 0
	if ss > (sys.main.batLLv + 1) * 3000:ss = 0
	ss = int(ss)
	
	sys.main.isEnd = true
	talentData.plus(ss)
	talentData.saveInfo()
	
	var dic = {
		lv = lv, 
		shp = shp, 
		sres = sres, 
		ska = ska, 
		sb = sb, 
		ss = ss, 
		jinJieLv = jinJieData.nowLv, 
		jinjieLvT = tr("难度等级"), 
		lvT = tr("你占领层数"), 
		sresT = tr("资源得分"), 
		shpT = tr("剩余生命得分"), 
		skaT = tr("关卡得分"), 
		sbT = tr("BOSS战得分"), 
		ssT = tr("难度等级修正总分"), 
		sgT = tr("获得魂值"), 
	}
	
	txt.bbcode_text = txt.bbcode_text.format(dic)
	if sys.godotSteam != null:sys.godotSteam.upScore(ss)

	if win:
		if jinJieData.upLv():
			sys.newBaseMsg("信息", "解锁新的进阶等级成功！")
			
		if sys.isDemo:
			sys.newBaseMsg("信息", "试玩版只能到达这里！")
	popup()

func _on_Button_pressed():
	queue_free()
	pass

func getSs():
	var s = 0
	var p = 3
	var g = sys.main.player.gold / 67
	var cs = [1, 3, 9, 27]
	for i in sys.main.btGrid.get_children():
		var cha:Chara = i.get_child(0)
		s += cs[cha.lv - 1] * p
	for i in sys.main.map.get_children():
		if i is Chara and i != null and i.team == 1:
			s += cs[i.lv - 1] * p
	
	for i in sys.main.player.items:
		s += 3 * p
		
	s += g * p
	return int(s)

func _on_Button2_pressed():
	queue_free()
	if sys.main != null:
		sys.main.exit()
	pass
