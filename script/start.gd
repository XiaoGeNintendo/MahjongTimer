extends Control

func _ready():
	$"/root/Global".players.clear()
	
func _on_Button_pressed():
	
	var pln=$p1.getValue().split(",")
	var initP=int($p2.getValue())
	var glb=$"/root/Global"
	glb.thinkTime=$p3.getValue()
	glb.extraTime=$p4.getValue()
	glb.breakTime=$p5.getValue()
	glb.riichiCost=$p6.getValue()
	glb.wRiichiCost=$p7.getValue()
	
	for i in pln:
		i.strip_edges()
		var np=Player.new()
		np.name=i
		np.point=initP
		np.leftExtraTime=$p4.getValue()
		glb.players.append(np)
	get_tree().change_scene("res://Timer.tscn")
