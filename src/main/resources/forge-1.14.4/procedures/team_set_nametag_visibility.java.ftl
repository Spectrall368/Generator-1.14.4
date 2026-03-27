<@head>if (world instanceof World) {
	ScorePlayerTeam _pt = world.getWorld().getScoreboard().getTeam(${input$name});
	if (_pt != null) {
</@head>
		_pt.setNameTagVisibility(Team.Visible.${field$visibility});
<@tail>
	}
}</@tail>