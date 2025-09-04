if (world instanceof World) {
	ScorePlayerTeam _pt = world.getWorld().getScoreboard().getPlayersTeam(${input$name});
	if (_pt != null)
		world.getWorld().getScoreboard().removeTeam(_pt);
}