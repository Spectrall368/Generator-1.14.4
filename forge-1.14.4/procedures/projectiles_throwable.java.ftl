<#if input$shooter == "null">
new ${generator.map(field$projectile, "projectiles", 0)}(${generator.map(field$projectile, "projectiles", 1)}, projectileLevel)
<#else>
new Object() {
	public Entity getProjectile(World world, Entity shooter) {
        ThrowableEntity _entityToSpawn;
        if (shooter instanceof LivingEntity)
        	_entityToSpawn = new ${generator.map(field$throwableprojectile, "projectiles", 0)}(world, (LivingEntity) shooter);
        else
		_entityToSpawn = new ${generator.map(field$projectile, "projectiles", 0)}(${generator.map(field$projectile, "projectiles", 1)}, world);
	_entityToSpawn.shootingEntity = (shooter instanceof LivingEntity ? (LivingEntity) shooter : null);
	return _entityToSpawn;
}}.getProjectile(projectileLevel, ${input$shooter})
</#if>
