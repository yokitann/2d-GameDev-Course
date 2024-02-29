extends "../102_assemble_your_first_game.gd"


func _build() -> void:
	# Set editor state according to the tour's needs.
	queue_command(func reset_editor_state_for_tour():
		interface.canvas_item_editor_toolbar_grid_button.button_pressed = false
		interface.canvas_item_editor_toolbar_smart_snap_button.button_pressed = false
		interface.bottom_button_output.button_pressed = false
	)

	part_010_introduction()
	part_020_start()
	part_030_placing_rooms()


func part_010_introduction() -> void:
	# 0010: introduction
	context_set_2d()
	scene_open(SCENE_COMPLETED_PROJECT)
	bubble_move_and_anchor(interface.base_control, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_background(TEXTURE_BUBBLE_BACKGROUND)
	bubble_add_texture(TEXTURE_GDQUEST_LOGO)
	bubble_set_title("")
	bubble_add_text([bbcode_wrap_font_size("[center][b]Assemble your first game[/b][/center]", 32)])
	bubble_add_text([
		"[center]In this tour, you get to assemble your first game from premade parts.[/center]",
		"[center]You will put what you learned in the previous tour into practice.[/center]",
		"[center]You'll select and move nodes, create scene instances, use Godot's tilemap editor, and more.[/center]",
		"[center][b]Let's get started![/b][/center]",
	])
	bubble_set_footer(CREDITS_FOOTER_GDQUEST)
	queue_command(func wink_avatar(): bubble.avatar.do_wink())
	complete_step()


func part_020_start() -> void:
	# 0020: First look at game you'll make
	highlight_controls([interface.run_bar_play_button], true)
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.TOP_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_task_press_button(interface.run_bar_play_button)
	bubble_set_title("Let's make a little game")
	bubble_add_text(
		["By the end of this tutorial, you'll have a little playable game like this one.",
		"In this first part, you'll learn how to instantiate scenes, move entities, and draw bridges between rooms using a tilemap.",
		"You can try it right now: click the play icon in the top right of the editor to run the Godot project.",
		"Then, press [b]F8[/b] or close the game window to stop the game.",]
	)
	complete_step()

	# 0050: start section into
	queue_command(func bottom_panel_close():
		for button: Button in interface.bottom_buttons:
			button.button_pressed = false
	)
	bubble_set_title("Let's head to the starter scene and assemble the game.")
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	complete_step()

	# 0060: open start scene
	highlight_filesystem_paths([SCENE_START])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_LEFT)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title("Open the start scene")
	bubble_add_text([
		"In the [b]FileSystem Dock[/b] at the bottom-left, find and [b]double-click[/b] on the scene we will be working with: [b]" + SCENE_START.get_file() + "[/b].",
	])
	bubble_add_task(
		("Open the scene [b]%s[/b]." % SCENE_START.get_file()),
		1,
		func task_open_start_scene(_task: Task) -> int:
			var scene_root: Node = EditorInterface.get_edited_scene_root()
			if scene_root == null:
				return 0
			return 1 if scene_root.name == "Start" else 0
	)
	mouse_move_by_callable(
		func get_filesystem_dock_center() -> Vector2: return interface.filesystem_dock.get_global_rect().get_center(),
		get_tree_item_center_by_path.bind(interface.filesystem_tree, SCENE_START),
	)
	mouse_click()
	mouse_click()
	complete_step()

	# 0061: add player to start scene
	highlight_controls([interface.canvas_item_editor])
	highlight_filesystem_paths([SCENE_PLAYER])
	scene_select_nodes_by_path(["Start"])
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_move_and_anchor(interface.inspector_dock, Bubble.At.BOTTOM_RIGHT)
	bubble_set_title("Add Player Scene")
	bubble_add_text([
		"Now let's add a playable character to the scene! Drag and drop the player from the [b]FileSystem Dock[/b].",
	])
	bubble_add_task(
		"Add the [b]Player Scene[/b] to the [b]Scene[/b].",
		1,
		func(_task: Task) -> int:
			var player: Node = get_scene_node_by_path("Start/Player")
			return 1 if player != null else 0,
	)
	mouse_press()
	mouse_move_by_callable(
		get_tree_item_center_by_path.bind(interface.filesystem_tree, SCENE_PLAYER),
		get_control_global_center.bind(interface.canvas_item_editor)
	)
	mouse_release()
	canvas_item_editor_center_at(Vector2.ZERO)
	complete_step()

	# 0062: add player to start scene
	highlight_controls([interface.canvas_item_editor])
	highlight_scene_nodes_by_path(["Start/Player"], -1, true)
	bubble_set_title("Great job!")
	bubble_add_text([
		"Remember [b]a scene is a template[/b].",
		"By dragging the [b]Player Scene[/b] into the viewport in the center, you created a copy of the player template in the start scene.",
		"You can see in the [b]Scene Dock[/b] that there is now an [b]instance[/b] of the player scene in the start scene."
	])
	complete_step()


