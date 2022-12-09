var Path

func _init():
	call_deferred("DotaProcess_Init")
	pass

func DotaProcess_Init():
	Path = chaData.infoDs["cDotaYm"].dir
	print("Dota系列Mod：已加载完成")


# Effect Process:
func Effect_CreateAoe(Name:String, Position:Vector2, Deviation:Vector2 = Vector2(0,0), Frame = 15, Scale = 1, Repeat = false):
	var Direct = Path + "/eff/" + Name
	var Effect = sys.newEff("animEff", Position)
	Effect.setImgs(Direct, Frame, Repeat)
	Effect.normalSpr.position = Deviation
	Effect.scale *= Scale
	return Effect

func Effect_CreateToPos(Name:String, StartPosition:Vector2, AimPosition:Vector2, FlySpeed = 800, Deviation:Vector2 = Vector2(0,0), Frame = 0, Scale = 1, Repeat = true):
	var Direct = Path + "/eff/" + Name
	var Effect = sys.newEff("animEff", StartPosition)
	Effect.setImgs(Direct, Frame, Repeat)
	Effect.normalSpr.position = Deviation
	Effect.scale *= Scale
	Effect._initFlyPos(AimPosition,FlySpeed)
	return Effect

func Effect_CreateToCha(Name:String, StartPosition:Vector2, Aim:Chara, FlySpeed = 800, Deviation:Vector2 = Vector2(0,0), Frame = 0, Scale = 1, Repeat = true):
	var Direct = Path + "/eff/" + Name
	var Effect = sys.newEff("animEff", StartPosition)
	Effect.setImgs(Direct, Frame, Repeat)
	Effect.normalSpr.position = Deviation
	Effect.scale *= Scale
	Effect._initFlyCha(Aim,FlySpeed)
	return Effect


func Effect_CreateEffText(EffectID, Contents, Position, Colors = "#FFFFFF"):
	var EffectText = sys.newEff(EffectID,Position)
	EffectText.setText(Contents,Colors)
	return EffectText


# Sort:
class Sort:
	var CompareObject

	func _init(Chara=null):
		CompareObject = Chara
	
	func Sort_Farest(a,b):
		if CompareObject.cellRan(a.cell, CompareObject.cellRan) > CompareObject.cellRan(b.cell, CompareObject.cellRan):
			return true
		return false

	func Sort_Nearest(a,b):
		if CompareObject.cellRan(a.cell, CompareObject.cellRan) < CompareObject.cellRan(b.cell, CompareObject.cellRan):
			return true
		return false
	
	static func Sort_Atk(a,b):
		if a.att.atk > b.att.atk:
			return true
		return false
	
	static func Sort_Threat(a,b):
		if a.att.atk + a.att.mgiAtk > b.att.atk + b.att.mgiAtk:
			true
		false


# Create UI:
func UI_CreateButton(Target, Callback, ButtonText, Position):
	var BaseButton = Button.new()
	BaseButton.text = ButtonText
	BaseButton.rect_position = Position
	BaseButton.connect("pressed",Target,Callback)
	sys.main.get_node("ui").add_child(BaseButton)
	return BaseButton

func UI_CreateTextureButton(Target, Callback, RectPosition, ImageName,  Size = Vector2(24,24), StrechMode = 3):
	var TextureButtonObject = TextureButton.new()
	TextureButtonObject.set_size(Size)
	TextureButtonObject.rect_position = RectPosition
	TextureButtonObject.set_strech_mode(StrechMode)
	var ButtonImageTexture = Image_LoadImgTexture(ImageName)
	TextureButtonObject.texture_normal = ButtonImageTexture
	TextureButtonObject.connect("pressed",Target,Callback)
	sys.main.get_node("ui").add_child(TextureButtonObject)
	return TextureButtonObject

func UI_NewBaseMassage(Title,Massage):
	sys.newBaseMsg(Title,Massage)

func UI_CreateLayerText(Txt,Position):
	var LayerText = Label.new()
	LayerText.text = Txt
	LayerText.rect_position = Position
	LayerText.align = 1
	sys.main.get_node("ui").add_child(LayerText)
	LayerText.visible=true
	return LayerText


# Create Image
func Image_LoadImgTexture(ImageName):
	var ImageObject = Image.new()
	var ImageTextureObject = ImageTexture.new()
	ImageObject.load(Path + "/img/" + ImageName)
	ImageTextureObject.create_from_image(ImageObject)
	return ImageTextureObject

func Image_BackGroundChange(ImageName):
	sys.main.get_node("scene/bg/bg").set_texture(Image_LoadImgTexture(ImageName))

func Image_CharaImageChange(ImageName,Chara):
	var Direct = Path + "/Other/" + ImageName
	var ImageObject = Image.new()
	var ImageTextureObject = ImageTexture.new()
	ImageObject.load(Direct)
	ImageTextureObject.create_from_image(ImageObject)
	Chara.img.texture_normal = ImageTextureObject