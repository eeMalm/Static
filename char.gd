extends Node2D
class_name Charachter
enum {DATA, TYPE, REFERENCE}

@export var Name : String
@export var Personality : String = "Normal"
# Personality takes "Normal Stupid Murica and Spy"
@export var Item : String = "T"
@export var Look : CompressedTexture2D


#Extra S-list
var ExtraItems  = [null]
var SINDEX : int = 0

var readyToTalk = false
var readyToWalk = false
var happy = false

var Segment = "START"
var SegmentIndex = 0
const Segments = ["START", "MID1", "MID2", "MID3", "END"]

var Dialogueing = false

var Target

var Agression = 0

var DialogueBox = preload("res://Dialogue.tscn")

@export var CurrentReferences = {
	
	#list of current references, whenever sommething contains a reference, the next query can be directly routed to a reference, does not reset
	
	"I" : null,
	"C" : null,
	"Q" : null,
	"S" : null,
	"G" : null,
	"K" : null,
}
#valid Segments are START, MID1, MID2, MID3, END, and SPECIAL
#all types are composed of tag (Q, I or C) and then segment. If they are a cont, they are counted as Null 
#an exception is made for CISTART which is for agrresive chat

#"NDT1Q6": {DATA: "",TYPE: "QSTART", REFERENCE: {"Q" : "NDT1Q14", "I" : "NDT1I14"}},