func part_030_placing_rooms() -> void:
	# 0070: section intro
	highlight_controls([interface.canvas_item_editor])
	bubble_set_title("Flesh out the environment")
	bubble_add_text([
		"We're lacking an environment for players to explore. Let's add a couple of rooms next.",
		"We've prepared rooms for you to place in the level."]
	)
	complete_step()

	# 0080: Turning on the grid
	highlight_controls([interface.canvas_item_editor_toolbar_grid_button], true)
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title("Snap to grid")
	bubble_add_text([
		"To place the rooms accurately, we will use grid snapping.",
		"You can toggle the grid on and off by clicking the [b]Grid[/b] button at the top (but keep it on!).",
	])
	bubble_add_task_toggle_button(interface.canvas_item_editor_toolbar_grid_button)
	complete_step()

	# 0081: grid size
	bubble_set_title("Change grid size")
	highlight_controls([interface.canvas_item_editor_toolbar_snap_options_button, interface.snap_options, interface.snap_options_ok_button])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"The grid is too small. Let's make it bigger.",
		"Click the the three vertical dots in the toolbar to access the grid settings.",
		"Then, click [b]Configure Snap...[/b], and change [b]Grid Step[/b] to [b]128px[/b] by [b]128px[/b]. Then, click [b]Ok[/b] to confirm.",
	])
	bubble_add_task_set_ranges({
		interface.snap_options_grid_step_controls[1]: 128,
		interface.snap_options_grid_step_controls[2]: 128,
	},
		interface.snap_options_grid_step_controls[0].text
	)
	complete_step()

	highlight_controls([interface.canvas_item_editor])
	bubble_move_and_anchor(interface.inspector_dock, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_set_title("How to zoom in and out")
	bubble_add_text([
		"Before adding rooms, let's learn to zoom and pan the view. You'll likely need to zoom out to place the rooms comfortably.",
		"To zoom in and out, use your [b]Mouse Wheel[/b].",
		"On touch displays and supported touchpads, you can pinch two fingers.",
		"Give it a try!"
	])
	complete_step()

	highlight_controls([interface.canvas_item_editor_zoom_widget], true)
	bubble_move_and_anchor(interface.inspector_dock, Bubble.At.BOTTOM_RIGHT)
	bubble_set_title("Using the zoom buttons")
	bubble_add_text([
		"Alternatively, you can click the [b]Zoom In[/b] button " + bbcode_generate_icon_image_string(ICONS_MAP.zoom_in) +  " and [b]Zoom Out[/b] " + bbcode_generate_icon_image_string(ICONS_MAP.zoom_out) +  " button in the top-left of the viewport to zoom in and out.",
	])
	complete_step()

	highlight_controls([interface.canvas_item_editor])
	bubble_move_and_anchor(interface.inspector_dock, Bubble.At.BOTTOM_RIGHT)
	bubble_set_title("How to pan the view")
	bubble_add_text([
		"To pan the view, click and drag using the [b]Middle Mouse Button[/b].",
		"If you don't have a mouse wheel, press the [b]Spacebar[/b] and click and drag with the [b]Left Mouse Button[/b].",
		"And if you're using a touchpad, you can keep the [b]Ctrl[/b] key down and slide two fingers over your touchpad.",
	])
	complete_step()

	# 0090: placing rooms
	highlight_controls([interface.canvas_item_editor])
	highlight_filesystem_paths(ROOM_SCENES)
	scene_select_nodes_by_path(["Start"])
	bubble_move_and_anchor(interface.inspector_dock, Bubble.At.BOTTOM_RIGHT)
	bubble_set_title("Add Rooms")
	bubble_add_text([
		"Now, you can start placing rooms!",
		"Drag and drop one of each room type (a, b, and c) from the [b]FileSystem Dock[/b].",
		"Place them so that the rooms do not overlap, and keep some space between them, as we'll connect the rooms with bridges later.",
		"Use the [b]Middle Mouse Button[/b] to pan the view if you need to.",
		"Use the [b]Mouse Wheel[/b] to zoom in and out.",
		"Don't worry if their position isn't perfect: we'll learn to move the rooms next.",
	])
	bubble_add_task(
		"Add [b]RoomA[/b] to the [b]Scene[/b].",
		1,
		func(_task: Task) -> int:
			var room_a_results: Array = get_scene_nodes_by_prefix("RoomA")
			return room_a_results.size() == 1
	)
	bubble_add_task(
		"Add [b]RoomB[/b] to the [b]Scene[/b].",
		1,
		func(_task: Task) -> int:
			var room_a_results: Array = get_scene_nodes_by_prefix("RoomB")
			return room_a_results.size() == 1
	)
	bubble_add_task(
		"Add [b]RoomC[/b] to the [b]Scene[/b].",
		1,
		func(_task: Task) -> int:
			var room_a_results: Array = get_scene_nodes_by_prefix("RoomC")
			return room_a_results.size() == 1
	)
	mouse_press()
	mouse_move_by_callable(
		get_tree_item_center_by_path.bind(interface.filesystem_tree, ROOM_SCENES.front()),
		get_control_global_center.bind(interface.canvas_item_editor)
	)
	mouse_release()
	canvas_item_editor_center_at(Vector2.ZERO, 0.5)
	complete_step()

	# 0091: placing rooms - done
	highlight_controls([interface.canvas_item_editor])
	highlight_scene_nodes_by_path(["Start/RoomA", "Start/RoomB", "Start/RoomC"])
	bubble_set_title("Great job!")
	scene_toggle_lock_nodes_by_path(TILEMAP_NODE_PATHS, false)
	bubble_add_text([
		"Your game now has 3 rooms.",
		"Did you notice how rooms snap to the grid?",
		"Next, let's learn to select and move the rooms directly in the viewport.",
	])
	complete_step()


	bubble_set_title("Move the rooms")
	scene_toggle_lock_nodes_by_path(TILEMAP_NODE_PATHS, true)
	highlight_controls([interface.canvas_item_editor_toolbar_select_button], true)
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"To move a node, like the rooms, you first need to [b]select[/b] it. You can use the [b]Select Mode[/b] for that.",
		"Ensure that the [b]Select Mode[/b] is active in the toolbar at the top.",
		"Its icon looks like a mouse cursor. If it's active, the icon will be blue.",
		"The select tool is active by default when you create a new project in Godot.",
	])
	complete_step()

	bubble_set_title("Select a room")
	highlight_controls([interface.canvas_item_editor])
	bubble_move_and_anchor(interface.inspector_dock, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"With the [b]Select Mode[/b] active, you can now select the rooms.",
		"To select a room, in the viewport, click on the room's little grey cross " + bbcode_generate_icon_image_string(ICONS_MAP.node_position_unselected) +  " with the [b]Left Mouse Button[/b].",
		"Once you've selected a room, the cross will turn orange " + bbcode_generate_icon_image_string(ICONS_MAP.node_position_selected) +  ".",
		"You can visually select any node that has a cross in the viewport.",
	])
	bubble_add_task(
		"Select one of the [b]Room[/b] nodes.",
		1,
		func(_task: Task) -> int:
			var selected_nodes := EditorInterface.get_selection().get_selected_nodes()
			var has_room_selected: bool = selected_nodes.any(func(node: Node) -> bool: return node.name.begins_with("Room"))
			return 1 if has_room_selected else 0,
	)
	complete_step()

	# TODO: add task to detect moving the room?
	bubble_set_title("Move with the select mode")
	highlight_controls([interface.canvas_item_editor])
	bubble_add_text([
		"Click and drag [b]on the cross[/b] to move the node. Try to move the rooms.",
		"If you need to pan the view, move the mouse while pressing the [b]Middle Mouse Button[/b].",
		"Alternatively, you can press down the [b]Spacebar[/b] and click and drag on the view with the [b]Left Mouse Button[/b].",
	])
	complete_step()

	bubble_set_title("Excellent!")
	highlight_controls([interface.canvas_item_editor])
	bubble_add_text([
		"Take a moment to move the rooms around and arrange them to your liking.",
		"Try to make the openings between rooms align a bit. It will make it easier to add bridges between them later.",
		"Also, try to keep some space between the rooms so you can add bridges between them later.",
		"Once you're happy with the layout, move on to the next step.",
	])
	complete_step()

	bubble_set_title("Moving the player to the first room")
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_add_text([
		"Next, we'll move the player inside [b]RoomA[/b] so that when running the game, the player starts in the room.",
		"We'll take this opportunity to learn another useful way of selecting and moving nodes.",
	])
	complete_step()

	bubble_set_title("Find RoomA")
	highlight_controls([interface.canvas_item_editor])
	highlight_scene_nodes_by_path(["Start/RoomA", "Start/RoomB", "Start/RoomC"])
	bubble_move_and_anchor(interface.inspector_dock, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"To find [b]RoomA[/b], we'll use the [b]Scene Dock[/b] and the viewport in the center.",
		"Click each of the room nodes and pay attention to the crosses in the viewport.",
		"Each cross " + bbcode_generate_icon_image_string(ICONS_MAP.node_position_unselected) +  " represents the position of one room. When you select a room, its cross turns orange: " + bbcode_generate_icon_image_string(ICONS_MAP.node_position_selected) +  ".",
		"Click on [b]RoomA[/b] to select it and find the room's location.",
	])
	bubble_add_task_select_node("RoomA")
	complete_step()

	bubble_set_title("Select the Player")
	highlight_scene_nodes_by_path(["Start/Player"])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.TOP_LEFT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"Let's select the player node to move it next. Click on [b]Player[/b] node in the [b]Scene Dock[/b] to select it.",
	])
	# TODO: change for pointer mouse or highlight
	mouse_move_by_callable(
		func() -> Vector2: return interface.scene_dock.get_global_rect().get_center(),
		get_tree_item_center_by_path.bind(interface.scene_tree, "Start/Player"),
	)
	mouse_click()
	bubble_add_task_select_node("Player")
	complete_step()

	bubble_set_title("Move the Player")
	highlight_controls([interface.canvas_item_editor_toolbar_move_button, interface.canvas_item_editor_viewport])
	bubble_move_and_anchor(interface.inspector_dock, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text([
		"To move a node, you can use the [b]Move Mode[/b] " + bbcode_generate_icon_image_string(ICONS_MAP.tool_move) + " in the toolbar. Click the move tool to activate it.",
		"With the move tool selected, click and drag anywhere on the viewport until the player is inside of [b]RoomA[/b].",
	])
	bubble_add_task(
		"Move the [b]Player[/b] inside of [b]RoomA[/b].",
		1,
		func(_task: Task) -> int:
			var scene_root: Node = EditorInterface.get_edited_scene_root()
			var player: Node2D = scene_root.find_child("Player")
			var room: Node2D = scene_root.find_child("RoomA")
			var tilemap: TileMap = room.get_node("Floor")
			var player_cell: Vector2i = tilemap.local_to_map(player.global_position - tilemap.global_position)
			return 1 if tilemap.get_cell_source_id(0, player_cell) != -1 else 0,
	)
	complete_step()

	bubble_set_title("Great job!")
	bubble_add_text([
		"You created several scene instances and learned to select and move them in the viewport.",
		"In the next part, you'll learn how to use the TileMap editor and Terrains to draw bridges that connect the rooms.",
	])

