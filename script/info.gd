extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var text:String
export var initVal:String
func getValue():
	return $LineEdit.text

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text=text
	$LineEdit.placeholder_text=initVal
	$LineEdit.text=initVal


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
