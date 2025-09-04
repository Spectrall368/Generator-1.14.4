<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2024, Pylo, opensource contributors
 #
 # This program is free software: you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
 # the Free Software Foundation, either version 3 of the License, or
 # (at your option) any later version.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 # You should have received a copy of the GNU General Public License
 # along with this program.  If not, see <https://www.gnu.org/licenses/>.
 #
 # Additional permission for code generator templates (*.ftl files)
 #
 # As a special exception, you may create a larger work that contains part or
 # all of the MCreator code generator templates (*.ftl files) and distribute
 # that work under terms of your choice, so long as that work isn't itself a
 # template for code generation. Alternatively, if you modify or redistribute
 # the template itself, you may (at your option) remove this special exception,
 # which will cause the template and the resulting code generator output files
 # to be licensed under the GNU General Public License without this special
 # exception.
-->

<#-- @formatter:off -->
<#include "../mcitems.ftl">
<#include "../procedures.java.ftl">
package ${package}.entity;

<#compress>
@OnlyIn(value = Dist.CLIENT, _interface = IRendersAsItem.class)
public class ${name}Entity extends AbstractArrowEntity implements IRendersAsItem {

	public static final ItemStack PROJECTILE_ITEM = ${mappedMCItemToItemStackCode(data.projectileItem)};

	public ${name}Entity(FMLPlayMessages.SpawnEntity packet, World world) {
		super(${JavaModName}Entities.${REGISTRYNAME}.get(), world);
		<#if data.disableGravity>
		setNoGravity(true);
		</#if>
	}

	public ${name}Entity(EntityType<? extends ${name}Entity> type, World world) {
		super(type, world);
		<#if data.disableGravity>
		setNoGravity(true);
		</#if>
	}

	public ${name}Entity(EntityType<? extends ${name}Entity> type, double x, double y, double z, World world) {
		super(type, x, y, z, world);
		<#if data.disableGravity>
		setNoGravity(true);
		</#if>
	}

	public ${name}Entity(EntityType<? extends ${name}Entity> type, LivingEntity entity, World world) {
		super(type, entity, world);
		<#if data.disableGravity>
		setNoGravity(true);
		</#if>
	}

	@Override public IPacket<?> createSpawnPacket() {
		return NetworkHooks.getEntitySpawningPacket(this);
	}

	@Override @OnlyIn(Dist.CLIENT) public ItemStack getItem() {
		return PROJECTILE_ITEM;
	}

	@Override protected ItemStack getArrowStack() {
		return PROJECTILE_ITEM;
	}

	@Override protected void arrowHit(LivingEntity entity) {
		super.arrowHit(entity);
		entity.setArrowCountInEntity(entity.getArrowCountInEntity() - 1); <#-- #53957 -->
	}

	<#if (data.modelWidth > 0.5) || (data.modelHeight > 0.5)>
	@Nullable @Override protected EntityRayTraceResult func_213866_a(Vec3d projectilePosition, Vec3d deltaPosition) {
		double d0 = Double.MAX_VALUE;
		Entity entity = null;
		AxisAlignedBB lookupBox = this.getBoundingBox();
		for (Entity entity1 : this.world.getEntitiesInAABBexcluding(this, lookupBox, (entityIn) -> !entityIn.isSpectator() && entityIn.isAlive() && entityIn.canBeCollidedWith() && (entityIn != this.getShooter() || this.ticksInAir >= 5) && (this.field_213878_az == null || !this.field_213878_az.contains(entityIn.getEntityId())))) {
			if (entity1 == this.getShooter()) continue;
			AxisAlignedBB aabb = entity1.getBoundingBox();
			if (aabb.intersects(lookupBox)) {
				double d1 = projectilePosition.squareDistanceTo(projectilePosition);
				if (d1 < d0) {
					entity = entity1;
					d0 = d1;
				}
			}
		}
		return entity == null ? null : new EntityRayTraceResult(entity);
	}

	private Direction determineHitDirection(AxisAlignedBB entityBox, AxisAlignedBB blockBox) {
		double dx = entityBox.getCenter().x - blockBox.getCenter().x;
		double dy = entityBox.getCenter().y - blockBox.getCenter().y;
		double dz = entityBox.getCenter().z - blockBox.getCenter().z;
		double absDx = Math.abs(dx);
		double absDy = Math.abs(dy);
		double absDz = Math.abs(dz);
		if (absDy > absDx && absDy > absDz) {
			return dy > 0 ? Direction.DOWN : Direction.UP;
		} else if (absDx > absDz) {
			return dx > 0 ? Direction.WEST : Direction.EAST;
		} else {
			return dz > 0 ? Direction.NORTH : Direction.SOUTH;
		}
	}
	</#if>

	<#if hasProcedure(data.onHitsPlayer)>
	@Override public void onCollideWithPlayer(PlayerEntity entity) {
		super.onCollideWithPlayer(entity);
		<@procedureCode data.onHitsPlayer, {
			"x": "this.posX",
			"y": "this.posY",
			"z": "this.posZ",
			"entity": "entity",
			"sourceentity": "this.getShooter()",
			"immediatesourceentity": "this",
			"world": "this.world"
		}/>
	}
	</#if>

