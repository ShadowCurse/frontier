extends Control

class_name PlayerUi

@onready var notification_panel: PanelContainer = $notification
@onready var notification_label: Label = $notification/MarginContainer/notification_label
@onready var notification_timer: Timer = $notification/notification_timer
@onready var health_bar: ProgressBar = $left/VBoxContainer/health/MarginContainer/health_bar
@onready var health_label: Label = $left/VBoxContainer/health/MarginContainer/health_label
@onready var level_label: Label = $left/VBoxContainer/experience/MarginContainer/HBoxContainer/level_label
@onready var exp_bar: ProgressBar = $left/VBoxContainer/experience/MarginContainer/HBoxContainer/MarginContainer/exp_bar
@onready var exp_label: Label = $left/VBoxContainer/experience/MarginContainer/HBoxContainer/MarginContainer/exp_label
@onready var ui_minimap: Node2D = $top_right/VBoxContainer/map/MarginContainer/SubViewportContainer/SubViewport/ui_minimap
@onready var next_wave_time: Label = $top_right/VBoxContainer/next_wave_time/MarginContainer/HBoxContainer/next_wave_time

func _ready() -> void:
    pass

func _process(_delta: float) -> void:
    pass

func update_timer(time_left: float) -> void:
    var minutes = int(time_left) / 60
    var seconds = int(time_left) % 60
    if minutes != 0:
        self.next_wave_time.text = "%d : %d" % [minutes, seconds]
    else:
        self.next_wave_time.text = "%d" % seconds

func track_character(character: Character) -> void:
    self.ui_minimap.tracked_character = character

func show_notification(text: String) -> void:
    self.notification_panel.visible = true
    self.notification_label.text = text
    self.notification_timer.start()

func update_health(current_health: int, max_health: int) -> void:
    var percent = float(current_health) / float(max_health)
    self.health_bar.set_value_no_signal(percent)
    self.health_label.text = "%d" % current_health

func update_level(current_level: int) -> void:
    self.level_label.text = "%d" % current_level

func update_exp(current_exp: int, level_exp: int) -> void:
    var percent = float(current_exp) / float(level_exp)
    self.exp_bar.set_value_no_signal(percent)
    self.exp_label.text = "%d" % current_exp

func on_notification_timer_timeout() -> void:
    self.notification_panel.visible = false
