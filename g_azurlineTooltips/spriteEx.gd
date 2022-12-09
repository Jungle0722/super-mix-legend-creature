extends "res://core/sprite.gd"

var msgbox


func msgbox_init():
    msgbox = globalData.infoDs["g_azurlineTooltips"].new_msgbox()
    globalData.infoDs["g_azurlineTooltips"].calc_poistion_and_size(msgbox, self)
    msgbox.bbcode_text = masCha.getInfo()
    # topUi.add_child(msgbox)
    msgbox.visible = false
    connect("tree_exiting", msgbox, "queue_free")


func enter():
    if is_instance_valid(masCha):
        if not is_instance_valid(msgbox):
            msgbox_init()
        msgbox.bbcode_text = masCha.getInfo()
        globalData.infoDs["g_azurlineTooltips"].calc_poistion_and_size(msgbox, self)
        if msgbox.get_parent():
            msgbox.get_parent().remove_child(msgbox)
        topUi.add_child(msgbox)
        msgbox.visible = true
    .enter()
        
func exit():
    if is_instance_valid(masCha) and is_instance_valid(msgbox):
        msgbox.visible = false
    .exit()
