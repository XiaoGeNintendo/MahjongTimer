extends Control

onready var glb=get_node("/root/Global")
onready var cmd=glb.tmp
onready var s=cmd.split(" ")
onready var ronpId=glb.now

func getName():
	if s[1]=="bm":
		return "倍満"
	elif s[1]=="ym":
		return "役満"
	elif s[1]=="mg":
		return "満貫"
	elif s[1]=="sbm":
		return "三倍満"
	elif s[1]=="tm":
		return "跳満"
	elif s[0]=="ron":
		return "栄和"
	elif s[0]=="tsumo":
		return "自摸"
	elif s[0]=="ryuu":
		return "流局"
	else:
		return "和"
var scene=preload("res://PlayerInfo.tscn")

func se(name):
	$AudioStreamPlayer.stream=load("res://sound/%s.wav"%name)
	$AudioStreamPlayer.play()

func _input(ev):
	if ev.is_action_pressed("next_player"):
		get_tree().change_scene("res://Timer.tscn")

func i2(s):
	if s.ends_with("k"):
		return int(s)*1000
	else:
		return int(s)

#ron voice score
func _ready():
	
	if s[1]!="-":
		se(s[1])
	elif s[0]=="ron":
		se("ron")
	elif s[0]=="tsumo":
		se("tsumo")
	else:
		se("ryuu")
	
	$Tween.interpolate_property($Label,"rect_position",
	Vector2(0,-500),Vector2(0,0),1,
	Tween.TRANS_BOUNCE,Tween.EASE_OUT)
	
	if s[0]!="ryuu":
		$Label.text=getName()+" "+str(i2(s[ronpId+2]))+"点"
	else:
		$Label.text=getName()
	
	#update score & create boxes
	var x=0
	for i in range(len(glb.players)):
		glb.players[i].point+=i2(s[i+2])
		
		var sub=scene.instance()
		sub.pId=i
		sub.delta=i2(s[i+2])
		if i==ronpId:
			$Tween.interpolate_property(sub,"rect_position",
			Vector2(0,-500),Vector2(12,185),1,
			Tween.TRANS_CUBIC,Tween.EASE_IN_OUT)
			sub.rect_scale=Vector2(2,2)
		else:
			$Tween.interpolate_property(sub,"rect_position",
			Vector2(0,-500),Vector2(x,470),1,
			Tween.TRANS_CUBIC,Tween.EASE_IN_OUT)
			
			x+=150
		add_child(sub)
	
	$Tween.start()
