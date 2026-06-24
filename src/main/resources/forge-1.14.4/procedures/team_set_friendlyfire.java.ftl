<@head>if (world instanceof World) {
	ScorePlayerTeam _pt = world.getWorld().getScoreboard().getTeam(${input$name});
	if (_pt != null) {
</@head>
		_pt.setAllowFriendlyFire(${input$condition});
<@tail>
	}
}</@tail>