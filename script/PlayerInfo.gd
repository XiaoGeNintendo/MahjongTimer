extends Control

export var pId:int
export var delta:int=0

onready var glb=get_node("/root/Global")
onready var p:Player=glb.players[pId]

func comma_sep(number):
	if number<0:
		return "-"+comma_sep(-number)
	var string = str(number)
	var mod = string.length() % 3
	var res = ""

	for i in range(0, string.length()):
		if i != 0 && i % 3 == mod:
			res += ","
		res += string[i]

	return res

const letter="東南西北白發中"

func _ready():
	var colors=[Color.red,Color.green,Color.yellow,Color.blue,Color.cyan,Color.aliceblue,Color.orange,Color.aqua,Color.beige]
	$HSeparator.get("custom_styles/separator").color=colors[pId%len(colors)]
	$Label.text=p.name
	$Label2.text=comma_sep(p.point)
	if pId<len(letter):
		$Label3.text=letter[pId]
	else:
		$Label3.text=str(pId+1)
	
	if delta<0:
		$Label5.text=comma_sep(delta)
		$Label5.set("custom_colors/font_color",Color.red)
	elif delta==0:
		$Label5.hide()
	else:
		$Label5.text="+"+comma_sep(delta)
