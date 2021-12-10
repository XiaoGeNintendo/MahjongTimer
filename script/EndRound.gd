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
	elif s[1]=="2ym":
		return "二倍役満"
	elif s[1]=="3ym":
		return "三倍役満"
	elif s[1]=="4ym":
		return "四倍役満"
	elif s[1]=="5ym":
		return "五倍役満"
	elif s[1]=="6ym":
		return "六倍役満"
	elif s[1]=="6+ym":
		return "六上役満"
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
	
	$CPUParticles2D.visible="ym" in s[1]
	
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
		$Label.text=getName()+" "+str(abs(i2(s[ronpId+2])))+"点"
	else:
		$Label.text=getName()
	
	#update score & create boxes
	var x1=12
	var x2=12
	
	for i in range(len(glb.players)):
		glb.players[i].point+=i2(s[i+2])
		
		var sub=scene.instance()
		sub.pId=i
		sub.delta=i2(s[i+2])
		if sub.delta>0:
			$Tween.interpolate_property(sub,"rect_position",
			Vector2(0,-500),Vector2(x1,185),1,
			Tween.TRANS_CUBIC,Tween.EASE_IN_OUT)
			
			x1+=300
		else:
			$Tween.interpolate_property(sub,"rect_position",
			Vector2(0,-500),Vector2(x2,470),1,
			Tween.TRANS_CUBIC,Tween.EASE_IN_OUT)
			sub.rect_scale=Vector2(0.5,0.5)
			
			x2+=150
		add_child(sub)
	
	$Tween.start()
