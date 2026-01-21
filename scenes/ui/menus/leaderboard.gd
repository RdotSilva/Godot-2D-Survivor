extends CanvasLayer

signal leaderboard_closed

@onready var score_rows_container = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ScoreScrollContainer/ScoreRowsContainer
@onready var scroll_container = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ScoreScrollContainer
@onready var close_button = $CloseButton

func _ready():
	# Wait a frame for layout to be ready
	await get_tree().process_frame
	
	populate_leaderboard()
	close_button.pressed.connect(on_close_button_pressed)

func populate_leaderboard():
	# Clear existing rows
	for child in score_rows_container.get_children():
		child.queue_free()
	
	# Get top scores from LeaderboardManager
	var top_scores = LeaderboardManager.get_top_scores()
	
	# Create a row for each score
	for score_entry in top_scores:
		create_score_row(score_entry)
	
	# If no scores, show a message
	if top_scores.is_empty():
		var empty_label = Label.new()
		empty_label.layout_mode = 2  # Container mode
		empty_label.text = "No scores yet. Play to set a record!"
		empty_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		score_rows_container.add_child(empty_label)

func create_score_row(score_entry: Dictionary):
	# Create HBoxContainer for the row
	var row_container = HBoxContainer.new()
	row_container.layout_mode = 2  # Container mode
	row_container.add_theme_constant_override("separation", 8)
	
	# Name label (left-aligned)
	var name_label = Label.new()
	name_label.layout_mode = 2  # Container mode
	name_label.text = score_entry.get("name", "Unknown")
	name_label.add_theme_font_size_override("font_size", 16)
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row_container.add_child(name_label)
	
	# Score label (right-aligned)
	var score_label = Label.new()
	score_label.layout_mode = 2  # Container mode
	score_label.text = str(int(score_entry.get("score", 0)))
	score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	score_label.add_theme_font_size_override("font_size", 16)
	score_label.custom_minimum_size = Vector2(80, 0)
	row_container.add_child(score_label)
	
	# Level label (right-aligned)
	var level_label = Label.new()
	level_label.layout_mode = 2  # Container mode
	level_label.text = str(score_entry.get("level", 0))
	level_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	level_label.add_theme_font_size_override("font_size", 16)
	level_label.custom_minimum_size = Vector2(60, 0)
	row_container.add_child(level_label)
	
	# Time label (right-aligned, formatted as MM:SS)
	var time_label = Label.new()
	time_label.layout_mode = 2  # Container mode
	var time_elapsed = score_entry.get("time_elapsed", 0.0)
	time_label.text = format_time(time_elapsed)
	time_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	time_label.add_theme_font_size_override("font_size", 16)
	time_label.custom_minimum_size = Vector2(60, 0)
	row_container.add_child(time_label)
	
	# Add row to container
	score_rows_container.add_child(row_container)

func format_time(seconds: float) -> String:
	var minutes = int(seconds) / 60
	var secs = int(seconds) % 60
	return "%02d:%02d" % [minutes, secs]

func on_close_button_pressed():
	leaderboard_closed.emit()
	queue_free()
