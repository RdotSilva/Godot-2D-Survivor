# TODO: Add manual save functionality
func on_save_pressed():
    pass


# TODO: Add manual save functionality
func on_delete_save_pressed():
    pass


# TODO: Replace this with MetaProgression's save functionality
func save():
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)