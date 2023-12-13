<#if input$shooter == "null">
new ${generator.map(field$projectile, "projectiles", 0)}(${generator.map(field$projectile, "projectiles", 1)}, projectileLevel)
<#else>
new Object() {
	public Entity getProjectile(World world, Entity shooter) {
		ProjectileEntity entityToSpawn = new ${generator.map(field$projectile, "projectiles", 0)}(${generator.map(field$projectile, "projectiles", 1)}, world.getWorld());
		entityToSpawn.setShooter(shooter);
		return entityToSpawn;
}}.getProjectile(projectileLevel, ${input$shooter})
</#if>
