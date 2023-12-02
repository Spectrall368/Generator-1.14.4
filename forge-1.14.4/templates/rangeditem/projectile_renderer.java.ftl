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

@OnlyIn(Dist.CLIENT) public class ${name}Renderer {

	public static class ModelRegisterHandler {

		@SubscribeEvent @OnlyIn(Dist.CLIENT) public void registerModels(ModelRegistryEvent event) {
			<#if data.bulletModel != "Default">
			RenderingRegistry.registerEntityRenderingHandler((EntityType.Builder.<${entity.getModElement().getName()}Entity>
					create(${entity.getModElement().getName()}Entity::new, EntityClassification.MISC).setCustomClientFactory(${entity.getModElement().getName()}Entity::new)
					.setShouldReceiveVelocityUpdates(true).setTrackingRange(64).setUpdateInterval(1).size(0.5f, 0.5f)), renderManager -> new CustomRender(renderManager));
			<#else>
			RenderingRegistry.registerEntityRenderingHandler((EntityType.Builder.<${entity.getModElement().getName()}Entity>
					create(${entity.getModElement().getName()}Entity::new, EntityClassification.MISC).setCustomClientFactory(${entity.getModElement().getName()}Entity::new)
					.setShouldReceiveVelocityUpdates(true).setTrackingRange(64).setUpdateInterval(1).size(0.5f, 0.5f)), renderManager -> new SpriteRenderer(renderManager, Minecraft.getInstance().getItemRenderer()));
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
}
<#-- @formatter:on -->
