<#include "../procedures.java.ftl">
package ${package}.client.renderer;

@OnlyIn(Dist.CLIENT) public class ${name}Renderer {

	public static class ModelRegisterHandler {

		@SubscribeEvent @OnlyIn(Dist.CLIENT) public void registerModels(ModelRegistryEvent event) {
		<#if data.mobModelName == "Chicken">
				RenderingRegistry.registerEntityRenderingHandler(${name}Entity.class, renderManager -> new MobRenderer(renderManager, new ChickenModel(), ${data.modelShadowSize}f) {
					<#if data.mobModelGlowTexture?has_content>{ this.addLayer(new GlowingLayer<>(this)); }</#if>
					@Override protected ResourceLocation getEntityTexture(Entity entity) { return new ResourceLocation("${modid}:textures/entities/${data.mobModelTexture}"); }
					<@renderConditions/>
				});
            	<#elseif data.mobModelName == "Cod">
				RenderingRegistry.registerEntityRenderingHandler(${name}Entity.class, renderManager -> new MobRenderer(renderManager, new CodModel(), ${data.modelShadowSize}f) {
						<#if data.mobModelGlowTexture?has_content>{ this.addLayer(new GlowingLayer<>(this)); }</#if>
					@Override protected ResourceLocation getEntityTexture(Entity entity) { return new ResourceLocation("${modid}:textures/entities/${data.mobModelTexture}"); }
					<@renderConditions/>
				});
		<#elseif data.mobModelName == "Cow">
				RenderingRegistry.registerEntityRenderingHandler(${name}Entity.class, renderManager -> new MobRenderer(renderManager, new CowModel(), ${data.modelShadowSize}f) {
					<#if data.mobModelGlowTexture?has_content>{ this.addLayer(new GlowingLayer<>(this)); }</#if>
					@Override protected ResourceLocation getEntityTexture(Entity entity) { return new ResourceLocation("${modid}:textures/entities/${data.mobModelTexture}"); }
					<@renderConditions/>
				});
		<#elseif data.mobModelName == "Creeper">
				RenderingRegistry.registerEntityRenderingHandler(${name}Entity.class, renderManager -> new MobRenderer(renderManager, new CreeperModel(), ${data.modelShadowSize}f) {
					<#if data.mobModelGlowTexture?has_content>{ this.addLayer(new GlowingLayer<>(this)); }</#if>
					@Override protected ResourceLocation getEntityTexture(Entity entity) { return new ResourceLocation("${modid}:textures/entities/${data.mobModelTexture}"); }
					<@renderConditions/>
				});
		<#elseif data.mobModelName == "Ghast">
				RenderingRegistry.registerEntityRenderingHandler(${name}Entity.class, renderManager -> new MobRenderer(renderManager, new GhastModel(), ${data.modelShadowSize}f) {
					<#if data.mobModelGlowTexture?has_content>{ this.addLayer(new GlowingLayer<>(this)); }</#if>
					@Override protected ResourceLocation getEntityTexture(Entity entity) { return new ResourceLocation("${modid}:textures/entities/${data.mobModelTexture}"); }
					<@renderConditions/>
				});
            	<#elseif data.mobModelName == "Ocelot">
				RenderingRegistry.registerEntityRenderingHandler(${name}Entity.class, renderManager -> new MobRenderer(renderManager, new OcelotModel(0), ${data.modelShadowSize}f) {
						<#if data.mobModelGlowTexture?has_content>{ this.addLayer(new GlowingLayer<>(this)); }</#if>
					@Override protected ResourceLocation getEntityTexture(Entity entity) { return new ResourceLocation("${modid}:textures/entities/${data.mobModelTexture}"); }
					<@renderConditions/>
				});
		<#elseif data.mobModelName == "Pig">
				RenderingRegistry.registerEntityRenderingHandler(${name}Entity.class, renderManager -> new MobRenderer(renderManager, new PigModel(), ${data.modelShadowSize}f) {
					<#if data.mobModelGlowTexture?has_content>{ this.addLayer(new GlowingLayer<>(this)); }</#if>
					@Override protected ResourceLocation getEntityTexture(Entity entity) { return new ResourceLocation("${modid}:textures/entities/${data.mobModelTexture}"); }
					<@renderConditions/>
				});
            	<#elseif data.mobModelName == "Salmon">
				RenderingRegistry.registerEntityRenderingHandler(${name}Entity.class, renderManager -> new MobRenderer(renderManager, new SalmonModel(), ${data.modelShadowSize}f) {
						<#if data.mobModelGlowTexture?has_content>{ this.addLayer(new GlowingLayer<>(this)); }</#if>
					@Override protected ResourceLocation getEntityTexture(Entity entity) { return new ResourceLocation("${modid}:textures/entities/${data.mobModelTexture}"); }
					<@renderConditions/>
				});
		<#elseif data.mobModelName == "Slime">
				RenderingRegistry.registerEntityRenderingHandler(${name}Entity.class, renderManager -> new MobRenderer(renderManager, new SlimeModel(0), ${data.modelShadowSize}f) {
					<#if data.mobModelGlowTexture?has_content>{ this.addLayer(new GlowingLayer<>(this)); }</#if>
					@Override protected ResourceLocation getEntityTexture(Entity entity) { return new ResourceLocation("${modid}:textures/entities/${data.mobModelTexture}"); }
					<@renderConditions/>
				});
		<#elseif data.mobModelName == "Spider">
			RenderingRegistry.registerEntityRenderingHandler(${name}Entity.class, renderManager -> new MobRenderer(renderManager, new SpiderModel(), ${data.modelShadowSize}f) {
					<#if data.mobModelGlowTexture?has_content>{ this.addLayer(new GlowingLayer<>(this)); }</#if>
					@Override protected ResourceLocation getEntityTexture(Entity entity) { return new ResourceLocation("${modid}:textures/entities/${data.mobModelTexture}"); }
					<@renderConditions/>
				});
		<#elseif data.mobModelName == "Villager">
				RenderingRegistry.registerEntityRenderingHandler(${name}Entity.class, renderManager -> new MobRenderer(renderManager, new VillagerModel(0), ${data.modelShadowSize}f) {
					<#if data.mobModelGlowTexture?has_content>{ this.addLayer(new GlowingLayer<>(this)); }</#if>
					@Override protected ResourceLocation getEntityTexture(Entity entity) { return new ResourceLocation("${modid}:textures/entities/${data.mobModelTexture}"); }
					<@renderConditions/>
				});
            	<#elseif data.mobModelName == "Witch">
				RenderingRegistry.registerEntityRenderingHandler(${name}Entity.class, renderManager -> new MobRenderer(renderManager, new WitchModel(0), ${data.modelShadowSize}f) {
						<#if data.mobModelGlowTexture?has_content>{ this.addLayer(new GlowingLayer<>(this)); }</#if>
					@Override protected ResourceLocation getEntityTexture(Entity entity) { return new ResourceLocation("${modid}:textures/entities/${data.mobModelTexture}"); }
					<@renderConditions/>
				});
		<#elseif data.mobModelName == "Silverfish">
				RenderingRegistry.registerEntityRenderingHandler(${name}Entity.class, renderManager -> new MobRenderer(renderManager, new SilverfishModel(), ${data.modelShadowSize}f) {
					<#if data.mobModelGlowTexture?has_content>{ this.addLayer(new GlowingLayer<>(this)); }</#if>
					@Override protected ResourceLocation getEntityTexture(Entity entity) { return new ResourceLocation("${modid}:textures/entities/${data.mobModelTexture}"); }
					<@renderConditions/>
				});
		<#elseif !data.isBuiltInModel()>
				RenderingRegistry.registerEntityRenderingHandler(${name}Entity.class, renderManager -> {
					return new MobRenderer(renderManager, new ${data.mobModelName}(), ${data.modelShadowSize}f) {
					<#if data.mobModelGlowTexture?has_content>{ this.addLayer(new GlowingLayer<>(this)); }</#if>
					@Override protected ResourceLocation getEntityTexture(Entity entity) { return new ResourceLocation("${modid}:textures/entities/${data.mobModelTexture}"); }
					<@renderConditions/>
				};
			});
		<#else>
			RenderingRegistry.registerEntityRenderingHandler(${name}Entity.class, renderManager -> {
				BipedRenderer customRender = new BipedRenderer(renderManager, new BipedModel(), ${data.modelShadowSize}f) {
					@Override protected ResourceLocation getEntityTexture(Entity entity) { return new ResourceLocation("${modid}:textures/entities/${data.mobModelTexture}"); }
					<@renderConditions/>
				};
				customRender.addLayer(new BipedArmorLayer(customRender, new BipedModel(0.5f), new BipedModel(1)));
				<#if data.mobModelGlowTexture?has_content>customRender.addLayer(new GlowingLayer<>(customRender));</#if>
				return customRender;
			});
		</#if>


		<#if data.ranged && data.rangedItemType == "Default item" && !data.rangedAttackItem.isEmpty()>
		RenderingRegistry.registerEntityRenderingHandler(${name}EntityProjectile.class, renderManager -> new SpriteRenderer(renderManager, Minecraft.getInstance().getItemRenderer()));
		</#if>
	}
	}