var Database = {
	"NormalDialogueT" : {
		"S": {DATA: "Out of order",TYPE: "S", REFERENCE: null},
		"SNUll" : {DATA: "Dude can I  have my tungsten back?",TYPE: "S", REFERENCE: {"S" : "SNULL", "G" : "GNULL"}},
		"GNULL" : {DATA: "Dude you cant just send me in there without an item.",TYPE: "G", REFERENCE: null},
		"null": {DATA: ". . .",TYPE: null, REFERENCE: null},
		"NDTQ0": {DATA: "I bought this tungsten cube at an auction 10 years ago. It is very high quality.",TYPE: "QSTART", REFERENCE: null},
		"NDTQ1": {DATA: "My mother has owned a tungsten cube for a long time. But I don't really need it anymore, so I thought I should help STATIC.",TYPE: "QSTART", REFERENCE: null},
		
		"NDTQ2": {DATA: "What will i do with the money? Well, I'll use it to buy a new boat.",TYPE: "QMID1", REFERENCE: null},
		"NDTQ3": {DATA: "What will i do with the money? It's going to my savings, bad econmic times you know.",TYPE: "QMID1", REFERENCE: null},
		"NDTQ4": {DATA: "What will i do with the money? Im buying stocks buddy.",TYPE: "QMID1", REFERENCE: null},
		"NDTQ5": {DATA: "What will i do with the money? I'm gonna use it to pay off my mothers mortgage. If i get enough for the tungsten.",TYPE: "QMID1", REFERENCE: null},
		
		"NDTQ6": {DATA: "Am i all clear then?",TYPE: "Q", REFERENCE: {"Q" : "NDTQ6"}},
		
		"NDTQ7": {DATA: "Where I'm from? I drove 12 hours here from Georgia.",TYPE: "QMID2", REFERENCE: null},
		"NDTQ8": {DATA: "Where I'm from? I drove 4 hours here from Oregon.",TYPE: "QMID2", REFERENCE: null},
		
		"NDTQ9": {DATA: "What do you mean alterior motive, why would I have that?",TYPE: "QMID3", REFERENCE: null},
		
		"NDTI0": {DATA: "I assure you sir ... IM A MODEL CITIZEN I just want to contribute to STATIC.",TYPE: "I", REFERENCE: {"I" : "NDTI0"}},
		"NDTI1": {DATA: "I ... I ... Dont understand, i just want to hand in my cube.",TYPE: "I", REFERENCE: {"I" : "NDTI1"}},
		"NDTI2": {DATA: "Nothing strange here Sir",TYPE: "I", REFERENCE: {"I" : "NDTI2"}},
		
		"NDC0" : {DATA: "Im in town to sell this cube, pretty long trip, i think it will be worth it though.",TYPE: "C", REFERENCE: {"C" : "NDC1"}},
		"NDC1" : {DATA: "Yeah, times are tough you know, but Im doing alright.",TYPE: null, REFERENCE: {"C" : "NDC2"}},
		"NDC2" : {DATA: "Did you hear about what the Russians are getting up to, crazy stuff happening over there.",TYPE: null, REFERENCE: {"C" : "NDC3"}},
		"NDC3" : {DATA: "But i love this American demoracy, we stand alone for justice in a world of chaos.",TYPE: null, REFERENCE: {"C" : "NDC3"}},
		
		"NDC4" : {DATA: "STATIC really is quite nice, brutal exterior but for a business it's quite alright.",TYPE: "C", REFERENCE: {"C" : "NDC5"}},
		"NDC5" : {DATA: "Thank you for asking really, I'm ok. My wife is sick and i hope this check can help me pay the medical fees.",TYPE: null, REFERENCE: {"C" : "NDC6"}},
		"NDC6" : {DATA: "No, shes's not terminal but, it could get worse, you never know with radiation.",TYPE: null, REFERENCE: {"C" : "NDC7"}},
		"NDC7" : {DATA: "Thank you for asking, i better get going now, shouldnt be holding up the line.",TYPE: null, REFERENCE: {"C" : "NDC7"}},
		
		"NDC8" : {DATA: "Im doing good, you?",TYPE: "C", REFERENCE: {"C" : "NDC9"}},
		"NDC9" : {DATA: "Crazy world out there aint it? You know last week I saw something really strange.",TYPE: null, REFERENCE: {"C" : "NDC10"}},
		"NDC10" : {DATA: "An airship, no markings but clearly a battleship.",TYPE: null, REFERENCE: {"C" : "NDC11"}},
		"NDC11" : {DATA: "Must've been Russian, but what the bloody hell was it doing in Georgia",TYPE: null, REFERENCE: {"C" : "NDC12"}},
		"NDC12" : {DATA: "Im pleased to contibuite to STATIC's efforts.",TYPE: null, REFERENCE: {"C" : "NDC13"}},
		"NDC13" : {DATA: "Have a great day",TYPE: null, REFERENCE: {"C" : "NDC13"}},
		
		"NDC14" : {DATA: "I ... I'm alright, just wanna go and sell my tungsten...",TYPE: "CI", REFERENCE: {"C" : "NDC15"}},
		"NDC15" : {DATA: ". . .",TYPE: null, REFERENCE: {"C" : "NDC16"}},
		"NDC16" : {DATA: "You cracy bastard, why are you trying to make smalltalk after threatening my life.",TYPE: null, REFERENCE: {"C" : "NDC17"}},
		"NDC17" : {DATA: ". . .",TYPE: null, REFERENCE: {"C" : "NDC17"}},
		
		"NDC18" : {DATA: "No security questions, just jumping straight to small talk?",TYPE: "CSTART", REFERENCE: {"C" : "NDC19"}},
		"NDC19" : {DATA: "Well i guess im clear?",TYPE: null, REFERENCE: {"C" : "NDC19"}},
		
		
	},
	"NormalDialogueS" : {
		"null": {DATA: ". . .",TYPE: null, REFERENCE: null},
		"SNUll" : {DATA: "Sir may I  have my tungsten statue back?",TYPE: "S", REFERENCE: {"S" : "SNULL", "G" : "GNULL"}},
		"GNULL" : {DATA: "You can't send me in there without an item. What do i tell them?",TYPE: "G", REFERENCE: null},
		"NDSQ0": {DATA: "I bought this item at a garage sale 4 years ago. I love it dearly.",TYPE: "QSTART", REFERENCE: null},
		"NDSQ1": {DATA: "My  grandmother had this tungsten for a long time. But as an american citizen it feels like my duty to hand this in.",TYPE: "QSTART", REFERENCE: null},
		
		"NDSQ2": {DATA: "What will i do with the money? Well, I'll use it to buy a new boat.",TYPE: "QMID1", REFERENCE: null},
		"NDSQ3": {DATA: "What will i do with the money? It's going to my savings, bad econmic times you know.",TYPE: "QMID1", REFERENCE: null},
		"NDSQ4": {DATA: "What will i do with the money? Im buying stocks buddy.",TYPE: "QMID1", REFERENCE: null},
		"NDSQ5": {DATA: "What will i do with the money? I'm gonna use it to pay off my mothers mortgage. If i get enough for the tungsten.",TYPE: "QMID1", REFERENCE: null},
		
		"NDSQ6": {DATA: "Am i all clear then?",TYPE: "Q", REFERENCE: {"Q" : "NDTQ6"}},
		
		"NDSQ7": {DATA: "Where I'm from? I drove 11 hours here from Ohio.",TYPE: "QMID2", REFERENCE: null},
		"NDSQ8": {DATA: "Where I'm from? I drove 3 hours here from New York.",TYPE: "QMID2", REFERENCE: null},
		
		"NDSQ9": {DATA: "What do you mean alterior motive, why would I have that?",TYPE: "QMID3", REFERENCE: null},
		
		"NDSI0": {DATA: "I assure you sir ... IM A MODEL CITIZEN I just want to contribute to STATIC.",TYPE: "I", REFERENCE: {"I" : "NDSI0"}},
		"NDSI1": {DATA: "I ... I ... Dont understand, i just want to hand in tungsten, is it bad that isnt a cube?",TYPE: "I", REFERENCE: {"I" : "NDSI1"}},
		"NDSI2": {DATA: "Nothing strange here Sir",TYPE: "I", REFERENCE: {"I" : "NDSI2"}},
		
		"NDC0" : {DATA: "Im in town to sell this thing, pretty long trip, i think it will be worth it though.",TYPE: "C", REFERENCE: {"C" : "NDC1"}},
		"NDC1" : {DATA: "Yeah, times are tough you know, but Im doing alright.",TYPE: null, REFERENCE: {"C" : "NDC2"}},
		"NDC2" : {DATA: "Did you hear about what the Russians are getting up to, crazy stuff happening over there.",TYPE: null, REFERENCE: {"C" : "NDC3"}},
		"NDC3" : {DATA: "But i love this American demoracy, we stand alone for justice in a world of chaos.",TYPE: null, REFERENCE: {"C" : "NDC3"}},
		
		"NDC4" : {DATA: "STATIC really is quite nice, brutal exterior but for a business it's quite alright.",TYPE: "C", REFERENCE: {"C" : "NDC5"}},
		"NDC5" : {DATA: "Thank you for asking really, I'm ok. My wife is sick and i hope this check can help me pay the medical fees.",TYPE: null, REFERENCE: {"C" : "NDC6"}},
		"NDC6" : {DATA: "No, shes's not terminal but, it could get worse, you never know with radiation.",TYPE: null, REFERENCE: {"C" : "NDC7"}},
		"NDC7" : {DATA: "Thank you for asking, i better get going now, shouldnt be holding up the line.",TYPE: null, REFERENCE: {"C" : "NDC7"}},
		
		"NDC8" : {DATA: "Im doing good, you?",TYPE: "C", REFERENCE: {"C" : "NDC9"}},
		"NDC9" : {DATA: "Crazy world out there aint it? You know last week I saw something really strange.",TYPE: null, REFERENCE: {"C" : "NDC10"}},
		"NDC10" : {DATA: "An airship, no markings but clearly a battleship.",TYPE: null, REFERENCE: {"C" : "NDC11"}},
		"NDC11" : {DATA: "Must've been Russian, but what the bloody hell was it doing in Georgia",TYPE: null, REFERENCE: {"C" : "NDC12"}},
		"NDC12" : {DATA: "Im pleased to contibuite to STATIC's efforts.",TYPE: null, REFERENCE: {"C" : "NDC13"}},
		"NDC13" : {DATA: "Have a great day",TYPE: null, REFERENCE: {"C" : "NDC13"}},
		
		"NDC14" : {DATA: "I ... I'm alright, just wanna go and sell my tungsten...",TYPE: "CI", REFERENCE: {"C" : "NDC15"}},
		"NDC15" : {DATA: ". . .",TYPE: null, REFERENCE: {"C" : "NDC16"}},
		"NDC16" : {DATA: "You cracy bastard, why are you trying to make smalltalk after threatening my life.",TYPE: null, REFERENCE: {"C" : "NDC17"}},
		"NDC17" : {DATA: ". . .",TYPE: null, REFERENCE: {"C" : "NDC17"}},
		
		"NDC18" : {DATA: "No security questions, just jumping straight to small talk?",TYPE: "CSTART", REFERENCE: {"C" : "NDC19"}},
		"NDC19" : {DATA: "Well i guess im clear?",TYPE: null, REFERENCE: {"C" : "NDC19"}},
	},
	"NormalDialogueG" : {
		"null": {DATA: ". . .",TYPE: null, REFERENCE: null},
		"SNUll" : {DATA: "Like I said, its gold, now can you let me go?",TYPE: "S", REFERENCE: {"S" : "SNULL", "G" : "GNULL"}},
		"GNULL" : {DATA: "You can't send me in there without an item man. What do i tell them?",TYPE: "G", REFERENCE: null},
		"NDGQ0": {DATA: "I know i shouldnt exactly bring this but i thought you could use it anyway, it's actually gold.",TYPE: "QSTART", REFERENCE: null},
		"NDGQ1": {DATA: "I havent exactly brought tungsten, but this is more valuable anyway.",TYPE: "QSTART", REFERENCE: null},
		
		"NDGQ2": {DATA: "What will i do with the money? Well, I'll use it to buy a new boat.",TYPE: "QMID1", REFERENCE: null},
		"NDGQ3": {DATA: "What will i do with the money? It's going to my savings, bad econmic times you know.",TYPE: "QMID1", REFERENCE: null},
		"NDGQ4": {DATA: "What will i do with the money? Im buying stocks buddy.",TYPE: "QMID1", REFERENCE: null},
		"NDGQ5": {DATA: "What will i do with the money? I'm gonna use it to pay off my mothers mortgage. If i get enough for the tungsten.",TYPE: "QMID1", REFERENCE: null},
		
		"NDGQ6": {DATA: "Am i all clear then?",TYPE: "Q", REFERENCE: {"Q" : "NDTQ6"}},
		
		"NDGQ7": {DATA: "Where I'm from? I drove 11 hours here from Ohio.",TYPE: "QMID2", REFERENCE: null},
		"NDGQ8": {DATA: "Where I'm from? I drove 3 hours here from New York.",TYPE: "QMID2", REFERENCE: null},
		
		"NDGQ9": {DATA: "What do you mean alterior motive, why would I have that?",TYPE: "QMID3", REFERENCE: null},
		
		"NDGI0": {DATA: "I assure you sir ... IM A MODEL CITIZEN I just want to contribute to STATIC.",TYPE: "I", REFERENCE: {"I" : "NDGI0"}},
		"NDGI1": {DATA: "I ... I ... Dont understand, i just want to hand in my cube, I mean it's not what you wanted exactly but I just wanted to help.",TYPE: "I", REFERENCE: {"I" : "NDGI1"}},
		"NDGI2": {DATA: "Nothing strange here Sir",TYPE: "I", REFERENCE: {"I" : "NDGI2"}},
		
		"NDC0" : {DATA: "Im in town to sell this thing, pretty long trip, i think it will be worth it though.",TYPE: "C", REFERENCE: {"C" : "NDC1"}},
		"NDC1" : {DATA: "Yeah, times are tough you know, but Im doing alright.",TYPE: null, REFERENCE: {"C" : "NDC2"}},
		"NDC2" : {DATA: "Did you hear about what the Russians are getting up to, crazy stuff happening over there.",TYPE: null, REFERENCE: {"C" : "NDC3"}},
		"NDC3" : {DATA: "But i love this American demoracy, we stand alone for justice in a world of chaos.",TYPE: null, REFERENCE: {"C" : "NDC3"}},
		
		"NDC4" : {DATA: "STATIC really is quite nice, brutal exterior but for a business it's quite alright.",TYPE: "C", REFERENCE: {"C" : "NDC5"}},
		"NDC5" : {DATA: "Thank you for asking really, I'm ok. My wife is sick and i hope this check can help me pay the medical fees.",TYPE: null, REFERENCE: {"C" : "NDC6"}},
		"NDC6" : {DATA: "No, shes's not terminal but, it could get worse, you never know with radiation.",TYPE: null, REFERENCE: {"C" : "NDC7"}},
		"NDC7" : {DATA: "Thank you for asking, i better get going now, shouldnt be holding up the line.",TYPE: null, REFERENCE: {"C" : "NDC7"}},
		
		"NDC8" : {DATA: "Im doing good, you?",TYPE: "C", REFERENCE: {"C" : "NDC9"}},
		"NDC9" : {DATA: "Crazy world out there aint it? You know last week I saw something really strange.",TYPE: null, REFERENCE: {"C" : "NDC10"}},
		"NDC10" : {DATA: "An airship, no markings but clearly a battleship.",TYPE: null, REFERENCE: {"C" : "NDC11"}},
		"NDC11" : {DATA: "Must've been Russian, but what the bloody hell was it doing in Georgia",TYPE: null, REFERENCE: {"C" : "NDC12"}},
		"NDC12" : {DATA: "Im pleased to contibuite to STATIC's efforts.",TYPE: null, REFERENCE: {"C" : "NDC13"}},
		"NDC13" : {DATA: "Have a great day",TYPE: null, REFERENCE: {"C" : "NDC13"}},
		
		"NDC14" : {DATA: "I ... I'm alright, just wanna go and sell my gold man...",TYPE: "CI", REFERENCE: {"C" : "NDC15"}},
		"NDC15" : {DATA: ". . .",TYPE: null, REFERENCE: {"C" : "NDC16"}},
		"NDC16" : {DATA: "You cracy bastard, why are you trying to make smalltalk after threatening my life.",TYPE: null, REFERENCE: {"C" : "NDC17"}},
		"NDC17" : {DATA: ". . .",TYPE: null, REFERENCE: {"C" : "NDC17"}},
		
		"NDC18" : {DATA: "No security questions, just jumping straight to small talk?",TYPE: "CSTART", REFERENCE: {"C" : "NDC19"}},
		"NDC19" : {DATA: "Well i guess im clear?",TYPE: null, REFERENCE: {"C" : "NDC19"}},
	},
	"NormalDialogueC" : {
		"null": {DATA: ". . .",TYPE: null, REFERENCE: null},
		"SNUll" : {DATA: "Sir, i swear this wasn't intentional, I meant to bring you gold!",TYPE: "S", REFERENCE: {"S" : "SNULL", "G" : "GNULL", "K" : "KNULL"}},
		"GNULL" : {DATA: "Oh, youre letting me through. Thank you very much man!",TYPE: "G", REFERENCE: null},
		"KNULL" : {DATA: "I HAVE A FAMILY, PLEASE DONT, I NEED THIS",TYPE: "G", REFERENCE: null},
		"NDGQ0": {DATA: "I know i shouldnt exactly bring this but i thought you could use it anyway, it's actually gold.",TYPE: "QSTART", REFERENCE: null},
		"NDGQ1": {DATA: "I havent exactly brought tungsten, but this is more valuable anyway.",TYPE: "QSTART", REFERENCE: null},
		
		"NDGQ2": {DATA: "What will i do with the money? Well, I'll use it to buy a new boat.",TYPE: "QMID1", REFERENCE: null},
		"NDGQ3": {DATA: "What will i do with the money? It's going to my savings, bad econmic times you know.",TYPE: "QMID1", REFERENCE: null},
		"NDGQ4": {DATA: "What will i do with the money? Im buying stocks buddy.",TYPE: "QMID1", REFERENCE: null},
		"NDGQ5": {DATA: "What will i do with the money? I'm gonna use it to pay off my mothers mortgage. If i get enough for the tungsten.",TYPE: "QMID1", REFERENCE: null},
		
		"NDGQ6": {DATA: "Am i all clear then?",TYPE: "Q", REFERENCE: {"Q" : "NDTQ6"}},
		
		"NDGQ7": {DATA: "Where I'm from? I drove 11 hours here from Ohio.",TYPE: "QMID2", REFERENCE: null},
		"NDGQ8": {DATA: "Where I'm from? I drove 3 hours here from New York.",TYPE: "QMID2", REFERENCE: null},
		
		"NDGQ9": {DATA: "What do you mean alterior motive, why would I have that?",TYPE: "QMID3", REFERENCE: null},
		
		"NDGI0": {DATA: "I assure you sir ... IM A MODEL CITIZEN I just want to contribute to STATIC.",TYPE: "I", REFERENCE: {"I" : "NDGI0"}},
		"NDGI1": {DATA: "I ... I ... Dont understand, i just want to hand in my cube, I mean it's not what you wanted exactly but I just wanted to help.",TYPE: "I", REFERENCE: {"I" : "NDGI1"}},
		"NDGI2": {DATA: "Nothing strange here Sir",TYPE: "I", REFERENCE: {"I" : "NDGI2"}},
		
		"NDC0" : {DATA: "Im in town to sell this thing, pretty long trip, i think it will be worth it though.",TYPE: "C", REFERENCE: {"C" : "NDC1"}},
		"NDC1" : {DATA: "Yeah, times are tough you know, but Im doing alright.",TYPE: null, REFERENCE: {"C" : "NDC2"}},
		"NDC2" : {DATA: "Did you hear about what the Russians are getting up to, crazy stuff happening over there.",TYPE: null, REFERENCE: {"C" : "NDC3"}},
		"NDC3" : {DATA: "But i love this American demoracy, we stand alone for justice in a world of chaos.",TYPE: null, REFERENCE: {"C" : "NDC3"}},
		
		"NDC4" : {DATA: "STATIC really is quite nice, brutal exterior but for a business it's quite alright.",TYPE: "C", REFERENCE: {"C" : "NDC5"}},
		"NDC5" : {DATA: "Thank you for asking really, I'm ok. My wife is sick and i hope this check can help me pay the medical fees.",TYPE: null, REFERENCE: {"C" : "NDC6"}},
		"NDC6" : {DATA: "No, shes's not terminal but, it could get worse, you never know with radiation.",TYPE: null, REFERENCE: {"C" : "NDC7"}},
		"NDC7" : {DATA: "Thank you for asking, i better get going now, shouldnt be holding up the line.",TYPE: null, REFERENCE: {"C" : "NDC7"}},
		
		"NDC8" : {DATA: "Im doing good, you?",TYPE: "C", REFERENCE: {"C" : "NDC9"}},
		"NDC9" : {DATA: "Crazy world out there aint it? You know last week I saw something really strange.",TYPE: null, REFERENCE: {"C" : "NDC10"}},
		"NDC10" : {DATA: "An airship, no markings but clearly a battleship.",TYPE: null, REFERENCE: {"C" : "NDC11"}},
		"NDC11" : {DATA: "Must've been Russian, but what the bloody hell was it doing in Georgia",TYPE: null, REFERENCE: {"C" : "NDC12"}},
		"NDC12" : {DATA: "Im pleased to contibuite to STATIC's efforts.",TYPE: null, REFERENCE: {"C" : "NDC13"}},
		"NDC13" : {DATA: "Have a great day",TYPE: null, REFERENCE: {"C" : "NDC13"}},
		
		"NDC14" : {DATA: "I ... I'm alright, just wanna go and sell my gold man...",TYPE: "CI", REFERENCE: {"C" : "NDC15"}},
		"NDC15" : {DATA: ". . .",TYPE: null, REFERENCE: {"C" : "NDC16"}},
		"NDC16" : {DATA: "You cracy bastard, why are you trying to make smalltalk after threatening my life.",TYPE: null, REFERENCE: {"C" : "NDC17"}},
		"NDC17" : {DATA: ". . .",TYPE: null, REFERENCE: {"C" : "NDC17"}},
		
		"NDC18" : {DATA: "No security questions, just jumping straight to small talk?",TYPE: "CSTART", REFERENCE: {"C" : "NDC19"}},
		"NDC19" : {DATA: "Well i guess im clear?",TYPE: null, REFERENCE: {"C" : "NDC19"}},
	},
	"NormalDialogueB" : {
		"null": {DATA: ". . .",TYPE: null, REFERENCE: null},
		"NDGQ0": {DATA: "I think its tungsten but im not completly sure what it is but i was just told to bring this.",TYPE: "QSTART", REFERENCE: null},
		"NDGQ1": {DATA: "I Tungsten delivery Sir.",TYPE: "QSTART", REFERENCE: null},
		
		"NDGQ2": {DATA: "What will i do with the money? Well, my friend who gave this ti me is getting most of it.",TYPE: "QMID1", REFERENCE: null},
		"NDGQ3": {DATA: "What will i do with the money? It's going to my savings, bad econmic times you know.",TYPE: "QMID1", REFERENCE: null},
		"NDGQ4": {DATA: "What will i do with the money? Im buying bitcoin man.",TYPE: "QMID1", REFERENCE: null},
		"NDGQ5": {DATA: "What will i do with the money? I'm gonna use it to pay off my mothers mortgage. If i get enough for this ... object.",TYPE: "QMID1", REFERENCE: null},
		
		"NDGQ6": {DATA: "Am i all clear then?",TYPE: "Q", REFERENCE: {"Q" : "NDTQ6"}},
		
		"NDGQ7": {DATA: "Where I'm from? I live in town.",TYPE: "QMID2", REFERENCE: null},
		"NDGQ8": {DATA: "Where I'm from? I here visiting my friend who lives here.",TYPE: "QMID2", REFERENCE: null},
		
		"NDGQ9": {DATA: "Uhhhh... Alterior motive? I dont think so.",TYPE: "QMID3", REFERENCE: null},
		
		"NDGI0": {DATA: "Someone just told me to bring this, Im not guilty!",TYPE: "I", REFERENCE: {"I" : "NDGI0"}},
		"NDGI2": {DATA: "Nothing to see here.",TYPE: "I", REFERENCE: {"I" : "NDGI2"}},
		
		"NDC0" : {DATA: "Im in town to sell this thing, my buddy said I could get half if i handed it in for him.",TYPE: "C", REFERENCE: {"C" : "NDC1"}},
		"NDC1" : {DATA: "Yeah, times are tough you know, but Im doing alright.",TYPE: null, REFERENCE: {"C" : "NDC2"}},
		"NDC2" : {DATA: "Did you hear about what the Russians are getting up to, crazy stuff happening over there.",TYPE: null, REFERENCE: {"C" : "NDC3"}},
		"NDC3" : {DATA: "Yeah my friend is Russian but he loves America, just as much as i do.",TYPE: null, REFERENCE: {"C" : "NDC3"}},
		
		"NDC4" : {DATA: "STATIC really is quite nice, brutal exterior but for a business it's quite alright.",TYPE: "C", REFERENCE: {"C" : "NDC5"}},
		"NDC5" : {DATA: "Thank you for asking really, I'm ok. My wife is sick and i hope this thing can help me pay the medical fees.",TYPE: null, REFERENCE: {"C" : "NDC6"}},
		"NDC6" : {DATA: "No, shes's not terminal but, it could get worse, you never know with radiation.",TYPE: null, REFERENCE: {"C" : "NDC7"}},
		"NDC7" : {DATA: "Thank you for asking, I better get going now, shouldnt be holding up the line.",TYPE: null, REFERENCE: {"C" : "NDC7"}},
		
		"NDC8" : {DATA: "Im doing good, you?",TYPE: "C", REFERENCE: {"C" : "NDC9"}},
		"NDC9" : {DATA: "Crazy world out there aint it? You know last week I saw something really strange.",TYPE: null, REFERENCE: {"C" : "NDC10"}},
		"NDC10" : {DATA: "An airship, no markings but clearly a battleship.",TYPE: null, REFERENCE: {"C" : "NDC11"}},
		"NDC11" : {DATA: "Must've been Russian, but what the bloody hell was it doing in Georgia",TYPE: null, REFERENCE: {"C" : "NDC12"}},
		"NDC12" : {DATA: "Im pleased to contibuite to STATIC's efforts.",TYPE: null, REFERENCE: {"C" : "NDC13"}},
		"NDC13" : {DATA: "Have a great day",TYPE: null, REFERENCE: {"C" : "NDC13"}},
		
		"NDC14" : {DATA: "I ... I'm alright, just wanna sell this thing, i need the money...",TYPE: "CI", REFERENCE: {"C" : "NDC15"}},
		"NDC15" : {DATA: ". . .",TYPE: null, REFERENCE: {"C" : "NDC16"}},
		"NDC16" : {DATA: "You cracy bastard, why are you trying to make smalltalk after threatening my life.",TYPE: null, REFERENCE: {"C" : "NDC17"}},
		"NDC17" : {DATA: ". . .",TYPE: null, REFERENCE: {"C" : "NDC17"}},
		
		"NDC18" : {DATA: "No security questions, just jumping straight to small talk?",TYPE: "CSTART", REFERENCE: {"C" : "NDC19"}},
		"NDC19" : {DATA: "Well i guess im clear?",TYPE: null, REFERENCE: {"C" : "NDC19"}},
	}, 
	"StupidDialogueT" : {
		
		"null": {DATA: ". . .",TYPE: null, REFERENCE: null},
		"SNUll" : {DATA: "Like I said buddy, its tungsten, now let me go!",TYPE: "S", REFERENCE: {"S" : "SNULL", "G" : "GNULL"}},
		"GNULL" : {DATA: "You can't send me in there without an item man. What the hell do you want me to tell them?",TYPE: "G", REFERENCE: null},
		"SDTQ0": {DATA: "One tungsten cube coming right up, sir.",TYPE: "QSTART", REFERENCE: null},
		"SDTQ1": {DATA: "Yeah its a goddam cube, what do you expect.",TYPE: "QSTART", REFERENCE: null},
		
		"SDTQ3": {DATA: "Well, cant tell you too much but lets just say I'm spending the money on 'refereshments'.",TYPE: "QMID1", REFERENCE: null},
		"SDTQ4": {DATA: "I aint got no idea what imma spend this money on but I sure will be rich.",TYPE: "QMID1", REFERENCE: null},
		"SDTQ5": {DATA: "Oh Mr. Questionface just relax, i aint no crook.",TYPE: "QMID1", REFERENCE: null},
		
		"SDTQ6": {DATA: "Just here to sell my cube mister.",TYPE: "QMID1", REFERENCE: null},
		"SDTQ7": {DATA: "You think I'm a spy, hell no. I eat russians for breakfeast.",TYPE: "QMID1", REFERENCE: null},
		
		"SDTQ8": {DATA: "This is stupid, just let me through.",TYPE: "Q", REFERENCE: null},
		
		"SDTI0": {DATA: "My my, clunky threats buddy, I aint got a wife.",TYPE: "I", REFERENCE: null},
		"SDTI1": {DATA: "Take it chill Bad Cop, im a good guy.",TYPE: "I", REFERENCE: null},
		"SDTI2": {DATA: "Why's this gotta be so serious. Im no spy goddamit, just let me sell my goddam cube.",TYPE: "I", REFERENCE: null},
		
		"SDC0": {DATA: "You know all these people here seem so tense, whats everyone worried about.",TYPE: "C", REFERENCE: {"C" : "SDC1"}},
		"SDC1": {DATA: "Outside too, everyone is scared half to death of these russians, they aint even met a real russian.",TYPE: null, REFERENCE: {"C" : "SDC2"}},
		"SDC2": {DATA: "Im a firm believer that untill something is proven to be a big deal, you shouldnt care about it.",TYPE: null, REFERENCE: {"C" : "SDC3"}},
		"SDC3": {DATA: "Well, thats just what I think, now let me go get my money.",TYPE: null, REFERENCE: {"C" : "SDC3"}},
		
		"SDC4": {DATA: "This place is creepy man.",TYPE: "C", REFERENCE: {"C" : "SDC5"}},
		"SDC5": {DATA: "It's like the walls surrond you on all sides.",TYPE: null, REFERENCE: {"C" : "SDC6"}},
		"SDC6": {DATA: "And they watch you, like theres men sitting on the other side waiting to take you.",TYPE: null, REFERENCE: {"C" : "SDC7"}},
		"SDC7": {DATA: "Almost like the russians have it.",TYPE: null, REFERENCE: {"C" : "SDC8"}},
		"SDC8": {DATA: "...",TYPE: null, REFERENCE: {"C" : "SDC8"}},
		
		"SDC9": {DATA: "I aint making smalltalk with you.",TYPE: "CI", REFERENCE: {"C" : "SDC9"}},
	},
	"StupidDialogueS" : {
		"null": {DATA: ". . .",TYPE: null, REFERENCE: null},
		"SNUll" : {DATA: "Like I said buddy, its real tungsten, now let me go!",TYPE: "S", REFERENCE: {"S" : "SNULL", "G" : "GNULL"}},
		"GNULL" : {DATA: "You can't send me in there without an item man. What the hell do you want me to tell them?",TYPE: "G", REFERENCE: null},
		"SDSQ0": {DATA: "I found this thingy at my grandma's and thought it counted as Tungsten.",TYPE: "QSTART", REFERENCE: null},
		"SDSQ1": {DATA: "Well its tungsten, cant really call it a cube but its not that precise anyway right?",TYPE: "QSTART", REFERENCE: null},
		
		"SDSQ3": {DATA: "Well, cant tell you too much but lets just say I'm spending the money on 'refereshments'.",TYPE: "QMID1", REFERENCE: null},
		"SDSQ4": {DATA: "I aint got no idea what imma spend this money on but I sure will be rich.",TYPE: "QMID1", REFERENCE: null},
		
		"SDSQ5": {DATA: "Oh Mr. Questionface just relax, i aint no crook.",TYPE: "Q", REFERENCE: null},
		
		"SDSQ6": {DATA: "Just here to sell my cube mister.",TYPE: "QMID2", REFERENCE: null},
		"SDSQ7": {DATA: "You think I'm a spy, hell no. I eat russians for breakfeast.",TYPE: "QMID2", REFERENCE: null},
		
		
		"SDSQ8": {DATA: "This is stupid, just let me through.",TYPE: "Q", REFERENCE: null},
		
		"SDSI0": {DATA: "My my, clunky threats buddy, I aint got a wife.",TYPE: "I", REFERENCE: null},
		"SDSI1": {DATA: "Oh whats the big fuss bossman, it's tungsten, just let me through and we can all go home.",TYPE: "I", REFERENCE: null},
		"SDSI2": {DATA: "Come up with some better threats next time. This a democrazy, you cant do things like that.",TYPE: "I", REFERENCE: null},
		"SDSI3": {DATA: "Oh, shut up.",TYPE: "I", REFERENCE: null},
		
		"SDC0": {DATA: "You know all these people here seem so tense, whats everyone worried about.",TYPE: "C", REFERENCE: {"C" : "SDC1"}},
		"SDC1": {DATA: "Outside too, everyone is scared half to death of these russians, they aint even met a real russian.",TYPE: null, REFERENCE: {"C" : "SDC2"}},
		"SDC2": {DATA: "Im a firm believer that untill something is proven to be a big deal, you shouldnt care about it.",TYPE: null, REFERENCE: {"C" : "SDC3"}},
		"SDC3": {DATA: "Well, thats just what I think, now let me go get my money.",TYPE: null, REFERENCE: {"C" : "SDC3"}},
		
		"SDC4": {DATA: "This place is creepy man.",TYPE: "C", REFERENCE: {"C" : "SDC5"}},
		"SDC5": {DATA: "It's like the walls surrond you on all sides.",TYPE: null, REFERENCE: {"C" : "SDC6"}},
		"SDC6": {DATA: "And they watch you, like theres men sitting on the other side waiting to take you.",TYPE: null, REFERENCE: {"C" : "SDC7"}},
		"SDC7": {DATA: "Almost like the russians have it.",TYPE: null, REFERENCE: {"C" : "SDC8"}},
		"SDC8": {DATA: "...",TYPE: null, REFERENCE: {"C" : "SDC8"}},
		
		"SDC9": {DATA: "I aint making smalltalk with you.",TYPE: "CI", REFERENCE: {"C" : "SDC9"}},
	},
	"StupidDialogueG" : {
		"SNUll" : {DATA: "Like I said buddy, it's gold, now let me go!",TYPE: "S", REFERENCE: {"S" : "SNULL", "G" : "GNULL"}},
		"GNULL" : {DATA: "You can't send me in there without my gold man. What the hell do you want me to tell them?",TYPE: "G", REFERENCE: null},
		"null": {DATA: ". . .",TYPE: null, REFERENCE: null},
		"SDSQ0": {DATA: "I heard on the news you want metals and such. Found this gold, at ... AN UNDISCLOSED LOCATION, how much you think i can get for this?",TYPE: "QSTART", REFERENCE: null},
		"SDSQ1": {DATA: "Was supposed to give you some tungsten but golds basically the same right? Cant be that different, one rare meral or another.",TYPE: "QSTART", REFERENCE: null},
		"SDSQ2": {DATA: "Just let me through, Im sure the guys in there will understand, what does it matter to you anyway?",TYPE: "QSTART", REFERENCE: null},
		
		"SDSQ3": {DATA: "Well, cant tell you too much but lets just say I'm spending the money on 'refereshments'.",TYPE: "QMID1", REFERENCE: null},
		"SDSQ4": {DATA: "I aint got no idea what imma spend this money on but I sure will be rich.",TYPE: "QMID1", REFERENCE: null},
		
		"SDSQ5": {DATA: "Oh Mr. Questionface just relax, i aint no crook.",TYPE: "Q", REFERENCE: null},
		
		"SDSQ6": {DATA: "Just here to sell my cube mister.",TYPE: "QMID2", REFERENCE: null},
		"SDSQ7": {DATA: "You think I'm a spy, hell no. I eat russians for breakfeast.",TYPE: "QMID2", REFERENCE: null},
		
		
		"SDSQ8": {DATA: "This is stupid, just let me through.",TYPE: "Q", REFERENCE: null},
		
		"SDSI0": {DATA: "My my, clunky threats buddy, I aint got a wife.",TYPE: "I", REFERENCE: null},
		"SDSI1": {DATA: "Hey, my bad for bringing the wrong metal, dont make it cool for you to speak like that.",TYPE: "I", REFERENCE: null},
		"SDSI2": {DATA: "You cant do that buddy, this is a democrazy.",TYPE: "I", REFERENCE: null},
		"SDSI3": {DATA: "I've got rights, this America.",TYPE: "I", REFERENCE: null},
		
		"SDC0": {DATA: "You know all these people here seem so tense, whats everyone worried about.",TYPE: "C", REFERENCE: {"C" : "SDC1"}},
		"SDC1": {DATA: "Outside too, everyone is scared half to death of these russians, they aint even met a real russian.",TYPE: null, REFERENCE: {"C" : "SDC2"}},
		"SDC2": {DATA: "Im a firm believer that untill something is proven to be a big deal, you shouldnt care about it.",TYPE: null, REFERENCE: {"C" : "SDC3"}},
		"SDC3": {DATA: "Well, thats just what I think, now let me go get my money.",TYPE: null, REFERENCE: {"C" : "SDC3"}},
		
		"SDC4": {DATA: "This place is creepy man.",TYPE: "C", REFERENCE: {"C" : "SDC5"}},
		"SDC5": {DATA: "It's like the walls surrond you on all sides.",TYPE: null, REFERENCE: {"C" : "SDC6"}},
		"SDC6": {DATA: "And they watch you, like theres men sitting on the other side waiting to take you.",TYPE: null, REFERENCE: {"C" : "SDC7"}},
		"SDC7": {DATA: "Almost like the russians have it.",TYPE: null, REFERENCE: {"C" : "SDC8"}},
		"SDC8": {DATA: "...",TYPE: null, REFERENCE: {"C" : "SDC8"}},
		
		"SDC9": {DATA: "I aint making smalltalk with you.",TYPE: "CI", REFERENCE: {"C" : "SDC9"}},
	},
	"StupidDialogueC" : {
		"SNUll" : {DATA: "Like I said buddy, it's totally real gold, for sure, 100% now let me go!",TYPE: "S", REFERENCE: {"S" : "SNULL", "G" : "GNULL", "K" : "KNULL"}},
		"GNULL" : {DATA: "Oh thank you very much sir.",TYPE: "G", REFERENCE: null},
		"KNULL" : {DATA: "OK IM SORRY IM SORRY, I MISTOOK MY CHEESE FOR GOLD, PLEASE DONT KILL ME",TYPE: "G", REFERENCE: null},
		"null": {DATA: ". . .",TYPE: null, REFERENCE: null},
		"SDSQ0": {DATA: "I heard on the news you want metals and such. Found this ... gold, at ... AN UNDISCLOSED LOCATION, how much you think i can get for this?",TYPE: "QSTART", REFERENCE: null},
		"SDSQ1": {DATA: "Was supposed to give you some tungsten but gold is like basically the same right? Cant be that different, one rare meral or another...",TYPE: "QSTART", REFERENCE: null},
		"SDSQ2": {DATA: "Just let me through, Im sure the guys in there will understand dude, what does it matter to you anyway?",TYPE: "QSTART", REFERENCE: null},
		
		"SDSQ3": {DATA: "Well, cant tell you too much but lets just say I'm spending the money on 'refereshments'.",TYPE: "QMID1", REFERENCE: null},
		"SDSQ4": {DATA: "I aint got no idea what imma spend this money on but I sure will be rich buddy.",TYPE: "QMID1", REFERENCE: null},
		
		"SDSQ5": {DATA: "Oh Mr. Questionface just relax, i aint no crook.",TYPE: "Q", REFERENCE: null},
		
		"SDSQ6": {DATA: "Just here to sell my cube mister...",TYPE: "QMID2", REFERENCE: null},
		"SDSQ7": {DATA: "You think I'm a spy, hell no. I eat goddam russians for breakfeast.",TYPE: "QMID2", REFERENCE: null},
		
		
		"SDSQ8": {DATA: "This is stupid, just let me through.",TYPE: "Q", REFERENCE: null},
		
		"SDSI0": {DATA: "My my, clunky threats buddy, I aint got a wife.",TYPE: "I", REFERENCE: null},
		"SDSI1": {DATA: "Hey, my bad for bringing the wrong metal, dont make it cool for you to speak like that.",TYPE: "I", REFERENCE: null},
		"SDSI2": {DATA: "You cant do that buddy, this is a democrazy.",TYPE: "I", REFERENCE: null},
		"SDSI3": {DATA: "I've got rights, this America.",TYPE: "I", REFERENCE: null},
		
		"SDC0": {DATA: "You know all these people here seem so tense, whats everyone worried about.",TYPE: "C", REFERENCE: {"C" : "SDC1"}},
		"SDC1": {DATA: "Outside too, everyone is scared half to death of these russians, they aint even met a real russian.",TYPE: null, REFERENCE: {"C" : "SDC2"}},
		"SDC2": {DATA: "Im a firm believer that untill something is proven to be a big deal, you shouldnt care about it.",TYPE: null, REFERENCE: {"C" : "SDC3"}},
		"SDC3": {DATA: "Well, thats just what I think, now let me go get my money.",TYPE: null, REFERENCE: {"C" : "SDC3"}},
		
		"SDC4": {DATA: "This place is creepy man.",TYPE: "C", REFERENCE: {"C" : "SDC5"}},
		"SDC5": {DATA: "It's like the walls surrond you on all sides.",TYPE: null, REFERENCE: {"C" : "SDC6"}},
		"SDC6": {DATA: "And they watch you, like theres men sitting on the other side waiting to take you.",TYPE: null, REFERENCE: {"C" : "SDC7"}},
		"SDC7": {DATA: "Almost like the russians have it.",TYPE: null, REFERENCE: {"C" : "SDC8"}},
		"SDC8": {DATA: "...",TYPE: null, REFERENCE: {"C" : "SDC8"}},
		
		"SDC9": {DATA: "I aint making smalltalk with you man.",TYPE: "CI", REFERENCE: {"C" : "SDC9"}},
	},
	"StupidDialogueB" : {
		"null": {DATA: ". . .",TYPE: null, REFERENCE: null},
		"SDSQ0": {DATA: "Dont really know what this is but i reckon its got some tungsten in it.",TYPE: "QSTART", REFERENCE: null},
		"SDSQ1": {DATA: "Found this on the street, i think this is good enough.",TYPE: "QSTART", REFERENCE: null},
		"SDSQ2": {DATA: "Just let me through, Im sure the guys in there will understand dude, what does it matter to you anyway?",TYPE: "QSTART", REFERENCE: null},
		
		"SDSQ3": {DATA: "Just wanna get rid of this thingy and thought i could earn a buck..",TYPE: "QMID1", REFERENCE: null},
		"SDSQ4": {DATA: "I aint got no idea what imma spend this money on but I sure will be rich buddy.",TYPE: "QMID1", REFERENCE: null},
		
		"SDSQ5": {DATA: "Oh Mr. Questionface just relax, i aint no crook.",TYPE: "Q", REFERENCE: {"I" : "SDSI2"}},
		
		"SDSQ6": {DATA: "Just here to sell my cube mister...",TYPE: "QMID2", REFERENCE: null},
		"SDSQ7": {DATA: "You think I'm a spy, hell no. I eat goddam russians for breakfeast. I swear ...",TYPE: "QMID2", REFERENCE: null},
		
		
		"SDSQ8": {DATA: "This is stupid, just let me through.",TYPE: "Q", REFERENCE: null},
		
		"SDSI0": {DATA: "My my, clunky threats buddy, I aint got a wife.",TYPE: "I", REFERENCE: null},
		"SDSI1": {DATA: "I dont really know what this is, confiscate it if you want but I aint at fault here.",TYPE: "I", REFERENCE: null},
		"SDSI2": {DATA: "This seems unnecesary to argue about, i already told you Im no crook.",TYPE: null, REFERENCE: null},
		"SDSI3": {DATA: "I've got rights, this America.",TYPE: "I", REFERENCE: null},
		
		"SDC0": {DATA: "You know all these people here seem so tense, whats everyone worried about.",TYPE: "C", REFERENCE: {"C" : "SDC1"}},
		"SDC1": {DATA: "Outside too, everyone is scared half to death of these russians, they aint even met a real russian.",TYPE: null, REFERENCE: {"C" : "SDC2"}},
		"SDC2": {DATA: "Im a firm believer that untill something is proven to be a big deal, you shouldnt care about it.",TYPE: null, REFERENCE: {"C" : "SDC3"}},
		"SDC3": {DATA: "Well, thats just what I think, now let me go get my money.",TYPE: null, REFERENCE: {"C" : "SDC3"}},
		
		"SDC4": {DATA: "This place is creepy man.",TYPE: "C", REFERENCE: {"C" : "SDC5"}},
		"SDC5": {DATA: "It's like the walls surrond you on all sides.",TYPE: null, REFERENCE: {"C" : "SDC6"}},
		"SDC6": {DATA: "And they watch you, like theres men sitting on the other side waiting to take you.",TYPE: null, REFERENCE: {"C" : "SDC7"}},
		"SDC7": {DATA: "Almost like the russians have it.",TYPE: null, REFERENCE: {"C" : "SDC8"}},
		"SDC8": {DATA: "...",TYPE: null, REFERENCE: {"C" : "SDC8"}},
		
		"SDC9": {DATA: "I aint making smalltalk with you man.",TYPE: "CI", REFERENCE: {"C" : "SDC9"}},
	},
	"MuricaDialogueT":
	{
		"SNUll" : {DATA: "Like I said Mister, REAL TUNGSTEN. now may I go?",TYPE: "S", REFERENCE: {"S" : "SNULL", "G" : "GNULL"}},
		"GNULL" : {DATA: "Huh, you're not giving it back?",TYPE: "G", REFERENCE: null},
		"null": {DATA: ". . .",TYPE: null, REFERENCE: null},
		"MDTQ0" : {DATA: "America needs this, if I can contribute I will.", TYPE: "QSTART", REFERENCE: null},
		"MDTQ1" : {DATA: "I've had this tungsten cube for a long time, but today I need to give it up.", TYPE: "QSTART", REFERENCE: null},
		"MDTQ2" : {DATA: "I've decided to charitably sell my beloved tungsten cube, FOR AMERICA.", TYPE: "QSTART", REFERENCE: null},
		
		"MDTQ3" : {DATA: "What will I do with the money? I will buy guns, for self defense, ofcourse.", TYPE: "QMID1", REFERENCE: null},
		"MDTQ4" : {DATA: "I'What will I do with the money? It's going towards my bunker. You never know.", TYPE: "QMID1", REFERENCE: null},
		"MDTQ5" : {DATA: "What will I do with the money? I'm buying a musket, for self defense.", TYPE: "QMID1", REFERENCE: null},
		
		"MDTQ6" : {DATA: "I'm from Orlando, but I drove here to contribute.", TYPE: "QMID2", REFERENCE: null},
		"MDTQ7" : {DATA: "I'm from Utah, but I drove here to help the wonderful US MILITARY.", TYPE: "QMID2", REFERENCE: null},
		
		"MDTQ8" : {DATA: "WHAT DO YOU MEAN 'ALTERIOR MOTIVE'? I would never let my country down.", TYPE: "QMID3", REFERENCE: null},
		
		"MDTQ9" : {DATA: "I STAND FOR DEMOCRACY", TYPE: "Q", REFERENCE: null},
		
		"MDTI0": {DATA: "No no no, please, I havent done anything.",TYPE: "I", REFERENCE: {"I" : "MDTI0"}},
		"MDTI1": {DATA: "No no no, please, not my kids. I promise I'm good.",TYPE: "I", REFERENCE: {"I" : "MDTI1"}},
		"MDTI2": {DATA: "I PROMISE TO STAND FOR MY COUNTRY, I WOULD NEVER LIE",TYPE: "I", REFERENCE: {"I" : "MDTI3"}},
		"MDTI3": {DATA: "YOU CANT DO THIS, I HAVE RIGHTS",TYPE: "I", REFERENCE: {"I" : "MDTI2"}},
		
		"MDC0": {DATA: "Yeah, I'm happy to be here. It's my duty after all.",TYPE: "", REFERENCE: {"C" : "MDC1"}},
		"MDC1": {DATA: "Yup, my grandpa served in Afghanistan, It's my family's legacy.",TYPE: null, REFERENCE: {"C" : "MDC2"}},
		"MDC2": {DATA: "I'm proud to help crush those bastardly Russians.",TYPE: null, REFERENCE: {"C" : "MDC3"}},
		"MDC3": {DATA: "FOR AMERICA",TYPE: null, REFERENCE: {"C" : "MDC3"}},
		
		"MDC4": {DATA: "Thanks for asking man, I'm ok, just though times.",TYPE: "", REFERENCE: {"C" : "MDC5"}},
		"MDC5": {DATA: "Indeed, my Son got killed in that bombing down in Georgia.",TYPE: null, REFERENCE: {"C" : "MDC6"}},
		"MDC6": {DATA: "It was tough to hear about, but now, more than ever I must support AMERICA.",TYPE: null, REFERENCE: {"C" : "MDC7"}},
		"MDC7": {DATA: "Thanks for listening man.",TYPE: null, REFERENCE: {"C" : "MDC7"}},
		
		"MDC8": {DATA: "Thanks for asking man, I'm ok, just though times.",TYPE: "", REFERENCE: {"C" : "MDC9"}},
		"MDC9": {DATA: "Indeed, my Son got killed in that bombing down in Georgia.",TYPE: null, REFERENCE: {"C" : "MDC10"}},
		"MDC10": {DATA: "It was tough to hear about, but now, more than ever I must support AMERICA.",TYPE: null, REFERENCE: {"C" : "MDC11"}},
		"MDC11": {DATA: "Thanks for listening man.",TYPE: null, REFERENCE: {"C" : "MDC11"}},
		
		"MDC12": {DATA: "You know, I saw something really strange last week.",TYPE: "", REFERENCE: {"C" : "MDC13"}},
		"MDC13": {DATA: "I was out in the forest, south of here, and saw a large cave.",TYPE: null, REFERENCE: {"C" : "MDC14"}},
		"MDC14": {DATA: "And I heard strange sound from in there, chanting, in some strange language.",TYPE: null, REFERENCE: {"C" : "MDC15"}},
		"MDC15": {DATA: "Must've been some Russian loonies, but I didnt go in there.",TYPE: null, REFERENCE: {"C" : "MDC16"}},
		"MDC16": {DATA: "Yeah, I reported it but no one has gotten back to me.",TYPE: null, REFERENCE: {"C" : "MDC17"}},
		"MDC17": {DATA: "The world is scary man.",TYPE: null, REFERENCE: {"C" : "MDC17"}},
		
		"MDC18": {DATA: "Hey don't try to make smalltalk buddy.",TYPE: "C", REFERENCE: {"C" : "MDC19"}},
		"MDC19": {DATA: "...",TYPE: null, REFERENCE: {"C" : "MDC19"}},
		
		"MDC20": {DATA: "No secuirty questions?",TYPE: "CSTART", REFERENCE: {"C" : "MDC20"}},
	},
	"MuricaDialogueS":
	{
		"null": {DATA: ". . .",TYPE: null, REFERENCE: null},
		"SNUll" : {DATA: "Like I said Mister, REAL TUNGSTEN. now may I go please?",TYPE: "S", REFERENCE: {"S" : "SNULL", "G" : "GNULL"}},
		"GNULL" : {DATA: "Huh, you're not giving it back?",TYPE: "G", REFERENCE: null},
		"MDSQ0" : {DATA: "America needs this, if I can contribute I will.", TYPE: "QSTART", REFERENCE: null},
		"MDSQ1" : {DATA: "I've had this for a long time, just as decor, but today I need to give it up.", TYPE: "QSTART", REFERENCE: null},
		"MDSQ2" : {DATA: "I've decided to charitably sell my beloved tungsten Statue, FOR AMERICA.", TYPE: "QSTART", REFERENCE: null},
		
		"MDSQ3" : {DATA: "What will I do with the money? I will buy guns, for self defense, ofcourse.", TYPE: "QMID1", REFERENCE: null},
		"MDSQ4" : {DATA: "I'What will I do with the money? It's going towards my bunker. You never know.", TYPE: "QMID1", REFERENCE: null},
		"MDSQ5" : {DATA: "What will I do with the money? I'm buying a musket, for self defense.", TYPE: "QMID1", REFERENCE: null},
		
		"MDSQ6" : {DATA: "I'm from California, but I drove here to contribute.", TYPE: "QMID2", REFERENCE: null},
		"MDSQ7" : {DATA: "I'm from Alaska, but I drove here to help the wonderful US MILITARY.", TYPE: "QMID2", REFERENCE: null},
		
		"MDSQ8" : {DATA: "WHAT DO YOU MEAN 'ALTERIOR MOTIVE'? I would never let my country down.", TYPE: "QMID3", REFERENCE: null},
		
		"MDSQ9" : {DATA: "I STAND FOR DEMOCRACY", TYPE: "Q", REFERENCE: null},
		
		"MDSI0": {DATA: "No no no, please, I havent done anything. It's real rungsten.",TYPE: "I", REFERENCE: {"I" : "MDSI0"}},
		"MDSI1": {DATA: "No no no, please, not my kids. I promise I'm good.",TYPE: "I", REFERENCE: {"I" : "MDSI1"}},
		"MDSI2": {DATA: "I PROMISE TO STAND FOR MY COUNTRY, I WOULD NEVER LIE",TYPE: "I", REFERENCE: {"I" : "MDSI3"}},
		"MDSI3": {DATA: "YOU CANT DO THIS, I HAVE RIGHTS",TYPE: "I", REFERENCE: {"I" : "MDSI2"}},
		
		"MDC0": {DATA: "Yeah, I'm happy to be here. It's my duty after all.",TYPE: "", REFERENCE: {"C" : "MDC1"}},
		"MDC1": {DATA: "Yup, my grandpa served in Afghanistan, It's my family's legacy.",TYPE: null, REFERENCE: {"C" : "MDC2"}},
		"MDC2": {DATA: "I'm proud to help crush those bastardly Russians.",TYPE: null, REFERENCE: {"C" : "MDC3"}},
		"MDC3": {DATA: "FOR AMERICA",TYPE: null, REFERENCE: {"C" : "MDC3"}},
		
		"MDC4": {DATA: "Thanks for asking man, I'm ok, just though times.",TYPE: "", REFERENCE: {"C" : "MDC5"}},
		"MDC5": {DATA: "Indeed, my Son got killed in that bombing down in Georgia.",TYPE: null, REFERENCE: {"C" : "MDC6"}},
		"MDC6": {DATA: "It was tough to hear about, but now, more than ever I must support AMERICA.",TYPE: null, REFERENCE: {"C" : "MDC7"}},
		"MDC7": {DATA: "Thanks for listening man.",TYPE: null, REFERENCE: {"C" : "MDC7"}},
		
		"MDC8": {DATA: "Thanks for asking man, I'm ok, just though times.",TYPE: "", REFERENCE: {"C" : "MDC9"}},
		"MDC9": {DATA: "Indeed, my Son got killed in that bombing down in Georgia.",TYPE: null, REFERENCE: {"C" : "MDC10"}},
		"MDC10": {DATA: "It was tough to hear about, but now, more than ever I must support AMERICA.",TYPE: null, REFERENCE: {"C" : "MDC11"}},
		"MDC11": {DATA: "Thanks for listening man.",TYPE: null, REFERENCE: {"C" : "MDC11"}},
		
		"MDC12": {DATA: "You know, I saw something really strange last week.",TYPE: "", REFERENCE: {"C" : "MDC13"}},
		"MDC13": {DATA: "I was out in the forest, south of here, and saw a large cave.",TYPE: null, REFERENCE: {"C" : "MDC14"}},
		"MDC14": {DATA: "And I heard strange sound from in there, chanting, in some strange language.",TYPE: null, REFERENCE: {"C" : "MDC15"}},
		"MDC15": {DATA: "Must've been some Russian loonies, but I didnt go in there.",TYPE: null, REFERENCE: {"C" : "MDC16"}},
		"MDC16": {DATA: "Yeah, I reported it but no one has gotten back to me.",TYPE: null, REFERENCE: {"C" : "MDC17"}},
		"MDC17": {DATA: "The world is scary man.",TYPE: null, REFERENCE: {"C" : "MDC17"}},
		
		"MDC18": {DATA: "Hey don't try to make smalltalk buddy.",TYPE: "C", REFERENCE: {"C" : "MDC19"}},
		"MDC19": {DATA: "...",TYPE: null, REFERENCE: {"C" : "MDC19"}},
		
		"MDC20": {DATA: "No secuirty questions?",TYPE: "CSTART", REFERENCE: {"C" : "MDC20"}},
	},
	"MuricaDialogueG":
	{
		"SNUll" : {DATA: "Like I said Mister, REAL GOLD. Now may I go please?",TYPE: "S", REFERENCE: {"S" : "SNULL", "G" : "GNULL"}},
		"GNULL" : {DATA: "Hey, give it back.",TYPE: "G", REFERENCE: null},
		"null": {DATA: ". . .",TYPE: null, REFERENCE: null},
		"MDGQ0" : {DATA: "America needs this, It's gold, but I just wanna contribute.", TYPE: "QSTART", REFERENCE: null},
		"MDGQ1" : {DATA: "I've had this gold for a long time, in the attic, but today I need to give it up.", TYPE: "QSTART", REFERENCE: null},
		"MDGQ2" : {DATA: "I've decided to charitably sell my gold, FOR AMERICA.", TYPE: "QSTART", REFERENCE: null},
		
		"MDGQ3" : {DATA: "What will I do with the money? I will buy guns, for self defense, ofcourse.", TYPE: "QMID1", REFERENCE: null},
		"MDGQ4" : {DATA: "I'What will I do with the money? It's going towards my bunker. You never know.", TYPE: "QMID1", REFERENCE: null},
		"MDGQ5" : {DATA: "What will I do with the money? I'm buying a musket, for self defense.", TYPE: "QMID1", REFERENCE: null},
		
		"MDGQ6" : {DATA: "I'm from California, but I drove here to contribute.", TYPE: "QMID2", REFERENCE: null},
		"MDGQ7" : {DATA: "I'm from Alaska, but I drove here to help the wonderful US MILITARY.", TYPE: "QMID2", REFERENCE: null},
		
		"MDGQ8" : {DATA: "WHAT DO YOU MEAN 'ALTERIOR MOTIVE'? I would never let my country down.", TYPE: "QMID3", REFERENCE: null},
		
		"MDGQ9" : {DATA: "I STAND FOR DEMOCRACY", TYPE: "Q", REFERENCE: null},
		
		"MDGI0": {DATA: "No no no, please, I havent done anything. It's real gold man.",TYPE: "I", REFERENCE: {"I" : "MDGI0"}},
		"MDGI1": {DATA: "No no no, please, not my kids. I promise I'm good.",TYPE: "I", REFERENCE: {"I" : "MDGI1"}},
		"MDGI2": {DATA: "I PROMISE TO STAND FOR MY COUNTRY, I WOULD NEVER LIE",TYPE: "I", REFERENCE: {"I" : "MDGI3"}},
		"MDGI3": {DATA: "YOU CANT DO THIS, I HAVE RIGHTS",TYPE: "I", REFERENCE: {"I" : "MDGI2"}},
		
		"MDC0": {DATA: "Yeah, I'm happy to be here. It's my duty after all.",TYPE: "", REFERENCE: {"C" : "MDC1"}},
		"MDC1": {DATA: "Yup, my grandpa served in Afghanistan, It's my family's legacy.",TYPE: null, REFERENCE: {"C" : "MDC2"}},
		"MDC2": {DATA: "I'm proud to help crush those bastardly Russians.",TYPE: null, REFERENCE: {"C" : "MDC3"}},
		"MDC3": {DATA: "FOR AMERICA",TYPE: null, REFERENCE: {"C" : "MDC3"}},
		
		"MDC4": {DATA: "Thanks for asking man, I'm ok, just though times.",TYPE: "", REFERENCE: {"C" : "MDC5"}},
		"MDC5": {DATA: "Indeed, my Son got killed in that bombing down in Georgia.",TYPE: null, REFERENCE: {"C" : "MDC6"}},
		"MDC6": {DATA: "It was tough to hear about, but now, more than ever I must support AMERICA.",TYPE: null, REFERENCE: {"C" : "MDC7"}},
		"MDC7": {DATA: "Thanks for listening man.",TYPE: null, REFERENCE: {"C" : "MDC7"}},
		
		"MDC8": {DATA: "Thanks for asking man, I'm ok, just though times.",TYPE: "", REFERENCE: {"C" : "MDC9"}},
		"MDC9": {DATA: "Indeed, my Son got killed in that bombing down in Georgia.",TYPE: null, REFERENCE: {"C" : "MDC10"}},
		"MDC10": {DATA: "It was tough to hear about, but now, more than ever I must support AMERICA.",TYPE: null, REFERENCE: {"C" : "MDC11"}},
		"MDC11": {DATA: "Thanks for listening man.",TYPE: null, REFERENCE: {"C" : "MDC11"}},
		
		"MDC12": {DATA: "You know, I saw something really strange last week.",TYPE: "", REFERENCE: {"C" : "MDC13"}},
		"MDC13": {DATA: "I was out in the forest, south of here, and saw a large cave.",TYPE: null, REFERENCE: {"C" : "MDC14"}},
		"MDC14": {DATA: "And I heard strange sound from in there, chanting, in some strange language.",TYPE: null, REFERENCE: {"C" : "MDC15"}},
		"MDC15": {DATA: "Must've been some Russian loonies, but I didnt go in there.",TYPE: null, REFERENCE: {"C" : "MDC16"}},
		"MDC16": {DATA: "Yeah, I reported it but no one has gotten back to me.",TYPE: null, REFERENCE: {"C" : "MDC17"}},
		"MDC17": {DATA: "The world is scary man.",TYPE: null, REFERENCE: {"C" : "MDC17"}},
		
		"MDC18": {DATA: "Hey don't try to make smalltalk buddy.",TYPE: "C", REFERENCE: {"C" : "MDC19"}},
		"MDC19": {DATA: "...",TYPE: null, REFERENCE: {"C" : "MDC19"}},
		
		"MDC20": {DATA: "No secuirty questions?",TYPE: "CSTART", REFERENCE: {"C" : "MDC20"}},
	},
	"MuricaDialogueC":
	{
		"SNUll" : {DATA: "I apologize, made a mistake at breakfeast this morning. I can go back home and fetch the real gold. Right?",TYPE: "S", REFERENCE: {"S" : "SNULL", "G" : "GNULL", "K" : "KNULL"}},
		"GNULL" : {DATA: "Oh thank you mister, I knew you'd understand.",TYPE: "G", REFERENCE: null},
		"KNULL" : {DATA: "You're making a mistake, IM NOT A RUSSIAN, I SWEAR",TYPE: "G", REFERENCE: null},
		"null": {DATA: ". . .",TYPE: null, REFERENCE: null},
		"MDCQ0" : {DATA: "America needs this, It's gold, but I just wanna contribute...", TYPE: "QSTART", REFERENCE: null},
		"MDCQ1" : {DATA: "I've had this uhhh ... gold for a long time, in the attic, but today I need to give it up.", TYPE: "QSTART", REFERENCE: null},
		"MDCQ2" : {DATA: "I've decided to very charitably sell my gold, FOR AMERICA!!!!", TYPE: "QSTART", REFERENCE: null},
		
		"MDCQ3" : {DATA: "What will I do with the money? I will buy guns, for self defense, ofcourse.", TYPE: "QMID1", REFERENCE: null},
		"MDCQ4" : {DATA: "I'What will I do with the money? It's going towards my bunker. You never know.", TYPE: "QMID1", REFERENCE: null},
		"MDCQ5" : {DATA: "What will I do with the money? I'm buying a musket, for self defense.", TYPE: "QMID1", REFERENCE: null},
		
		"MDCQ6" : {DATA: "I'm from California, but I drove here to sell my gold.", TYPE: "QMID2", REFERENCE: null},
		"MDCQ7" : {DATA: "I'm from Montana, but I drove here to help the wonderful US MILITARY.", TYPE: "QMID2", REFERENCE: null},
		
		"MDCQ8" : {DATA: "WHAT DO YOU MEAN 'ALTERIOR MOTIVE'? I would never let my country down.", TYPE: "QMID3", REFERENCE: null},
		
		"MDCQ9" : {DATA: "I STAND FOR DEMOCRACY", TYPE: "Q", REFERENCE: null},
		
		"MDCI0": {DATA: "No no no, please, I havent done anything. It's real gold man. I SWEAR DUDE",TYPE: "I", REFERENCE: {"I" : "MDCI0"}},
		"MDCI1": {DATA: "No no no, please, not my kids. I promise I'm good. I SWEAR",TYPE: "I", REFERENCE: {"I" : "MDCI1"}},
		"MDCI2": {DATA: "I PROMISE TO STAND FOR MY COUNTRY, I WOULD NEVER LIE",TYPE: "I", REFERENCE: {"I" : "MDCI3"}},
		"MDCI3": {DATA: "YOU CANT DO THIS, I HAVE RIGHTS, THIS IS AMERICA",TYPE: "I", REFERENCE: {"I" : "MDCI2"}},
		
		"MDC0": {DATA: "Yeah, I'm happy to be here. It's my duty after all.",TYPE: "", REFERENCE: {"C" : "MDC1"}},
		"MDC1": {DATA: "Yup, my grandpa served in Afghanistan, It's my family's legacy.",TYPE: null, REFERENCE: {"C" : "MDC2"}},
		"MDC2": {DATA: "I'm proud to help crush those bastardly Russians.",TYPE: null, REFERENCE: {"C" : "MDC3"}},
		"MDC3": {DATA: "FOR AMERICA",TYPE: null, REFERENCE: {"C" : "MDC3"}},
		
		"MDC4": {DATA: "Thanks for asking man, I'm ok, just though times.",TYPE: "", REFERENCE: {"C" : "MDC5"}},
		"MDC5": {DATA: "Indeed, my Son got killed in that bombing down in Georgia.",TYPE: null, REFERENCE: {"C" : "MDC6"}},
		"MDC6": {DATA: "It was tough to hear about, but now, more than ever I must support AMERICA.",TYPE: null, REFERENCE: {"C" : "MDC7"}},
		"MDC7": {DATA: "Thanks for listening man.",TYPE: null, REFERENCE: {"C" : "MDC7"}},
		
		"MDC8": {DATA: "Thanks for asking man, I'm ok, just though times.",TYPE: "", REFERENCE: {"C" : "MDC9"}},
		"MDC9": {DATA: "Indeed, my Son got killed in that bombing down in Georgia.",TYPE: null, REFERENCE: {"C" : "MDC10"}},
		"MDC10": {DATA: "It was tough to hear about, but now, more than ever I must support AMERICA.",TYPE: null, REFERENCE: {"C" : "MDC11"}},
		"MDC11": {DATA: "Thanks for listening man.",TYPE: null, REFERENCE: {"C" : "MDC11"}},
		
		"MDC12": {DATA: "You know, I saw something really strange last week.",TYPE: "", REFERENCE: {"C" : "MDC13"}},
		"MDC13": {DATA: "I was out in the forest, south of here, and saw a large cave.",TYPE: null, REFERENCE: {"C" : "MDC14"}},
		"MDC14": {DATA: "And I heard strange sound from in there, chanting, in some strange language.",TYPE: null, REFERENCE: {"C" : "MDC15"}},
		"MDC15": {DATA: "Must've been some Russian loonies, but I didnt go in there.",TYPE: null, REFERENCE: {"C" : "MDC16"}},
		"MDC16": {DATA: "Yeah, I reported it but no one has gotten back to me.",TYPE: null, REFERENCE: {"C" : "MDC17"}},
		"MDC17": {DATA: "The world is scary man.",TYPE: null, REFERENCE: {"C" : "MDC17"}},
		
		"MDC18": {DATA: "Hey don't try to make smalltalk buddy.",TYPE: "C", REFERENCE: {"C" : "MDC19"}},
		"MDC19": {DATA: "...",TYPE: null, REFERENCE: {"C" : "MDC19"}},
		
		"MDC20": {DATA: "No secuirty questions? Great!",TYPE: "CSTART", REFERENCE: {"C" : "MDC20"}},
	},
	"MuricaDialogueB":
	{
		"null": {DATA: ". . .",TYPE: null, REFERENCE: null},
		"MDBQ0" : {DATA: "America needs this, I'm pretty sure this is tungsten.", TYPE: "QSTART", REFERENCE: null},
		"MDBQ1" : {DATA: "I've had this thingy for a long time, in the attic, but today I give it up.", TYPE: "QSTART", REFERENCE: null},
		"MDBQ2" : {DATA: "I've decided to sell this thingy I found, FOR AMERICA.", TYPE: "QSTART", REFERENCE: null},
		
		"MDBQ3" : {DATA: "What will I do with the money? I will buy guns, for self defense, ofcourse.", TYPE: "QMID1", REFERENCE: null},
		"MDBQ4" : {DATA: "I'What will I do with the money? It's going towards my bunker. You never know.", TYPE: "QMID1", REFERENCE: null},
		"MDBQ5" : {DATA: "What will I do with the money? I'm buying a musket, for self defense.", TYPE: "QMID1", REFERENCE: null},
		
		"MDBQ6" : {DATA: "I'm from Kansas, but I drove here to contribute.", TYPE: "QMID2", REFERENCE: null},
		"MDBQ7" : {DATA: "I'm from Detroit, but I drove here to help the wonderful US MILITARY.", TYPE: "QMID2", REFERENCE: null},
		
		"MDBQ8" : {DATA: "WHAT DO YOU MEAN 'ALTERIOR MOTIVE'? I would never let my country down.", TYPE: "QMID3", REFERENCE: null},
		
		"MDSQ9" : {DATA: "I STAND FOR DEMOCRACY", TYPE: "Q", REFERENCE: null},
		
		"MDBI0": {DATA: "No no no, please, I  was just told to bring this man, I SWEAR.",TYPE: "I", REFERENCE: {"I" : "MDBI0"}},
		"MDBI1": {DATA: "No no no, please, not my kids. I promise I'm good.",TYPE: "I", REFERENCE: {"I" : "MDBI1"}},
		"MDBI2": {DATA: "I PROMISE TO STAND FOR MY COUNTRY, I WOULD NEVER, NEVER",TYPE: "I", REFERENCE: {"I" : "MDBI2"}},
		"MDBI3": {DATA: "YOU CANT DO THIS, I HAVE RIGHTS, READ THE CONSTITUTION BUDDY",TYPE: "I", REFERENCE: {"I" : "MDBI3"}},
		
		"MDC0": {DATA: "Yeah, I'm happy to be here. It's my duty after all.",TYPE: "", REFERENCE: {"C" : "MDC1"}},
		"MDC1": {DATA: "Yup, my grandpa served in Afghanistan, It's my family's legacy.",TYPE: null, REFERENCE: {"C" : "MDC2"}},
		"MDC2": {DATA: "I'm proud to help crush those bastardly Russians.",TYPE: null, REFERENCE: {"C" : "MDC3"}},
		"MDC3": {DATA: "FOR AMERICA",TYPE: null, REFERENCE: {"C" : "MDC3"}},
		
		"MDC4": {DATA: "Thanks for asking man, I'm ok, just though times.",TYPE: "", REFERENCE: {"C" : "MDC5"}},
		"MDC5": {DATA: "Indeed, my Son got killed in that bombing down in Georgia.",TYPE: null, REFERENCE: {"C" : "MDC6"}},
		"MDC6": {DATA: "It was tough to hear about, but now, more than ever I must support AMERICA.",TYPE: null, REFERENCE: {"C" : "MDC7"}},
		"MDC7": {DATA: "Thanks for listening man.",TYPE: null, REFERENCE: {"C" : "MDC7"}},
		
		"MDC8": {DATA: "Thanks for asking man, I'm ok, just though times.",TYPE: "", REFERENCE: {"C" : "MDC9"}},
		"MDC9": {DATA: "Indeed, my Son got killed in that bombing down in Georgia.",TYPE: null, REFERENCE: {"C" : "MDC10"}},
		"MDC10": {DATA: "It was tough to hear about, but now, more than ever I must support AMERICA.",TYPE: null, REFERENCE: {"C" : "MDC11"}},
		"MDC11": {DATA: "Thanks for listening man.",TYPE: null, REFERENCE: {"C" : "MDC11"}},
		
		"MDC12": {DATA: "You know, I saw something really strange last week.",TYPE: "", REFERENCE: {"C" : "MDC13"}},
		"MDC13": {DATA: "I was out in the forest, south of here, and saw a large cave.",TYPE: null, REFERENCE: {"C" : "MDC14"}},
		"MDC14": {DATA: "And I heard strange sound from in there, chanting, in some strange language.",TYPE: null, REFERENCE: {"C" : "MDC15"}},
		"MDC15": {DATA: "Must've been some Russian loonies, but I didnt go in there.",TYPE: null, REFERENCE: {"C" : "MDC16"}},
		"MDC16": {DATA: "Yeah, I reported it but no one has gotten back to me.",TYPE: null, REFERENCE: {"C" : "MDC17"}},
		"MDC17": {DATA: "The world is scary man.",TYPE: null, REFERENCE: {"C" : "MDC17"}},
		
		"MDC18": {DATA: "Hey don't try to make smalltalk buddy.",TYPE: "C", REFERENCE: {"C" : "MDC19"}},
		"MDC19": {DATA: "...",TYPE: null, REFERENCE: {"C" : "MDC19"}},
		
		"MDC20": {DATA: "No secuirty questions?",TYPE: "CSTART", REFERENCE: {"C" : "MDC20"}},
	},
	"SpyDialogueB":
	{
		"null": {DATA: ". . .", TYPE : null, REFERENCE : null},
		"SDBQ0": {DATA: "Hello yes I am selling Tungstenne, American Tungstenne.", TYPE : "QSTART", REFERENCE : null},
		"SDBQ1": {DATA: "I bought Tungstens 10 year ago, it's super quality.", TYPE : "QSTART", REFERENCE : null},
		"SDBQ2": {DATA: "100% real American Tungsten, for you Sir.", TYPE : "QSTART", REFERENCE : null},
		
		"SDBQ3": {DATA: "I am spending money on guns and America.", TYPE : "QMID1", REFERENCE : null},
		"SDBQ4": {DATA: "I am doanting money to military. FOR AMERIGA", TYPE : "QMID1", REFERENCE : {"C" : "SDC0"}},
		
		"SDBQ5": {DATA: "I am from America, drove here to sell my Tungsten.", TYPE : "QMID2", REFERENCE : null},
		"SDBQ6": {DATA: "I am from America, flew many hour here to sell my Tungsten.", TYPE : "QMID2", REFERENCE : null},
		
		"SDBQ7": {DATA: "So yes I am free to go now?", TYPE : "Q", REFERENCE : {"Q" : "SDBQ8"}},
		"SDBQ8": {DATA: "So we done here?", TYPE : "Q", REFERENCE : {"Q" : "SDBQ7"}},
		
		"SDBI0": {DATA: "I WOULD NEVER BETRAY AMERICA, O O SAY CAN YOU SEE, BY THE DAWNS EARLY LIGHT...", TYPE : "I", REFERENCE : {"I" : "SDBI0"}},
		"SDBI1": {DATA: "I WOULD NEVER LIE, I AM TRUE AMERICAN", TYPE : "I", REFERENCE : {"I" : "SDBI2"}},
		"SDBI2": {DATA: "I PROMISE YOU OFFICER I AM NOT SPY IN K32 RUSSIAN UNIT, I WOUDLD NEVER", TYPE : "I", REFERENCE : {"I" : "SDBI1"}},
		"SDBI3": {DATA: "I AM AMERICAN CITIZEN, I HAVE CONSTITUITON, YOU CANT", TYPE : "I", REFERENCE : {"I" : "SDBI3"}},
		
		"SDC0": {DATA: "This is super cool place, I love Ameriga.", TYPE : "C", REFERENCE : {"C" : "SDC1"}},
		"SDC1": {DATA: "I love STATIC, amazing lovely concrete and asphalt.", TYPE : null, REFERENCE : {"C" : "SDC2"}},
		"SDC2": {DATA: "So, you know any funny STATIC secrets?", TYPE : null, REFERENCE : {"C" : "SDC3"}},
		"SDC3": {DATA: "Me first?, Well I know the turth about georgia bombings.", TYPE : null, REFERENCE : {"C" : "SDC4"}},
		"SDC4": {DATA: "Wasn't russia, we dont own aiships", TYPE : null, REFERENCE : {"C" : "SDC5"}},
		"SDC5": {DATA: ". . .", TYPE : null, REFERENCE : {"C" : "SDC6"}},
		"SDC6": {DATA: "I mean, uhh, hha, just joke, know any secrets yourself", TYPE : null, REFERENCE : {"C" : "SDC7"}},
		"SDC7": {DATA: "Oh, so what exactly STATIC building?", TYPE : null, REFERENCE : {"C" : "SDC8"}},
		"SDC8": {DATA: "ROD FROM GOD, haha it rhyme", TYPE : null, REFERENCE : {"C" : "SDC9"}},
		"SDC9": {DATA: "Thank you for conversation man", TYPE : null, REFERENCE : {"C" : "SDC9"}},
		
		"SDC10": {DATA: "I'm good, thank you. Im new to AMERICA", TYPE : "C", REFERENCE : {"C" : "SDC11"}},
		"SDC11": {DATA: "Yup, live on farm, in Kansas, its great.", TYPE : null, REFERENCE : {"C" : "SDC12"}},
		"SDC12": {DATA: "So where do you live? How you get this job.", TYPE : null, REFERENCE : {"C" : "SDC13"}},
		"SDC13": {DATA: "What does that word,'abduction' mean?", TYPE : null, REFERENCE : {"C" : "SDC13"}},
		
		"SDC14": {DATA: "Yes, I would like to go now.", TYPE : null, REFERENCE : {"CI" : "SDC14"}},
	},
	"ToddlingDialogueTT":
	{
		"null": {DATA: ". . .", TYPE : null, REFERENCE : null},
		"SNULL": {DATA: "I have nothing else to give you Sir.", TYPE : null, REFERENCE : null},
		"GNULL": {DATA: "TODD wishes you a good day!", TYPE : null, REFERENCE : null},
		
		"TTDTTQ0": {DATA: "I was sent here to deliver tungsten, Sir.", TYPE : "QSTART", REFERENCE : null},
		"TTDTTQ1": {DATA: "I was sent here to by my master deliver tungsten to STATIC, Sir.", TYPE : "QSTART", REFERENCE : null},
		
		"TTDTTQ2": {DATA: "I am an ambassador for TODD, I come in peace.", TYPE : "QMID1", REFERENCE : null},
		"TTDTTQ3": {DATA: "Todd has sent me, I come in peace.", TYPE : "QMID1", REFERENCE : null},
		
		"TTDTTQ4": {DATA: "This is a trivial delivery mission sir, nothing unsual.", TYPE : "Q", REFERENCE : null},
		
		"TTDTTI0": {DATA: "I am assure you sir, TODD has no ill intentions for STATIC", TYPE : "I", REFERENCE : null},
		"TTDTTI1": {DATA: "Stop it with your meaningless threats Sir, I am just here to deliver tungsten.", TYPE : "I", REFERENCE : null},
		
		"TTDTTC0": {DATA: "I am here to deliver tungsten, not engage in small talk.", TYPE : "C", REFERENCE : {"C" : "TTDTTC1"}},
		"TTDTTC1": {DATA: "Sir, I am only here for my mission.", TYPE : "C", REFERENCE : {"C" : "TTDTTC2"}},
		"TTDTTC2": {DATA: "Ofcourse not, I am sent by TODD", TYPE : "C", REFERENCE : {"C" : "TTDTTC3"}},
		"TTDTTC3": {DATA: "Not many know about TODD, and those who don't shouldn't seek to.", TYPE : "C", REFERENCE : {"C" : "TTDTTC3"}},
	},
	"ToddlingDialogueTO":
	{
		"null": {DATA: ". . .", TYPE : null, REFERENCE : null},
		"SNULL": {DATA: "I have nothing else to give you Sir.", TYPE : null, REFERENCE : null},
		"GNULL": {DATA: "TODD wishes you a good day!", TYPE : null, REFERENCE : null},
		
		"TTDTTQ0": {DATA: "I was sent here to deliver tungsten, Sir.", TYPE : "QSTART", REFERENCE : null},
		"TTDTTQ1": {DATA: "I was sent here to by my master deliver tungsten to STATIC, Sir.", TYPE : "QSTART", REFERENCE : null},
		
		"TTDTTQ2": {DATA: "I am an ambassador for TODD, I come in peace.", TYPE : "QMID1", REFERENCE : null},
		"TTDTTQ3": {DATA: "Todd has sent me, I come in peace.", TYPE : "QMID1", REFERENCE : null},
		
		"TTDTTQ4": {DATA: "This is a trivial delivery mission sir, nothing unsual.", TYPE : "Q", REFERENCE : null},
		
		"TTDTTI0": {DATA: "I can assure you sir, TODD has no ill intentions for STATIC", TYPE : "I", REFERENCE : null},
		"TTDTTI1": {DATA: "Stop it with your meaningless threats Sir, I am just here to deliver tungsten.", TYPE : "I", REFERENCE : null},
		
		"TTDTTC0": {DATA: "I am here to deliver tungsten Sir, I have no intreset for smalltalk", TYPE : "C", REFERENCE : {"C" : "TTDTTC1"}},
		"TTDTTC1": {DATA: "Sir, I am only here to complete my task for TODD", TYPE : "C", REFERENCE : {"C" : "TTDTTC2"}},
		"TTDTTC2": {DATA: "Ofcourse not, I am sent by TODD, not the Russian Federation.", TYPE : "C", REFERENCE : {"C" : "TTDTTC3"}},
		"TTDTTC3": {DATA: "You should not inquire more than neccesary into TODD", TYPE : "C", REFERENCE : {"C" : "TTDTTC3"}},
	},
	"ToddlingDialogueTD":
	{
		
		"null": {DATA: ". . .", TYPE : null, REFERENCE : null},
		"SNULL": {DATA: "I have nothing else to give you Sir.", TYPE : null, REFERENCE : null},
		"GNULL": {DATA: "TODD wishes you a good day!", TYPE : null, REFERENCE : null},
		
		"TTDTTQ0": {DATA: "I was sent here to deliver tungsten, Sir.", TYPE : "QSTART", REFERENCE : null},
		"TTDTTQ1": {DATA: "I was sent here to by my master deliver tungsten to STATIC, Sir.", TYPE : "QSTART", REFERENCE : null},
		
		"TTDTTQ2": {DATA: "I am an ambassador for TODD, I come in peace.", TYPE : "QMID1", REFERENCE : null},
		"TTDTTQ3": {DATA: "Todd has sent me, I come in peace.", TYPE : "QMID1", REFERENCE : null},
		
		"TTDTTQ4": {DATA: "This is a trivial delivery mission sir, nothing unsual.", TYPE : "Q", REFERENCE : null},
		
		"TTDTTI0": {DATA: "I assure you sir, TODD has no ill intentions for STATIC", TYPE : "I", REFERENCE : null},
		"TTDTTI1": {DATA: "Stop it with your meaningless threats Sir, I am just here to deliver tungsten.", TYPE : "I", REFERENCE : null},
		
		"TTDTTC0": {DATA: "I am here to deliver tungsten Sir, this had no relation to that.", TYPE : "C", REFERENCE : {"C" : "TTDTTC1"}},
		"TTDTTC1": {DATA: "I have obligation to respond to you", TYPE : "C", REFERENCE : {"C" : "TTDTTC2"}},
		"TTDTTC2": {DATA: "TODD is an independent organization with no Russian affiliation", TYPE : "C", REFERENCE : {"C" : "TTDTTC3"}},
		"TTDTTC3": {DATA: "Oh buddy you don't wanna know.", TYPE : "C", REFERENCE : {"C" : "TTDTTC3"}},
	},
}

