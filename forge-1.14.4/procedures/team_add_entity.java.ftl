{
	Entity _entityTeam = ${input$entity};
	ScorePlayerTeam _pt = _entityTeam.world.getScoreboard().getPlayersTeam(${input$name});
	if (_pt != null) {
		if (_entityTeam instanceof PlayerEntity)
			_entityTeam.world.getScoreboard().addPlayerToTeam(((PlayerEntity) _entityTeam).getGameProfile().getName(), _pt);
		else
			_entityTeam.world.getScoreboard().addPlayerToTeam(_entityTeam.getCachedUniqueIdString(), _pt);
	}
}