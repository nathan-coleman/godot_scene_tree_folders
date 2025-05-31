@tool
extends EditorInspectorPlugin

var hidden_properties: Array[String]

func _can_handle(object: Object) -> bool:
	return object is Folder # Only target the Folder class

func _parse_begin(object: Object) -> void:
	hidden_properties = []

	var label = Label.new()
	label.text = "This node is used solely as a visual folder for organizing the scene tree.\n"
	label.text += "All properties except Editor Description are disabled."
	add_custom_control(label)

func _parse_property(object: Object, type: Variant.Type, name: String, hint_type: PropertyHint, hint_string: String, usage_flags: int, wide: bool) -> bool:
	# From the documentation: Returning true removes the built-in editor for this property.
	if (name == "editor_description"): return false
	if (name == "script"): return true
	hidden_properties.append(name)
	return true

func _parse_end(object: Object) -> void:
	reset_properties(object)

func reset_properties(object: Folder) -> void:
	for property in hidden_properties:
		object.set(property, null)
