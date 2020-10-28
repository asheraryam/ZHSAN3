extends Node
class_name Skill

var id: int setget forbidden
var scenario

var gname: String setget forbidden
var color: Color setget forbidden
var description: String setget forbidden

var influences setget forbidden
var conditions setget forbidden

var learn_conditions setget forbidden
var max_level: int setget forbidden

func forbidden(x):
	assert(false)

func load_data(json: Dictionary, objects):
	id = json["_Id"]
	gname = json["Name"]
	description = json["Description"]
	color = Util.load_color(json["Color"])
	conditions = json["Conditions"]
	influences = json["Influences"]
	max_level = json["MaxLevel"] if json.has("MaxLevel") else -1
	learn_conditions = json["LearnConditions"] if json.has("LearnConditions") else []
	
func save_data() -> Dictionary:
	return {
		"_Id": id,
		"Name": gname,
		"Description": description,
		"Color": Util.save_color(color),
		"MaxLevel": max_level,
		"LearnConditions": learn_conditions,
		"Conditions": conditions,
		"Influences": influences
	}

func get_name() -> String:
	return gname

func get_name_with_level(level) -> String:
	return gname + str(level)
	
func get_color() -> Color:
	return color

func apply_influences(in_operation, level: int, params: Dictionary):
	var all_params = params.duplicate()
	all_params['level'] = level
	return ScenarioUtil.apply_influences(self, in_operation, all_params)
