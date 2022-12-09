extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "[稀有]金刚钻"
	info = "使用者装备上限+1\n[color=#C0C0C0]一次性消耗品，无法对同一个角色重复使用"
	price = 0
var itemTag = "tmp"
func _connect():
	if masCha.get("jgzFlag") == true:
		delFromCha()
		return
	masCha.maxItem += 1
	masCha.jgzFlag = true
	delSelf()

	
