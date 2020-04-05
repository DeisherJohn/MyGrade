extends Node

const config_file_location = "res://TempResources/config.cfg"
const class_dir = "res://TempResources/"

var config = ConfigFile.new()

var local_settings = Dictionary()

enum themes {NORMAL = 0, DARK = 1}

func _ready():
	load_settings()
	pass

func settings_file_init():
	set_theme()
	
	var default_scale = {
		"A":90,
		"B":80,
		"C":70,
		"D":60,
		"F":0
	} 
	add_grade_scale("basic scale", default_scale)
	pass


func load_settings(reset : bool = false):
	var file_check = File.new()
	
	if not file_check.file_exists(config_file_location):
		#makes the missing file
		file_check.open(config_file_location, File.WRITE)
		file_check.close()
		settings_file_init()
		pass
	
	if reset: settings_file_init()
	
	var errors = config.load(config_file_location)
	
	if errors == OK:
		var sections = config.get_sections()
		
		for section in sections:
			local_settings[section] = Dictionary()
			var keys = config.get_section_keys(section)
			
			for key in keys:
				local_settings[section][key] = config.get_value(section, key)
	else:
		print("Config file did not open, ERROR: %s"%errors)
	pass

func save_settings():
	var errors = config.save(config_file_location)
	
	if errors != OK:
		print("Config file did not save, ERROR: %s"%errors)

func make_new_file(path : String, file_name : String, extention : String = ".json"):
	var file_check = File.new()
	
	if not file_check.file_exists(path + file_name + extention):
		#makes the missing file
		file_check.open(path + file_name + extention, File.WRITE)
		file_check.close()
		return true
	return false

func set_theme(value : int = themes.NORMAL):
	if not local_settings.has("Display"):
		local_settings["Display"] = Dictionary()
		
	local_settings["Display"]["Theme"] = value
	config.set_value("Display","Theme", value)
	save_settings()
	
func get_theme():
	return local_settings["Display"]["Theme"]

func add_grade_scale(scale_name : String, scale : Dictionary):
	if not local_settings.has("Grade_Scales"):
		local_settings["Grade_Scales"] = Dictionary()
	local_settings["Grade_Scales"][scale_name] = scale
	config.set_value("Grade_Scale", scale_name, scale)
	save_settings()

func get_scale(scale_name : String):
	if local_settings["Grade_Scale"].has(scale_name):
		return local_settings["Grade_Scale"][scale_name]
	
	return null

func add_class(class_name_local : String):
	if not local_settings.has("Classes"):
		local_settings["Classes"] = Dictionary()
	
	if local_settings["Classes"].has(class_name_local):
		#TODO: Make this appear on the GUI
		print("Class Already Exist")
		return false
	
	var good_create = make_new_file(class_dir, class_name_local)
	
	if not good_create:
		#TODO: There was an error in the file creation
		return false
	
	local_settings["Classes"][class_name_local] = class_name_local + ".json"
	config.set_value("Classes",class_name_local, class_name_local + ".json")
	save_settings()

func get_classes():
	if local_settings.has("Classes"):
		return local_settings["Classes"]
	
	return null