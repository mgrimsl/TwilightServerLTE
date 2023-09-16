class_name Robbin extends Champion

#var A1Template = AbilityNew.new(self)
var A1 : Ability
var ChampionName = "Robbin"
func _ready():
	A1 = $A1
	#A1.actor = self
	#add_child(A1Template)
	print("robbin ready")
	#print($A1.cooldown, " cd")
	maxHealth = 100
	currentHealth = 100
	#State["BaseStats"]["moveSpeed"] = 30

