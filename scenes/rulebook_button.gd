extends Button

func _ready():
	pressed.connect(open_pdf_file)

func open_pdf_file():
	var pdf_path = "res://rulebooks/dirules.pdf"
	var global_path = ProjectSettings.globalize_path(pdf_path)
	var open = OS.shell_open(global_path)
