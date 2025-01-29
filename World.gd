extends Node2D

var SendeePersonality : String
var SendeeItem : String
var SendeeLook : CompressedTexture2D
var SendeeSpecial

var SendeeType

var GameProgress = 0
var InnocentKilled = 0
var GuiltyKilled = 0
var InnocentReleased = 0
var GuiltyReleased = 0
var InnocentSeized = 0
var GuiltySeized = 0


#takes normal, soldier and spy (future todlding, todd and more)

@export var Char1 : CompressedTexture2D
@export var Char2 : CompressedTexture2D
@export var Char3 : CompressedTexture2D
@export var Char4 : CompressedTexture2D
@export var Char5 : CompressedTexture2D
@export var Char6: CompressedTexture2D
@export var Soldier : CompressedTexture2D
@export var Spy1 : CompressedTexture2D
@export var Spy2 : CompressedTexture2D
@export var Toddling : CompressedTexture2D


@export var TCube: CompressedTexture2D
@export var TStatue: CompressedTexture2D
@export var TOreT: CompressedTexture2D
@export var TOreO: CompressedTexture2D
@export var TOreD: CompressedTexture2D
@export var Gold: CompressedTexture2D
@export var Cheese: CompressedTexture2D
@export var Bomb: CompressedTexture2D
@export var Keys: CompressedTexture2D
@export var HipFlask: CompressedTexture2D
@export var Note1: CompressedTexture2D
@export var Note2: CompressedTexture2D

@export var JOIN_US_TODAY: CompressedTexture2D
@export var TODD_NEEDS_YOU: CompressedTexture2D
@export var WINDOW_TODD: CompressedTexture2D


var ObjDict = {"T" : TCube, "S" : TStatue, "TT" :TOreT, "TO" : TOreO, "TD" : TOreD, "G" : Gold, "C" : Cheese, "B" : Bomb, "K" : Keys, "HF" : HipFlask, "N1" : Note1, "N2" : Note2}
var LookArray = [Char1, Char2, Char3, Char4, Char5, Char6, Soldier, Spy1, Spy2]

var ItemArray = ["T", "T", "S", "S", "G", "C", "B"]
var PersonalityArray = ["Normal", "Stupid", "Murica", "Spy"]
var TypeArray = ["Normal", "Normal","Soldier", "Spy"]

var CharLoad = preload("res://Charachter.tscn")
var SHIFTOVER = preload("res://SHIFTOVER.tscn")
var Obj = preload("res://Object.tscn")
var Todd = preload("res://todd.tscn")
var Ts : int = 0
var Os : int = 0
var Ds : int = 0



func Send():
	
	#if Ts >= 1 and Os >= 1 and Ds >= 2:
	if true:
		print("ITS TODDIN TIME BOYS")
		var TODD = Todd.instantiate()
		TODD.position.y = -40
		add_child(TODD)
		$"Props/Static-needs-tunsten".texture = TODD_NEEDS_YOU
		$"Props/Sell-today".texture = JOIN_US_TODAY
		$"Props/Window".texture = WINDOW_TODD
		$AudioStreamPlayer.pitch_scale = 0.2
		
		return
	
	
	GameProgress += 1
	if GameProgress == 6:
		TypeArray = ["Normal", "Spy","ToddlingT", "ToddlingO", "ToddlingD"]
	if  Os > 1:
		TypeArray = ["Normal", "Spy","ToddlingT", "ToddlingD"]
	if  Ts > 1:
		TypeArray = ["Normal", "Spy", "ToddlingO", "ToddlingD"]
	if Ts > 1 and Os > 1:
		TypeArray = ["Normal", "Spy", "ToddlingD"]
	if GameProgress <= 25:
		SendeeType = TypeArray[randi_range(0, len(TypeArray ) - 1)]
		if SendeeType == "Normal":
			print("normal")
			SendeeLook = LookArray[randi_range(0, 5)]
			SendeeItem = ItemArray[randi_range(0, 5)]
			SendeePersonality = PersonalityArray[randi_range(0, 2)]
		if SendeeType == "Soldier":
			SendeeLook = Soldier
			SendeeItem = ItemArray[randi_range(0, 2)]
			SendeePersonality = "Murica"
		if SendeeType == "Spy":
			SendeeLook = LookArray[randi_range(6, 8)]
			SendeeItem = ItemArray[randi_range(6, 6)]
			SendeePersonality = PersonalityArray[randi_range(3, 3)]
		if SendeeType == "ToddlingT":
			SendeeLook = Toddling
			SendeeItem = "TT"
			print(SendeeItem)
			SendeePersonality = "Toddling"
		if SendeeType == "ToddlingO":
			SendeeLook = Toddling
			SendeeItem = "TO"
			print(SendeeItem)
			SendeePersonality = "Toddling"
		if SendeeType == "ToddlingD":
			SendeeLook = Toddling
			SendeeItem = "TD"
			print(SendeeItem)
			SendeePersonality = "Toddling"
		var Sendee = CharLoad.instantiate()
		Sendee.Personality = SendeePersonality
		Sendee.Item = SendeeItem
		Sendee.Look = SendeeLook
		Sendee.position.y = -50
		Sendee.position.x = -100
		add_child(Sendee)
		print(SendeeType)
		print(SendeeItem)
		print(SendeePersonality)
	else:
		Endgame()
		return
	
	
func Endgame():
	var ShiftOver = SHIFTOVER.instantiate()
	ShiftOver.GuiltyKilled = GuiltyKilled
	ShiftOver.GuiltyReleased = GuiltyReleased
	ShiftOver.InnocentReleased = InnocentReleased
	ShiftOver.InnocentKilled = InnocentKilled
	ShiftOver.GuiltySeized = GuiltySeized
	ShiftOver.InnocentSeized = InnocentSeized
	add_child(ShiftOver)	

func SpawnObj(Item):
	var object = Obj.instantiate()
	var CorrectObj
	ObjDict = {"T" : TCube, "S" : TStatue, "TT" :TOreT, "TO" : TOreO, "TD" : TOreD, "G" : Gold, "C" : Cheese, "B" : Bomb, "K" : Keys, "HF" : HipFlask, "N1" : Note1, "N2" : Note2}
	
	if Item == "TT":
		Ts += 1
		print("Ts : " + str(Ts), "Os : " + str(Os), "Ds : " + str(Ds))
	if Item == "TO":
		Os += 1
		print("Ts : " + str(Ts), "Os : " + str(Os), "Ds : " + str(Ds))
	if Item == "TD":
		Ds += 1
		print("Ts : " + str(Ts), "Os : " + str(Os), "Ds : " + str(Ds))
	
	if Item != "Cheese" and Item != "Gold":
		InnocentSeized += 1
	else:
		GuiltySeized += 1
	
	
	CorrectObj = ObjDict[Item]
	object.position.x = 0
	object.position.y = 0
	print(Item)
	object.ObjSprite = CorrectObj
	add_child(object)

func killed(Item, Personality):
	if Item == "C" or Item == "B" or Personality == "Spy":
		GuiltyKilled += 1
	else:
		InnocentKilled += 1
		
func released(Item, Personality):
	if Item == "C" or Item == "B" or Personality == "Spy":
		GuiltyReleased += 1
	else:
		InnocentReleased += 1
	
func _ready():
	LookArray = [Char1, Char2, Char3, Char4, Char5, Char6, Soldier, Spy1, Spy2]
	ItemArray = ["T", "T", "S", "S", "G", "C", "B"]
	PersonalityArray = ["Normal", "Stupid", "Murica", "Spy"]
	SendeeType = "Normal"
	Send()
	
