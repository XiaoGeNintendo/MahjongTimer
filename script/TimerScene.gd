extends Control


onready var glb=get_node("/root/Global")
var scene = preload("res://PlayerInfo.tscn") # Will load when parsing the script.
var subs=[]
var now=0

var ignoreEvent=false
var eating=false

onready var nowTime=glb.thinkTime
onready var tween=$Tween

func se(name):
	$AudioStreamPlayer.stream=load("res://sound/%s.wav"%name)
	$AudioStreamPlayer.play()
	
func resetTo(id):
	
	if now<4:
		se(["east","south","west","north"][now])
	else:
		se("ready")
		
	eating=false
	nowTime=glb.thinkTime
	
	$timer.visible=true
	$timer2.visible=true
	$eattimer.visible=false
	$eat.visible=false
	
	$timer.text=str(nowTime)
	$timer2.text=str(glb.players[id].leftExtraTime)
	$Timer.start()
	place(now)

func _process(delta):
	var t1=1-nowTime/1.0/glb.thinkTime
	$timer.set("custom_colors/font_color",Color.green.linear_interpolate(Color.red,t1))
	
	var t2=1-getCurrentPlayer().leftExtraTime/1.0/glb.extraTime
	$timer2.set("custom_colors/font_color",Color.yellowgreen.linear_interpolate(Color.red,t2))

	
func _input(event):
	if ignoreEvent:
		return
	if event.is_action_pressed("next_player"):
		if eating:
			eating=false
			now+=1
			now%=len(glb.players)
				
			resetTo(now)
		else:
			se("fl")
			
			eating=true
			nowTime=glb.breakTime
			$eattimer.text=str(glb.breakTime)
			
			$timer.visible=false
			$timer2.visible=false
			$eattimer.visible=true
			$eat.visible=true
	
	if event.is_action_pressed("riichi") and not eating:
		if getCurrentPlayer().riichi==0:
			getCurrentPlayer().point-=glb.riichiCost
			getCurrentPlayer().riichi=1
			se("riichi")
		else:
			if getCurrentPlayer().riichi==1:
				getCurrentPlayer().point+=glb.riichiCost
			else:
				getCurrentPlayer().point+=glb.wRiichiCost
			getCurrentPlayer().riichi=0
		subs[now].refresh()
	
	if event.is_action_pressed("w_riichi") and not eating:
		if getCurrentPlayer().riichi==0:
			getCurrentPlayer().point-=glb.wRiichiCost
			getCurrentPlayer().riichi=2
			se("Wriichi")
		else:
			if getCurrentPlayer().riichi==1:
				getCurrentPlayer().point+=glb.riichiCost
			else:
				getCurrentPlayer().point+=glb.wRiichiCost
			getCurrentPlayer().riichi=0
		subs[now].refresh()
		
	for i in range(1,5):
		if event.is_action_pressed("jump%d"%i):
			now=(now+i)%len(glb.players)
			resetTo(now)
	
		
func getCurrentPlayer()->Player:
	return glb.players[now]
	
func _on_Timer_timeout():
	
	if nowTime>0:
		nowTime-=1
		
		if nowTime<=5:
			se(["zero","one","two","three","four","five"][nowTime])
		if eating:
			$eattimer.text=str(nowTime)
		else:
			$timer.text=str(nowTime)
	elif not eating and getCurrentPlayer().leftExtraTime>0:
		getCurrentPlayer().leftExtraTime-=1
		$timer2.text=str(getCurrentPlayer().leftExtraTime)
		
		var tmp=getCurrentPlayer().leftExtraTime
		if tmp<=5:
			se(["zero","one","two","three","four","five"][tmp])
	elif not eating and not $AudioStreamPlayer.playing:
		se("discard")
# Called when the node enters the scene tree for the first time.
func _ready():
	
	for i in glb.players:
		i.leftExtraTime=glb.extraTime
		i.riichi=0
		
	for i in range(len(glb.players)):
		var sub=scene.instance()
		sub.pId=i
		
		subs.append(sub)
		add_child(sub)
	resetTo(now)

const nowX=696
const nowY=401

func inter(now,x,y,s):
	
	tween.interpolate_property(subs[now],"rect_position",
	  null,Vector2(x,y),1,
	Tween.TRANS_CIRC,Tween.EASE_IN_OUT)
	tween.interpolate_property(subs[now],"rect_scale",
	  null,Vector2(s,s),1,
	Tween.TRANS_CIRC,Tween.EASE_IN_OUT)
func place(now):
	
	inter(now,nowX,nowY,1)
	
	var x=0
	for i in range(now+1,len(subs)):
		inter(i,x,0,0.5)
		x+=150
	for i in range(now):
		inter(i,x,0,0.5)
		x+=150
	tween.start()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

	


func _on_LineEdit_text_changed(new_text):
	if new_text.begins_with("ron"):
		var cmd="ron <voice>"
		for i in glb.players:
			cmd+=" <score delta for %s>"%i.name
		$Label.text=cmd
	elif new_text.begins_with("tsumo"):
		var cmd="tsumo <voice>"
		for i in glb.players:
			cmd+=" <score delta for %s>"%i.name
		$Label.text=cmd
	elif new_text.begins_with("ryuu"):
		var cmd="ryuu -"
		for i in glb.players:
			cmd+=" <score delta for %s>"%i.name
		$Label.text=cmd
	elif new_text.begins_with("next"):
		$Label.text="next"
	elif new_text.begins_with("reset"):
		$Label.text="reset"
	elif new_text.begins_with("bonus"):
		$Label.text="bonus <playerId> <score>"
	else:
		$Label.text="Press tab to exit command mode"

func _on_LineEdit_focus_entered():
	get_tree().paused=true
	ignoreEvent=true
	

func _on_LineEdit_focus_exited():
	get_tree().paused=false
	ignoreEvent=false


func _on_LineEdit_text_entered(new_text):
	
	get_tree().paused=false
	if new_text.begins_with("bonus"):
		var s=new_text.split(" ")
		glb.players[int(s[1])-1].point+=int(s[2])
		subs[int(s[1])-1].refresh()
		get_tree().paused=true
		return
		
	if new_text.begins_with("reset"):
		get_tree().change_scene("res://Start.tscn")
		return
	
	if new_text.begins_with("next"):
		var obj=glb.players.pop_front()
		glb.players.append(obj)
		get_tree().change_scene("res://Timer.tscn")
		return
		
	if new_text.begins_with("ron") or new_text.begins_with("tsumo") or new_text.begins_with("ryuu"):
		if len(new_text.split(" "))>=len(glb.players)+2:
			glb.tmp=new_text
			glb.now=now
			get_tree().change_scene("res://EndRound.tscn")
			return
		else:
			$Label.text="Missing argument"
		
	
	get_tree().paused=true
