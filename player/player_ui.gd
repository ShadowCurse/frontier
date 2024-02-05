extends Control

class_name PlayerUi

@onready var notification_panel: PanelContainer = $notification
@onready var notification_label: Label = $notification/MarginContainer/notification_label
@onready var notification_timer: Timer = $notification/notification_timer

func _ready() -> void:
    pass

func _process(_delta: float) -> void:
    pass

func show_notification(text: String) -> void:
    self.notification_panel.visible = true
    self.notification_label.text = text
    self.notification_timer.start()

func on_notification_timer_timeout() -> void:
    self.notification_panel.visible = false
