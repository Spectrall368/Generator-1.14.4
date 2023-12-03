<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2023, Pylo, opensource contributors
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
package ${package}.client.renderer;

public class ${name}Renderer {

	public static class ModelRegisterHandler {

		@SubscribeEvent @OnlyIn(Dist.CLIENT) public void registerModels(ModelRegistryEvent event) {
			<#if data.bulletModel != "Default">
			RenderingRegistry.registerEntityRenderingHandler(${name}Entity.class, renderManager -> new CustomRender(renderManager));
			<#else>
			RenderingRegistry.registerEntityRenderingHandler(${name}Entity.class, renderManager -> new SpriteRenderer(renderManager, Minecraft.getInstance().getItemRenderer()));
			</#if>
		}

	}

	<#if data.bulletModel != "Default">
	@OnlyIn(Dist.CLIENT) public static class CustomRender extends EntityRenderer<${name}Entity> {
		private static final ResourceLocation texture = new ResourceLocation("${modid}:textures/entities/${data.customBulletModelTexture}");

		public CustomRender(EntityRendererManager renderManager) {
			super(renderManager);
		}

		@Override public void doRender(${name}Entity entityIn, double d, double d1, double d2, float f, float f1) {
				this.bindEntityTexture(bullet);
				GlStateManager.pushMatrix();
				GlStateManager.translatef((float) d, (float) d1, (float) d2);
				GlStateManager.rotatef(f, 0, 1, 0);
				GlStateManager.rotatef(90f - bullet.prevRotationPitch - (bullet.rotationPitch - bullet.prevRotationPitch) * f1, 1, 0, 0);
				EntityModel model = new ${data.bulletModel}();
				model.render(bullet, 0, 0, 0, 0, 0, 0.0625f);
				GlStateManager.popMatrix();
			}

		@Override public ResourceLocation getEntityTexture(${name}Entity entity) {
			return texture;
		}
	}

	<#if data.getModelCode()?? >
	${data.getModelCode().toString()
		.replace("ModelRenderer", "RendererModel").replace("extends ModelBase", "extends EntityModel<Entity>")
		.replace("GlStateManager.translate", "GlStateManager.translated")
		.replace("GlStateManager.scale", "GlStateManager.scaled")
		.replaceAll("setRotationAngles\\(float[\n\r\t\\s]+f,[\n\r\t\\s]+float[\n\r\t\\s]+f1,[\n\r\t\\s]+float[\n\r\t\\s]+f2,[\n\r\t\\s]+float[\n\r\t\\s]+f3,[\n\r\t\\s]+float[\n\r\t\\s]+f4,[\n\r\t\\s]+float[\n\r\t\\s]+f5,[\n\r\t\\s]+Entity[\n\r\t\\s]+e\\)",
					"setRotationAngles(Entity e, float f, float f1, float f2, float f3, float f4, float f5)")
		.replaceAll("setRotationAngles\\(float[\n\r\t\\s]+f,[\n\r\t\\s]+float[\n\r\t\\s]+f1,[\n\r\t\\s]+float[\n\r\t\\s]+f2,[\n\r\t\\s]+float[\n\r\t\\s]+f3,[\n\r\t\\s]+float[\n\r\t\\s]+f4,[\n\r\t\\s]+float[\n\r\t\\s]+f5,[\n\r\t\\s]+Entity[\n\r\t\\s]+entity\\)",
					"setRotationAngles(Entity entity, float f, float f1, float f2, float f3, float f4, float f5)")
		.replaceAll("setRotationAngles\\(f,[\n\r\t\\s]+f1,[\n\r\t\\s]+f2,[\n\r\t\\s]+f3,[\n\r\t\\s]+f4,[\n\r\t\\s]+f5,[\n\r\t\\s]+e\\)", "setRotationAngles(e, f, f1, f2, f3, f4, f5)")
		.replaceAll("setRotationAngles\\(f,[\n\r\t\\s]+f1,[\n\r\t\\s]+f2,[\n\r\t\\s]+f3,[\n\r\t\\s]+f4,[\n\r\t\\s]+f5,[\n\r\t\\s]+entity\\)", "setRotationAngles(entity, f, f1, f2, f3, f4, f5)")
	}
	</#if>
	</#if>

	@OnlyIn(value = Dist.CLIENT, _interface = IRendersAsItem.class)
	public static class ${name}Entity extends AbstractArrowEntity implements IRendersAsItem {
	
		public ${name}Entity(FMLPlayMessages.SpawnEntity packet, World world) {
			super(${JavaModName}Entities.${data.getModElement().getRegistryNameUpper()}, world);
		}
	