func _ready():
	print("Spawned")
	$"Sprite".texture = Look
	
	Target = Database[Personality + "Dialogue" + Item]
	
func QueueDialogue(query):
	print(query)
	if readyToTalk:
		if CurrentReferences[query] != null:
			PrintDialogue(CurrentReferences[query])
		else:
			
			var Adress
			if query == "K":
				Kill()
			elif query == "G":
				Go()
			elif query == "S":
				Seize()
			elif query == "C" :
				if Agression > 0:
					#edegcase for interrogation chat
					Adress = QuerySearch("CI", Target)
					PrintDialogue(Adress)
				else:
					Adress = QuerySearch(query, Target)
					PrintDialogue(Adress)
			else:
				Adress = QuerySearch(query, Target)
				PrintDialogue(Adress)
			if query == "I":
				Agression = 1
		
			

func QuerySearch(Query, Dict):
	#searches a specified dict for entries of a specified type, returns a random one
	var Type = Query + Segment
	var localSearch : Array = []
	for search in Dict:
		if Dict[search][TYPE] == Type:
			localSearch.append(search)
	if localSearch == []:
		print("hit edgecase 1" + str(localSearch))
		for search in Dict:
			if Dict[search][TYPE] == Query:
				localSearch.append(search)
		if localSearch == []:
			print("hit edgecase 2" + str(localSearch))
			return("null")
	if localSearch[randi_range(0, localSearch.size() - 1)] == null:
		return("null")
	return(localSearch[randi_range(0, localSearch.size() - 1)])

