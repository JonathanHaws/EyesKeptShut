extends TextureButton
@export var venge_cost := 5
@export var new_amount := 1.0
@export var upgrade_key: String = "max_ammo"
@export var cost_group:= "cost_skilltree"
@export var preeq: Node
var upgrade_flag 
var preeq_flag

@export var disabled_modulate: Color = Color(1,1,1,0.5)
@export var hover_modulate: Color = Color(0.525,0.525,0.525,1.0)	

func _ready():
	
	upgrade_flag = Save.get_unique_key(self,"skill_node")
	if preeq: preeq_flag = Save.get_unique_key(preeq, "skill_node")
	
	if Save.data.has(upgrade_flag): disabled = true
	pressed.connect(_on_pressed)
	
	mouse_entered.connect(func(): 
		for n in get_tree().get_nodes_in_group(cost_group): 
			n.text = "COST: "+ str(venge_cost)
			)
	
	if disabled: modulate = disabled_modulate
	mouse_entered.connect(func(): if not disabled: modulate = hover_modulate)
	mouse_exited.connect(func(): if not disabled: modulate = Color(1,1,1,1))
	
	
func _on_pressed():
	if preeq and not Save.data.has(preeq_flag): return
	if Save.data["venge"] < venge_cost or Save.data.has(upgrade_flag): return
	Save.data["venge"] -= venge_cost
	
	Save.data[upgrade_key] = new_amount
	#print('upgraded ', upgrade_key, " ", new_amount)
	
	Save.data[upgrade_flag] = true
	disabled = true
	modulate = disabled_modulate
