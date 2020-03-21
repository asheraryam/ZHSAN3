extends Panel
class_name ArchitectureSurvey

var showing_architecture

func show_data(architecture: Architecture, mouse_x: int, mouse_y: int):
	showing_architecture = architecture
	
	($TitlePanel/Title as Label).text = architecture.gname
	var faction = architecture.get_belonged_faction()
	if faction:
		($Content/Faction/Color as ColorRect).color = faction.color
		($Content/Faction/Text as Label).text = faction.gname
	else:
		($Content/Faction/Color as ColorRect).color = Color(1, 1, 1)
		($Content/Faction/Text as Label).text = "----"
	($Content/PersonCount as Label).text = str(architecture.get_persons().size())
	var section = architecture.get_belonged_section()
	if section:
		($Content/Section as Label).text = section.get_name()
	else:
		($Content/Section as Label).text = "----"
	
	($Content/Population as Label).text = Util.nstr(architecture.population)
	($Content/MilitaryPopulation as Label).text = Util.nstr(architecture.military_population)
	($Content/Fund as Label).text = Util.nstr(architecture.fund)
	($Content/Food as Label).text = Util.nstr(architecture.food)
	($Content/Agriculture as Label).text = Util.nstr(architecture.agriculture)
	($Content/Commerce as Label).text = Util.nstr(architecture.commerce)
	($Content/Morale as Label).text = Util.nstr(architecture.morale)
	($Content/Endurance as Label).text = Util.nstr(architecture.endurance)
	
	($Content/Troop as Label).text = Util.nstr(architecture.troop)
	($Content/TroopMorale as Label).text = str(architecture.troop_morale)
	($Content/Combativity as Label).text = str(architecture.troop_combativity)
	
	show()

func update_data(architecture: Architecture):
	if showing_architecture == null:
		return
	if architecture.id == showing_architecture.id:
		show_data(architecture, 0, 0)

func _on_ArchitectureSurvey_hide():
	showing_architecture = null
