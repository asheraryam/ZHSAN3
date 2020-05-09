extends Node2D
class_name PositionSelector

enum CurrentAction { CREATE_TROOP, MOVE_TROOP, ATTACK_TROOP, ENTER_TROOP, FOLLOW_TROOP }
var current_action

var current_architecture
var current_troop

var _cancel = false

signal create_troop
signal move_troop

func _process(delta):
	if _cancel:
		Util.delete_all_children(self)
		_cancel = false


func _on_create_troop(arch, troop):
	current_action = CurrentAction.CREATE_TROOP
	current_architecture = arch
	current_troop = troop
	
	var scen = arch.scenario
	
	var pos = arch.map_position
	if scen.get_troop_on_position(pos) == null:
		_create_position_select_item(pos, Color.blue)
		
	pos = arch.map_position + Vector2.UP
	if scen.get_troop_on_position(pos) == null:
		_create_position_select_item(pos, Color.blue)
		
	pos = arch.map_position + Vector2.DOWN
	if scen.get_troop_on_position(pos) == null:
		_create_position_select_item(pos, Color.blue)
		
	pos = arch.map_position + Vector2.LEFT
	if scen.get_troop_on_position(pos) == null:
		_create_position_select_item(pos, Color.blue)
		
	pos = arch.map_position + Vector2.RIGHT
	if scen.get_troop_on_position(pos) == null:
		_create_position_select_item(pos, Color.blue)


func _on_select_troop_move_to(troop):
	current_action = CurrentAction.MOVE_TROOP
	current_architecture = null
	current_troop = troop
	
	for pos in current_troop.get_movement_area():
		_create_position_select_item(pos, Color.blue)
		

func _on_select_troop_attack(troop):
	current_action = CurrentAction.ATTACK_TROOP
	current_architecture = null
	current_troop = troop
	# select locations

func _on_select_troop_enter(troop):
	current_action = CurrentAction.ENTER_TROOP
	current_architecture = null
	current_troop = troop
	# select locations

func _on_select_troop_follow(troop):
	current_action = CurrentAction.FOLLOW_TROOP
	current_architecture = null
	current_troop = troop
	# select locations


func _create_position_select_item(position, color = Color.white):
	var item = preload("PositionSelectItem.tscn")
	var instance = item.instance()
	
	instance.position = position * SharedData.TILE_SIZE
	instance.scale = Vector2(SharedData.TILE_SIZE / 100.0, SharedData.TILE_SIZE / 100.0)
	instance.connect("position_selected", self, "_on_position_selected", [position])
	instance.set_color(color)
	
	add_child(instance)
	

func _on_cancel_ui():
	_cancel = true


func _on_position_selected(position):
	match current_action:
		CurrentAction.CREATE_TROOP:
			emit_signal("create_troop", current_architecture, current_troop, position)
		CurrentAction.MOVE_TROOP:
			emit_signal("move_troop", current_troop, position)