		public ${name}Entity(EntityType<? extends ${name}Entity> type, World world) {
			super(type, world);
		}
	
		public ${name}Entity(EntityType<? extends ${name}Entity> type, double x, double y, double z, World world) {
			super(type, x, y, z, world);
		}
	
		public ${name}Entity(EntityType<? extends ${name}Entity> type, LivingEntity entity, World world) {
			super(type, entity, world);
		}
	
		@Override public IPacket<?> createSpawnPacket() {
			return NetworkHooks.getEntitySpawningPacket(this);
		}
	
		@Override @OnlyIn(Dist.CLIENT) public ItemStack getItem() {
			<#if !data.bulletItemTexture.isEmpty()>
			return ${mappedMCItemToItemStackCode(data.bulletItemTexture, 1)};
			<#else>
			return ItemStack.EMPTY;
			</#if>
		}
	
		@Override protected ItemStack getArrowStack() {
			<#if !data.ammoItem.isEmpty()>
			return ${mappedMCItemToItemStackCode(data.ammoItem, 1)};
			<#else>
			return ItemStack.EMPTY;
			</#if>
		}
	
		@Override protected void arrowHit(LivingEntity entity) {
			super.arrowHit(entity);
			entity.setArrowCountInEntity(entity.getArrowCountInEntity() - 1); <#-- #53957 -->
		}
	
		<#if hasProcedure(data.onBulletHitsPlayer)>
		@Override public void onCollideWithPlayer(PlayerEntity entity) {
			super.onCollideWithPlayer(entity);
			<@procedureCode data.onBulletHitsPlayer, {
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
	
		<#if hasProcedure(data.onBulletHitsEntity)>
		@Override public void func_213868_a(EntityRayTraceResult entityHitResult) {
			super.func_213868_a(entityHitResult);
			<@procedureCode data.onBulletHitsEntity, {
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
	
		@Override public void tick() {
			super.tick();
	
			<#if hasProcedure(data.onBulletFlyingTick)>
				<@procedureCode data.onBulletFlyingTick, {
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
	
		public static ${name}Entity shoot(World world, LivingEntity entity, Random random, float power, double damage, int knockback) {
			${name}Entity entityarrow = new ${name}Entity(${JavaModName}Entities.${data.getModElement().getRegistryNameUpper()}, entity, world);
			entityarrow.shoot(entity.getLook(1).x, entity.getLook(1).y, entity.getLook(1).z, power * 2, 0);
			entityarrow.setSilent(true);
			entityarrow.setIsCritical(${data.bulletParticles});
			entityarrow.setDamage(damage);
			entityarrow.setKnockbackStrength(knockback);
			<#if data.bulletIgnitesFire>
				entityarrow.setFire(100);
			</#if>
			world.addEntity(entityarrow);
	
			world.playSound(null, entity.posX, entity.posY, entity.posZ, ForgeRegistries.SOUND_EVENTS
					.getValue(new ResourceLocation("${data.actionSound}")), SoundCategory.PLAYERS, 1, 1f / (random.nextFloat() * 0.5f + 1) + (power / 2));
	
			return entityarrow;
		}
	
		public static ${name}Entity shoot(LivingEntity entity, LivingEntity target) {
			${name}Entity entityarrow = new ${name}Entity(${JavaModName}Entities.${data.getModElement().getRegistryNameUpper()}, entity, entity.world);
			double dx = target.posX - entity.posX;
			double dy = target.posY + target.getEyeHeight() - 1.1;
			double dz = target.posZ - entity.posZ;
			entityarrow.shoot(dx, dy - entityarrow.posY + MathHelper.sqrt(dx * dx + dz * dz) * 0.2F, dz, ${data.bulletPower}f * 2, 12.0F);
	
			entityarrow.setSilent(true);
			entityarrow.setDamage(${data.bulletDamage});
			entityarrow.setKnockbackStrength(${data.bulletKnockback});
			entityarrow.setIsCritical(${data.bulletParticles});
			<#if data.bulletIgnitesFire>
				entityarrow.setFire(100);
			</#if>
			entity.world.addEntity(entityarrow);
			entity.world.playSound(null, entity.posX, entity.posY, entity.posZ, ForgeRegistries.SOUND_EVENTS
					.getValue(new ResourceLocation("${data.actionSound}")), SoundCategory.PLAYERS, 1, 1f / (new Random().nextFloat() * 0.5f + 1));
	
			return entityarrow;
		}
	}
}
<#-- @formatter:on -->
