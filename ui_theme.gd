extends Node

# Path to the ElMessiri font
const FONT_PATH = "res://assets/ElMessiri-VariableFont_wght.ttf"

# Font sizes for different UI elements
const FONT_SIZE_TITLE = 64 # Increased from 48 to 64
const FONT_SIZE_DISTANCE = 37
const FONT_SIZE_BEST = 20
const FONT_SIZE_PROMPT = 24
const FONT_SIZE_DEBUG = 16

# Text outline settings
const OUTLINE_SIZE = 3.0
const OUTLINE_COLOR = Color(0.1, 0.1, 0.1, 1.0) # Dark outline color

# Create and setup the custom theme for the game
func _ready():
	# Load the ElMessiri font
	var font = load(FONT_PATH)
	if not font:
		push_error("Failed to load ElMessiri font from: " + FONT_PATH)
		return
	
	# Create a new theme
	var theme = Theme.new()
	
	# Set the default font
	theme.set_default_font(font)
	theme.set_default_font_size(FONT_SIZE_PROMPT)
	
	# Apply theme to all UI elements
	apply_theme_to_ui(theme)
	
	# Apply specific font sizes to different UI elements
	customize_ui_elements(font)
	
	if OS.has_feature("debug"):
		print("ElMessiri font applied to all UI elements")

# Recursively apply the theme to all UI elements
func apply_theme_to_ui(theme: Theme):
	# Get the UI node
	var ui_node = get_parent()
	if not ui_node:
		push_error("UI parent node not found")
		return
	
	# Apply theme to all Control nodes under UI
	apply_theme_recursive(ui_node, theme)
	
	# Apply theme to debug display if it exists
	var debug_display = get_node_or_null("/root/Main/DebugUI/DebugOverlay/DebugDisplay")
	if debug_display:
		apply_theme_recursive(debug_display, theme)

# Apply theme to a node and all its children recursively
func apply_theme_recursive(node: Node, theme: Theme):
	# If it's a Control node, apply the theme
	if node is Control:
		node.theme = theme
	
	# Apply to all children
	for child in node.get_children():
		apply_theme_recursive(child, theme)

# Customize specific UI elements with appropriate font sizes
func customize_ui_elements(font: FontFile):
	# Get UI elements
	var ui_parent = get_parent()
	
	# Distance labels
	var current_distance_label = ui_parent.get_node_or_null("DistanceContainer/CurrentDistanceLabel")
	var best_distance_label = ui_parent.get_node_or_null("DistanceContainer/BestDistanceLabel")
	
	# Title and prompt labels
	var game_title_label = get_node_or_null("/root/Main/UI/GameTitleLabel")
	var boost_prompt_label = get_node_or_null("/root/Main/UI/BoostPromptLabel")
	var restart_prompt_label = get_node_or_null("/root/Main/UI/RestartPromptLabel")
	
	# Apply custom font settings to each element
	if current_distance_label:
		current_distance_label.add_theme_font_override("font", font)
		current_distance_label.add_theme_font_size_override("font_size", FONT_SIZE_DISTANCE)
	
	if best_distance_label:
		best_distance_label.add_theme_font_override("font", font)
		best_distance_label.add_theme_font_size_override("font_size", FONT_SIZE_BEST)
	
	if game_title_label:
		# Apply larger font size to title
		game_title_label.add_theme_font_override("font", font)
		game_title_label.add_theme_font_size_override("font_size", FONT_SIZE_TITLE)
		
		# Add outline to title text for better readability
		game_title_label.add_theme_constant_override("outline_size", OUTLINE_SIZE)
		game_title_label.add_theme_color_override("font_outline_color", OUTLINE_COLOR)
		
		# Make title area a bit larger to accommodate the bigger text
		var current_rect = game_title_label.get_rect()
		game_title_label.size = Vector2(current_rect.size.x + 50, current_rect.size.y + 20)
	
	if boost_prompt_label:
		boost_prompt_label.add_theme_font_override("font", font)
		boost_prompt_label.add_theme_font_size_override("font_size", FONT_SIZE_PROMPT)
		
		# Add a lighter outline to prompt text
		boost_prompt_label.add_theme_constant_override("outline_size", OUTLINE_SIZE * 0.6)
		boost_prompt_label.add_theme_color_override("font_outline_color", OUTLINE_COLOR)
	
	if restart_prompt_label:
		restart_prompt_label.add_theme_font_override("font", font)
		restart_prompt_label.add_theme_font_size_override("font_size", FONT_SIZE_PROMPT)
		
		# Add a lighter outline to prompt text
		restart_prompt_label.add_theme_constant_override("outline_size", OUTLINE_SIZE * 0.6)
		restart_prompt_label.add_theme_color_override("font_outline_color", OUTLINE_COLOR)
	
	# Apply font to debug display if it exists
	customize_debug_display(font)

# Apply font to debug display elements
func customize_debug_display(font: FontFile):
	var debug_display = get_node_or_null("/root/Main/DebugUI/DebugOverlay/DebugDisplay")
	if not debug_display:
		return
		
	# Find all Label nodes in the debug display and apply the font
	var labels = find_labels_recursive(debug_display)
	for label in labels:
		label.add_theme_font_override("font", font)
		# Keep the original font size for debugging information
		# label.add_theme_font_size_override("font_size", FONT_SIZE_DEBUG)

# Find all Label nodes recursively
func find_labels_recursive(node: Node) -> Array:
	var result = []
	
	if node is Label:
		result.append(node)
	
	for child in node.get_children():
		result.append_array(find_labels_recursive(child))
		
	return result