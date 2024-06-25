if (world instanceof World) {
	ScorePlayerTeam _pt = ((World) world).getScoreboard().getPlayersTeam(${input$name});
	if (_pt != null)
		_pt.setAllowFriendlyFire(${input$condition});
}