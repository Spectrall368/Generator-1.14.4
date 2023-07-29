<#if input$shooter == "null">
new ${generator.map(field$projectile, "projectiles", 0)}(${generator.map(field$projectile, "projectiles", 1)}, projectileLevel)
<#else>
new Object() {
	public Entity getProjectile(World world, Entity shooter) {
        ThrowableEntity entityToSpawn;
        if (shooter instanceof LivingEntity)
        	entityToSpawn = new ${generator.map(field$throwableprojectile, "projectiles", 0)}(world, (LivingEntity) shooter);
        else
		entityToSpawn = new ${generator.map(field$projectile, "projectiles", 0)}(${generator.map(field$projectile, "projectiles", 1)}, world);
	entityToSpawn.setShooter(shooter);
	return entityToSpawn;
}}.getProjectile(projectileLevel, ${input$shooter})
</#if>
