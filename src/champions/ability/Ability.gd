class_name Ability extends Action

@export var projectileTemplate : Projectile
@export var effect : Script
@export var multiplayerSpawner : MultiplayerSpawner
@export var damage = 20
@export var cost = 10 #add to json
@export var allyCast = false
@export var despawnAtDest = true
@export var duration = -1
@export var CDTimeLeft = 0
@export var cd = false

var projectileScn : PackedScene
var projectile
var activeProjectiles = []
var tracking = true

signal onHit(body)
signal atDest(dest)
signal durationEnd()

func _ready():
	visible = false;
	actor = get_parent()
	if projectileTemplate:
		projectileScn = PackedScene.new()
		projectileScn.pack((projectileTemplate))
		projectile = projectileScn.instantiate()

func action():
	CDTimeLeft = cooldown
	if projectileScn:
		spawnProjectile()
	if duration > 0:
		startDurationTimer()
	
func spawnProjectile():
	projectile.base = false
	projectile.visible = true
	projectile.target = target
	projectile.actor = actor
	projectile.onHit.connect(_on_hit)
	projectile.atDest.connect(_on_at_dest)
	projectile.zoneLeft.connect(_on_zone_left)
	multiplayerSpawner.spawn_function = (func(data, projectile): 
		return projectile
		).bind(projectile)
	multiplayerSpawner.spawn({"champion" : actor.ChampionName, "ability" : name})
	activeProjectiles.push_back(projectile)
	projectile = projectileScn.instantiate()

func startDurationTimer():
	var timer = Timer.new()
	timer.wait_time = duration
	timer.autostart = true
	timer.timeout.connect(_on_duration_timeout.bind(timer, activeProjectiles.back()))
	add_child(timer)

func despawnProjectile(pro):
	activeProjectiles.erase(pro)
	pro.queue_free()
	
func _process(delta):
	if CDTimeLeft > 0:
		cd = false
		CDTimeLeft -= delta
	else:
		cd = true

func _on_channel(action):
	pass

func _on_channel_complete(action):
	pass

func _on_channel_cancled(action):
	pass

func _on_hit(proj, body):
	if body != actor:
		body.currentHealth -= damage

func _on_at_dest(proj, dest):
	if despawnAtDest:
		despawnProjectile(proj)

func _on_duration_timeout(timer, pro):
	timer.stop()
	timer.queue_free()
	despawnProjectile(pro)
	
func _on_zone_left(proj, body):
	pass

func doNothing(a,b):
	return true
	