	<#if data.mobModelGlowTexture?has_content>
	@OnlyIn(Dist.CLIENT) private static class GlowingLayer<T extends Entity, M extends EntityModel<T>> extends LayerRenderer<T, M> {
		private static final ResourceLocation GLOW_TEXTURE = new ResourceLocation("${modid}:textures/entities/${data.mobModelGlowTexture}");

		public GlowingLayer(IEntityRenderer<T, M> er) {
			super(er);
		}

		public void render(T entityIn, float l1, float l2, float l3, float l4, float l5, float l6, float l7) {
			this.bindTexture(GLOW_TEXTURE);
			GlStateManager.enableBlend();
			GlStateManager.disableAlphaTest();
			GlStateManager.blendFunc(GlStateManager.SourceFactor.ONE, GlStateManager.DestFactor.ONE);
			GlStateManager.depthMask(!entityIn.isInvisible());
			int i = 61680;
			int j = i % 65536;
			int k = i / 65536;
			com.mojang.blaze3d.platform.GLX.glMultiTexCoord2f(com.mojang.blaze3d.platform.GLX.GL_TEXTURE1, (float) j, (float) k);
			GlStateManager.color4f(1.0F, 1.0F, 1.0F, 1.0F);
			GameRenderer gamerenderer = Minecraft.getInstance().gameRenderer;
			gamerenderer.setupFogColor(true);
			((EntityModel<T>)this.getEntityModel()).render(entityIn, l1, l2, l4, l5, l6, l7);
			gamerenderer.setupFogColor(false);
			i = entityIn.getBrightnessForRender();
			j = i % 65536;
			k = i / 65536;
			com.mojang.blaze3d.platform.GLX.glMultiTexCoord2f(com.mojang.blaze3d.platform.GLX.GL_TEXTURE1, (float) j, (float) k);
			this.func_215334_a(entityIn);
			GlStateManager.depthMask(true);
			GlStateManager.disableBlend();
			GlStateManager.enableAlphaTest();
		}

		public boolean shouldCombineTextures() {
			return false;
		}
	}
	</#if>

	<#if data.getModelCode()?? && !data.isBuiltInModel() >
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
}
<#macro renderConditions>
    <#if hasProcedure(data.transparentModelCondition)>
        @Override protected boolean isVisible(LivingEntity _ent) {
	        Entity entity = _ent;
	        World world = entity.world;
	        double x = entity.posX;
	        double y = entity.posY;
	        double z = entity.posZ;
		    return !<@procedureOBJToConditionCode data.transparentModelCondition/>;
	    }
	</#if>
</#macro>
