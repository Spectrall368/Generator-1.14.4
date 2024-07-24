if (world instanceof World) {
	ScorePlayerTeam _pt = ((World) world.getWorld()).getScoreboard().getTeam(${input$name});
	if (_pt != null)
		_pt.setNameTagVisibility(Team.Visible.${field$visibility});
}