extends RichTextLabel

var messages : Array[String] = [
	"If you like the game, consider [color=green][wave amp=25][url]supporting the developer[/url]",
	"Art by [color=#ABFE02][wave amp=25]SupercatLuigi player",
	"Made proudly with [color=#4D9FDC][wave amp=25]Godot",
	"[shake rate=66 level=17][color=red]Reason 7",
	"I lost 15 bucks because of this game (they gambled it away)",
	"Fun fact: the first few maps were made with a [shake rate=66 level=17][color=red]text editor",
	"I [shake rate=66 level=17][color=red]HATE[/color][/shake] mathijnhaat?",
	"💀",
	"Ik beklim een berg van mollen op de straat, dat kan ik het best nou beschrijf ik/mij mezelf als Tharoa, die kan ik heel goed op de saksefoon. je zal weten dat ik een pistol met tandpasta eet",
	"Flying porche reference?!?!",
	"Lekker hakken in de mijnen"
]

var rnd

func _ready() -> void:
	_choose_random_message()

func _on_meta_clicked(meta: Variant) -> void:
	OS.shell_open("https://bombs-per-minute-game.vercel.app/support")

func _choose_random_message():
	var _rnd = randi_range(0,messages.size() - 1)
	
	if rnd != _rnd:
		rnd = _rnd
	else: 
		if _rnd > 0:
			rnd = _rnd - 1
		else:
			rnd = _rnd + 1
	text = messages[rnd]

func _on_random_message_timer_timeout() -> void:
	_choose_random_message()
