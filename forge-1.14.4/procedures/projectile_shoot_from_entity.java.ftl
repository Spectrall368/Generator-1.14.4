{
	Entity _shootFrom = ${input$entity};
	World projectileLevel = _shootFrom.world;
	if (!projectileLevel.isRemote) {
		<#if input$projectile == "FireballEntity">Entity<#else>ProjectileItemEntity</#if> _entityToSpawn = ${input$projectile};
		_entityToSpawn.setPosition(_shootFrom.posX, _shootFrom.posY - 0.1, _shootFrom.posZ);
		_entityToSpawn.shoot(_shootFrom.getLookVec().x, _shootFrom.getLookVec().y, _shootFrom.getLookVec().z, ${opt.toFloat(input$speed)}, ${opt.toFloat(input$inaccuracy)});
		projectileLevel.addEntity(_entityToSpawn);
	}
}
