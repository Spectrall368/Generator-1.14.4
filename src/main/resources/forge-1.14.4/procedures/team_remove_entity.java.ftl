{
	Entity _entityTeam = ${input$entity};
	ScorePlayerTeam _pt = _entityTeam.world.getScoreboard().getPlayersTeam(${input$name});
	if (_pt != null)
		_entityTeam.world.getScoreboard().removePlayerFromTeam(_entityTeam.getCachedUniqueIdString(), _pt);
}