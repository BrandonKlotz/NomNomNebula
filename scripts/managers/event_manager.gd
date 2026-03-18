extends Node

@warning_ignore_start("unused_signal")
@warning_ignore_start("untyped_declaration")

#region GameClock
signal on_world_ready
signal on_camera_shake(strengh: float, time: float)
signal on_shock_wave(node)
signal on_game_state_changed(state: GameWorld.GameState)

signal on_galaxy_absorbed(data: GalaxyData)
signal on_tooltip_show(data: GalaxyData)
signal on_tooltip_hide
signal on_dash_used
signal on_dash_error
signal on_dash_fully_recovered
signal on_dash_udpated(data: Dictionary)
signal on_dash_recover_progress(progress: float)
signal on_buff_applied(data: Dictionary)
signal on_player_absorbed()
signal on_attracting_player
signal on_player_destabilized
signal on_stabilization_changed(data: Dictionary)
signal on_stabilization_max_changed
signal on_stabilization_warning
signal on_stabilization_warning_end
signal on_galaxies_updated(Array)
#endregion

@warning_ignore_restore("unused_signal")
@warning_ignore_restore("untyped_declaration")