	<#if hasProcedure(data.onHitsEntity)>
	@Override public void func_213868_a(EntityRayTraceResult entityHitResult) {
		super.func_213868_a(entityHitResult);
		<@procedureCode data.onHitsEntity, {
			"x": "this.posX",
			"y": "this.posY",
			"z": "this.posZ",
			"entity": "entityRayTraceResult.getEntity()",
			"sourceentity": "this.getShooter()",
			"immediatesourceentity": "this",
			"world": "this.world"
		}/>
	}
	</#if>

	<#if hasProcedure(data.onHitsBlock)>
	@Override public void onHit(RayTraceResult rayTraceResult) {
		super.onHit(rayTraceResult);

		if (rayTraceResult.getType() == RayTraceResult.Type.BLOCK) {
			BlockRayTraceResult blockHitResult = (BlockRayTraceResult) rayTraceResult;
	            	<@procedureCode data.onHitsBlock, {
		                "x": "blockHitResult.getPos().getX()",
		                "y": "blockHitResult.getPos().getY()",
		                "z": "blockHitResult.getPos().getZ()",
		                "entity": "this.getShooter()",
		                "immediatesourceentity": "this",
		                "world": "this.world"
	            	}/>
        	}
	}
	</#if>

	@Override public void tick() {
		super.tick();

		<#if (data.modelWidth > 0.5) || (data.modelHeight > 0.5)>
		if (!this.func_203047_q()) {
		    this.world.getCollisionShapes(this, this.getBoundingBox()).forEach(collision -> {
				for (AxisAlignedBB blockAABB : collision.toBoundingBoxList()) {
					if (this.getBoundingBox().intersects(blockAABB)) {
						BlockPos blockPos = new BlockPos((int) blockAABB.minX, (int) blockAABB.minY, (int) blockAABB.minZ);
						Vec3d intersectionPoint = new Vec3d((blockAABB.minX + blockAABB.maxX) / 2, (blockAABB.minY + blockAABB.maxY) / 2, (blockAABB.minZ + blockAABB.maxZ) / 2);
						Direction hitDirection = determineHitDirection(this.getBoundingBox(), blockAABB);
						this.onHit(new BlockRayTraceResult(intersectionPoint, hitDirection, blockPos, false));
					}
				}
			});
		}
		</#if>

		<#if hasProcedure(data.onFlyingTick)>
			<@procedureCode data.onFlyingTick, {
			  	"x": "this.posX",
			  	"y": "this.posY",
			  	"z": "this.posZ",
				"world": "this.world",
				"entity": "this.getShooter()",
				"immediatesourceentity": "this"
			}/>
		</#if>

		if (this.inGround)
			this.remove();
	}

 	public static ${name}Entity shoot(World world, LivingEntity entity, Random source) {
		return shoot(world, entity, source, ${data.power}f, ${data.damage}, ${data.knockback});
	}

	public static ${name}Entity shoot(World world, LivingEntity entity, Random source, float pullingPower) {
		return shoot(world, entity, source, pullingPower * ${data.power}f, ${data.damage}, ${data.knockback});
	}

	public static ${name}Entity shoot(World world, LivingEntity entity, Random random, float power, double damage, int knockback) {
		${name}Entity entityarrow = new ${name}Entity(${JavaModName}Entities.${REGISTRYNAME}.get(), entity, world);
		entityarrow.shoot(entity.getLook(1).x, entity.getLook(1).y, entity.getLook(1).z, power * 2, 0);
		entityarrow.setSilent(true);
		entityarrow.setIsCritical(${data.showParticles});
		entityarrow.setDamage(damage);
		entityarrow.setKnockbackStrength(knockback);
		<#if data.igniteFire>
			entityarrow.setFire(100);
		</#if>
		world.addEntity(entityarrow);

		<#if data.actionSound.toString()?has_content>
		world.playSound(null, entity.posX, entity.posY, entity.posZ, ForgeRegistries.SOUND_EVENTS
			.getValue(new ResourceLocation("${data.actionSound}")), SoundCategory.PLAYERS, 1, 1f / (random.nextFloat() * 0.5f + 1) + (power / 2));
   		</#if>

		return entityarrow;
	}

	public static ${name}Entity shoot(LivingEntity entity, LivingEntity target) {
		${name}Entity entityarrow = new ${name}Entity(${JavaModName}Entities.${REGISTRYNAME}.get(), entity, entity.world);
		double dx = target.posX - entity.posX;
		double dy = target.posY + target.getEyeHeight() - 1.1;
		double dz = target.posZ - entity.posZ;
		entityarrow.shoot(dx, dy - entityarrow.posY + MathHelper.sqrt(dx * dx + dz * dz) * 0.2F, dz, ${data.power}f * 2, 12.0F);

		entityarrow.setSilent(true);
		entityarrow.setDamage(${data.damage});
		entityarrow.setKnockbackStrength(${data.knockback});
		entityarrow.setIsCritical(${data.showParticles});
		<#if data.igniteFire>
			entityarrow.setFire(100);
		</#if>
		entity.world.addEntity(entityarrow);
  		<#if data.actionSound.toString()?has_content>
		entity.world.playSound(null, entity.posX, entity.posY, entity.posZ, ForgeRegistries.SOUND_EVENTS
				.getValue(new ResourceLocation("${data.actionSound}")), SoundCategory.PLAYERS, 1, 1f / (new Random().nextFloat() * 0.5f + 1));
    		</#if>

		return entityarrow;
	}
}
</#compress>
<#-- @formatter:on -->
