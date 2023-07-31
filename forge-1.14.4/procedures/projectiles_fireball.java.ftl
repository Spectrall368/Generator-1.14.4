<#assign hasShooter = (input$shooter != "null")>
<#assign hasAcceleration = (input$ax != "/*@int*/0") || (input$ay != "/*@int*/0") || (input$az != "/*@int*/0")>
<#if (!hasShooter) && (!hasAcceleration)>
new ${generator.map(field$projectile, "projectiles", 0)}(${generator.map(field$projectile, "projectiles", 1)}, projectileLevel)
<#else>
new Object() {
	public Entity getFireball(World world<#if hasShooter>, Entity shooter</#if><#if hasAcceleration>, double ax, double ay, double az</#if>) {
		DamagingProjectileEntity _entityToSpawn = new ${generator.map(field$projectile, "projectiles", 0)}(${generator.map(field$projectile, "projectiles", 1)}, world);
		<#if hasShooter>_entityToSpawn.shootingEntity = (shooter instanceof LivingEntity ? (LivingEntity) shooter : null);</#if>
		<#if hasAcceleration>
		_entityToSpawn.accelerationX = ax;
		_entityToSpawn.accelerationY = ay;
		_entityToSpawn.accelerationZ = az;
        	if (_entityToSpawn instanceof FireballEntity)
            		((FireballEntity) _entityToSpawn).explosionPower = power;
		</#if>
		return _entityToSpawn;
}}.getFireball(projectileLevel<#if hasShooter>, ${input$shooter}</#if><#if hasAcceleration>, ${input$ax}, ${input$ay}, ${input$az}</#if>)
</#if>
