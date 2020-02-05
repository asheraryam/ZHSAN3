extends Node
class_name Scenario

onready var tile_size: int = ($Map as TileMap).cell_size[0]
onready var map_size: Vector2 = ($Map as TileMap).get_used_rect().size
var player_faction

var architecture_kinds = Dictionary()

var factions = Dictionary()
var architectures = Dictionary()
var persons = Dictionary()

signal player_faction_set
signal scenario_loaded
signal architecture_clicked

signal all_faction_finished

# Called when the node enters the scene tree for the first time.
func _ready():
	($MainCamera as MainCamera).scenario = self
	($DateRunner as DateRunner).scenario = self
	
	_load_data("user://Scenarios/000Test.json")
	player_faction = factions[1]
	
	emit_signal("scenario_loaded")
	
	$DateRunner.connect("day_passed", self, "_on_day_passed")
	

func _load_data(path):
	var file = File.new()
	file.open(path, File.READ)
	
	var json = file.get_as_text()
	var obj = parse_json(json)
	
	var date = $DateRunner as DateRunner
	date.year = obj["GameData"]["Year"]
	date.month = obj["GameData"]["Month"]
	date.day = obj["GameData"]["Day"]
	
	var architecture_kind_script = preload("Architecture/ArchitectureKind.gd")
	for item in obj["ArchitectureKinds"]:
		var instance = architecture_kind_script.new()
		__load_item(instance, item, architecture_kinds)
	
	var person_script = preload("Person/Person.gd")
	for item in obj["Persons"]:
		var instance = person_script.new()
		__load_item(instance, item, persons)
	
	var architecture_scene = preload("Architecture/Architecture.tscn")
	for item in obj["Architectures"]:
		var instance = architecture_scene.instance()
		instance.connect("architecture_clicked", self, "_on_architecture_clicked")
		__load_item(instance, item, architectures)
		for id in item["PersonList"]:
			instance.add_person(persons[int(id)])
		
	var faction_script = preload("Faction/Faction.gd")
	for item in obj["Factions"]:
		var instance = faction_script.new()
		__load_item(instance, item, factions)
		for id in item["ArchitectureList"]:
			instance.add_architecture(architectures[int(id)])

	
func __load_item(instance, item, add_to_list):
	instance.scenario = self
	instance.load_data(item)
	add_to_list[instance.get_id()] = instance
	add_child(instance)

func _on_all_loaded():
	emit_signal("player_faction_set", player_faction)
	
func _on_architecture_clicked(arch):
	emit_signal("architecture_clicked", arch)
		
func _on_day_passed():
	yield(get_tree().create_timer(1.0), "timeout")
	print('send finasdih sigll')
	emit_signal("all_faction_finished")
