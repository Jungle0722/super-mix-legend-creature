extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "U盘"
	att.atk = 60
	att.mgiAtk = 60
	num = 0
	price = 200
	text = "会记录初次装备者(记为A)，当被装备到另一个生物身上时(记为B)，将B转化为A，拷贝后重置\n[color=#DC143C]只能进行同级拷贝，双方均在场下方能生效，最多拷贝6次，对传奇单位无效，对限定舰娘无效[/color]\n当前拷贝者：[color=#DC143C]{0}[/color]，拷贝次数：{1}\n[color=#C0C0C0]Made By 碧蓝航线港区实验室"
	info = text.format({"0":"无", "1":num})
	
var text = "会记录初次装备者(记为A)，当被装备到另一个生物身上时(记为B)，将B转化为A，拷贝后重置\n[color=#DC143C]只能进行同级拷贝，双方均在场下方能生效，最多拷贝6次，对传奇单位无效，对限定舰娘无效[/color]\n当前拷贝者：[color=#DC143C]{0}[/color]，拷贝次数：{1}\n[color=#C0C0C0]Made By 碧蓝航线港区实验室"

func _connect():
	if utils.inBattle(masCha) || masCha.lv == 4 || masCha.get("type") == "npc":return
	if masCha.id == "cex___al-merchant":
		delFromCha()
		return

	if data == null and masCha.get("canCopy") != false:
		data = masCha
		info = text.format({"0":data.chaName, "1":num})	

	if data != null and not is_instance_valid(data):
		data = null
		info = text.format({"0":"无", "1":num})	

	if data != null && data.id != masCha.id && data.lv == masCha.lv :
		# delFromCha()
		var cha = utils.evoCha(masCha, data.id)
		sys.main.player.subGold(15)
		data = null
		masCha = null
		num += 1
		info = text.format({"0":"无", "1":num})	
	if num >= 6:
		sys.main.player.delItem(self)

func clearData():
	data = null
	info = text.format({"0":"无", "1":num})
	
var data = null
var num = 0