func PrintDialogue(Adress):
	ReferenceHandling(Adress)
	if(SegmentIndex < 2):
		SegmentIndex += 1
		Segment = Segments[SegmentIndex]
	print(Segment)
	var DBox = DialogueBox.instantiate()
	add_child(DBox)
	DBox.position.y = 40
	DBox.position.x = 0
	DBox.message = [Target[Adress][DATA]]  
	readyToTalk = false
	Dialogueing = true
	DBox.start_dialogue()

func ResetTalk():
	Dialogueing = false

func ReferenceHandling(Adress):
	if Target[Adress][REFERENCE] != null:
		for search in Target[Adress][REFERENCE]:
			CurrentReferences[search] = Target[Adress][REFERENCE][search]

func Seize():
	if SINDEX == 0:
		get_tree().call_group("TheWorld","SpawnObj", Item)
		SINDEX += 1;
		if ExtraItems == null:
			#CurrentReferences["S"] = "SNULL"
			#CurrentReferences["G"] = "GNULL"
			pass
	if(SINDEX > 0):
		if ExtraItems[SINDEX - 1] != null:
			SINDEX += 1;
			get_tree().call_group("TheWorld","SpawnObj", SINDEX - 1)
		else:
				#CurrentReferences["S"] = "SNULL"
				#CurrentReferences["G"] = "GNULL"
				pass
		
	#get their item and spawn it as an Obj 
	#store the fact that they are itemless
	#render new dialogue for them using refs
	#(possible G-refs)
	
	#S-list for specials
	
	
	
	
	
	pass



func Kill():
	print("bang")
	#play die animation with a gunshot sound
	readyToWalk = true
	readyToTalk = false
	$AnimationPlayer.play("Die")
	$GunTimer.start()
	$DeathTimer.start()
	get_tree().call_group("TheWorld", "killed", Item, Personality)
	
func Go():
	happy = true
	readyToWalk = false
	readyToTalk = false
	$AnimationPlayer.play("Happy")
	$HappyTimer.start()
	get_tree().call_group("TheWorld", "released", Item, Personality)
func _process(delta):
	if position.x < 0:
		$AnimationPlayer.play("Walk")
		position.x += 30 * delta 
		
	if(position.x >= 0):
		if !readyToWalk and !happy:
			$AnimationPlayer.play("Idle")
			if !Dialogueing:
				readyToTalk = true
			if Dialogueing:
				readyToTalk = false
		if readyToWalk and happy:
			position.x += 30 * delta 
		
func _on_death_timer_timeout():
	get_tree().call_group("TheWorld", "Send")
	queue_free()
	pass # Replace with function body.


func _on_happy_timer_timeout():
	readyToWalk = true
	$AnimationPlayer.play("Walk")
	$DeathTimer.start()


func _on_gun_timer_timeout():
	$Gun.play()
