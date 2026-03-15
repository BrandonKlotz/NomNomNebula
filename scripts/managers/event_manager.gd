extends Node

@warning_ignore_start("unused_signal")
@warning_ignore_start("untyped_declaration")

#region GameClock
signal on_world_ready
signal on_camera_shake
signal on_game_over

signal on_galaxy_collided(data: GalaxyData)

signal on_dash_used
signal on_dash_error
signal on_dash_fully_recovered
signal on_dash_recover_progress(progress: float)
#endregion

@warning_ignore_restore("unused_signal")
@warning_ignore_restore("untyped_declaration")
