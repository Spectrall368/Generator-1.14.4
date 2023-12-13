<#if input$shooter == "null">
new ${generator.map(field$projectile, "projectiles", 0)}(${generator.map(field$projectile, "projectiles", 1)}, projectileLevel)
<#else>
new Object() {
	public Entity getProjectile(World world, Entity shooter) {
		ThrowableEntity entityToSpawn = new ${generator.map(field$projectile, "projectiles", 0)}(${generator.map(field$projectile, "projectiles", 1)}, world.getWorld());
		entityToSpawn.shootingEntity = (shooter instanceof LivingEntity ? ((LivingEntity) shooter) : null);
		return entityToSpawn;
}}.getProjectile(projectileLevel, ${input$shooter})
</#if>
