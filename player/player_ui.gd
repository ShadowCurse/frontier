extends Control

class_name PlayerUi

@onready var notification_panel: PanelContainer = $notification
@onready var notification_label: Label = $notification/MarginContainer/notification_label
@onready var notification_timer: Timer = $notification/notification_timer
@onready var health_bar: ProgressBar = $health/MarginContainer/health_bar
@onready var health_label: Label = $health/MarginContainer/health_label

func _ready() -> void:
    pass

func _process(_delta: float) -> void:
    pass

func show_notification(text: String) -> void:
    self.notification_panel.visible = true
    self.notification_label.text = text
    self.notification_timer.start()

func update_health(current_health: int, max_health: int) -> void:
    var percent = float(current_health) / float(max_health)
    self.health_bar.set_value_no_signal(percent)
    self.health_label.text = "%d" % current_health

func on_notification_timer_timeout() -> void:
    self.notification_panel.visible = false
