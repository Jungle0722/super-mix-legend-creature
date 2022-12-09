extends ItemBt

var msgbox
var tooltips
var utils = globalData.infoDs["g_azurlineUtils"]
func msgbox_init():
    msgbox = globalData.infoDs["g_azurlineTooltips"].new_msgbox()
    tooltips = globalData.infoDs["g_azurlineTooltips"]
    connect("tree_exiting", msgbox, "queue_free")
    topUi.add_child(msgbox)

func enter():
    if is_instance_valid(item) and not utils.osName == "Android":
        if topUi.has_node("itemMsgBox"):
            var itemMsgBox = topUi.get_node("itemMsgBox")
            itemMsgBox.visible = false
            itemMsgBox.get_parent().remove_child(itemMsgBox)
            itemMsgBox.queue_free()
        msgbox_init()
        msgbox.bbcode_text = getInfo()
        tooltips.calc_poistion_and_size(msgbox, self)
        msgbox.visible = true
    .enter()

func exit():
    if is_instance_valid(msgbox) and not utils.osName == "Android":
        msgbox.visible = false
    .exit()

func getInfo():
    var msg = sys.newMsg("itemInfoMsg")
    msg.init(item)
    var text = msg.get_node("txt").bbcode_text
    msg.queue_free()
    return text

func setCha(cha):
    if cha.team == 1 and (cha.items.size() < cha.maxItem or utils.isExtraItem(item)):
        if item.masCha != null:
            item.masCha.delItem(item)
        if cha.addItem(item):
            masCha = cha    