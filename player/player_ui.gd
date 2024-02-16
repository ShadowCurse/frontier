extends Control

class_name PlayerUi

signal build_mode_enter_signal
signal build_mode_exit_signal
signal build_house_signal
signal build_gold_mine_signal
signal build_food_hut_signal
signal build_wood_cutter_signal
signal build_wall_signal

@onready var notification_panel: PanelContainer = $notification
@onready var notification_label: Label = $notification/MarginContainer/notification_label
@onready var notification_timer: Timer = $notification/notification_timer
@onready var health_bar: ProgressBar = $health/MarginContainer/health_bar
@onready var health_label: Label = $health/MarginContainer/health_label
@onready var resources_panel: PanelContainer = $resources_panel
@onready var build_panel: PanelContainer = $build_panel
@onready var city_buttons: PanelContainer = $city_buttons
@onready var population_label: Label = $resources_panel/MarginContainer/HBoxContainer/population_label
@onready var gold_label: Label = $resources_panel/MarginContainer/HBoxContainer/gold_label
@onready var food_label: Label = $resources_panel/MarginContainer/HBoxContainer/food_label
@onready var wood_label: Label = $resources_panel/MarginContainer/HBoxContainer/wood_label

enum State {
    Outside,
    City,
    Building 
}
var current_state: State = State.Outside

func _ready() -> void:
    pass

func _process(_delta: float) -> void:
    pass

func _unhandled_input(event: InputEvent) -> void:
    match self.current_state:
        State.Outside:
            pass
        State.City:
            pass
        State.Building:
            if event is InputEventMouseButton:
                self.hide_modes()
                self.build_mode_exit_signal.emit()
                self.current_state = State.City
    
func hide_modes() -> void:
    self.build_panel.visible = false

func enable_city_ui() -> void:
    self.resources_panel.visible = true
    self.city_buttons.visible = true
    
func disable_city_ui() -> void:
    self.resources_panel.visible = false
    self.build_panel.visible = false
    self.city_buttons.visible = false

func show_notification(text: String) -> void:
    self.notification_panel.visible = true
    self.notification_label.text = text
    self.notification_timer.start()

func update_health(current_health: int, max_health: int) -> void:
    var percent = float(current_health) / float(max_health)
    self.health_bar.set_value_no_signal(percent)
    self.health_label.text = "%d" % current_health

func update_population(new_population: int) -> void:
    self.population_label.text = "%d" % new_population
    
func update_gold(new_gold: int) -> void:
    self.gold_label.text = "%d" % new_gold
    
func update_food(new_food: int) -> void:
    self.food_label.text = "%d" % new_food
    
func update_wood(new_wood: int) -> void:
    self.wood_label.text = "%d" % new_wood

func on_notification_timer_timeout() -> void:
    self.notification_panel.visible = false

func on_build_mode_button_pressed() -> void:
    self.build_panel.visible = true
    self.build_mode_enter_signal.emit()
    self.current_state = State.Building
   
func on_house_button_pressed() -> void:
    self.hide_modes()
    self.build_house_signal.emit()
    
func on_gold_mine_button_pressed() -> void:
    self.hide_modes()
    self.build_gold_mine_signal.emit()
    
func on_food_hut_button_pressed() -> void:
    self.hide_modes()
    self.build_food_hut_signal.emit()
    
func on_wood_cutter_button_pressed() -> void:
    self.hide_modes()
    self.build_wood_cutter_signal.emit()
    
func on_wall_button_pressed() -> void:
    self.hide_modes()
    self.build_wall_signal.emit()
