extends Control

signal start_signal
signal settings_signal
signal exit_signal

func _ready() -> void:
    pass

func _process(_delta: float) -> void:
    pass

func on_start_pressed() -> void:
    self.start_signal.emit()

func on_settings_pressed() -> void:
    self.settings_signal.emit()

func on_exit_pressed() -> void:
    self.exit_signal.emit()
