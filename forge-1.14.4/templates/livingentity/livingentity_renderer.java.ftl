<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2022, Pylo, opensource contributors
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
<#include "../procedures.java.ftl">
package ${package}.client.renderer;
<#assign humanoid = false>
<#assign model = "PlayerModel">

<#if data.mobModelName == "Chicken">
	<#assign super = "super(context, new ChickenModel(), " + data.modelShadowSize + "f);">
	<#assign model = "ChickenModel">
<#elseif data.mobModelName == "Cod">
	<#assign super = "super(context, new CodModel(), " + data.modelShadowSize + "f);">
	<#assign model = "CodModel">
<#elseif data.mobModelName == "Cow">
	<#assign super = "super(context, new CowModel(), " + data.modelShadowSize + "f);">
	<#assign model = "CowModel">
<#elseif data.mobModelName == "Creeper">
	<#assign super = "super(context, new CreeperModel(), " + data.modelShadowSize + "f);">
	<#assign model = "CreeperModel">
<#elseif data.mobModelName == "Ghast">
	<#assign super = "super(context, new GhastModel(), " + data.modelShadowSize + "f);">
	<#assign model = "GhastModel">
<#elseif data.mobModelName == "Ocelot">
	<#assign super = "super(context, new OcelotModel(0.0F), " + data.modelShadowSize + "f);">
	<#assign model = "OcelotModel">
<#elseif data.mobModelName == "Pig">
	<#assign super = "super(context, new PigModel(), " + data.modelShadowSize + "f);">
	<#assign model = "PigModel">
<#elseif data.mobModelName == "Piglin">
	<#assign super = "super(context, new ZombieModel(), " + data.modelShadowSize + "f);">
	<#assign model = "PiglinModel">
	<#assign humanoid = true>
<#elseif data.mobModelName == "Slime">
	<#assign super = "super(context, new SlimeModel(16), " + data.modelShadowSize + "f);">
	<#assign model = "SlimeModel">
<#elseif data.mobModelName == "Salmon">
	<#assign super = "super(context, new SalmonModel(), " + data.modelShadowSize + "f);">
	<#assign model = "SalmonModel">
<#elseif data.mobModelName == "Spider">
	<#assign super = "super(context, new SpiderModel(), " + data.modelShadowSize + "f);">
	<#assign model = "SpiderModel">
<#elseif data.mobModelName == "Villager">
	<#assign super = "super(context, new VillagerModel(0.0F), " + data.modelShadowSize + "f);">
	<#assign model = "VillagerModel">
<#elseif data.mobModelName == "Silverfish">
	<#assign super = "super(context, new SilverfishModel(), " + data.modelShadowSize + "f);">
	<#assign model = "SilverfishModel">
<#elseif data.mobModelName == "Witch">
	<#assign super = "super(context, new WitchModel(0.0F), " + data.modelShadowSize + "f);">
	<#assign model = "WitchModel">
<#elseif !data.isBuiltInModel()>
	<#assign super = "super(context, new ${data.mobModelName}(), " + data.modelShadowSize + "f);">
	<#assign model = data.mobModelName>
<#else>
	<#assign super = "super(context, new PlayerModel(0.0F, false), " + data.modelShadowSize + "f);">
	<#assign model = "PlayerModel">
	<#assign humanoid = true>
</#if>

<#assign model = model + "<" + name + "Entity>">

public class ${name}Renderer extends <#if humanoid>Biped<#else>Mob</#if>Renderer<${name}Entity, ${model}> {

	public ${name}Renderer(EntityRendererManager context) {
		${super}

		<#if humanoid && data.mobModelName != "Piglin">
		this.addLayer(new BipedArmorLayer(this, new BipedModel(0.5F), new BipedModel(1.0F)));
		<#elseif humanoid && data.mobModelName == "Piglin">
		this.addLayer(new BipedArmorLayer(this, new ZombieModel(0.5F, true), new ZombieModel(1.0F, true)));
		</#if>

		<#if data.mobModelGlowTexture?has_content>
		this.addLayer(new ${name}EyesLayer<>(this));
		</#if>
	}

	<#if data.mobModelName == "Villager">
	@Override protected void preRenderCallback(${name}Entity villager, float f) {
		GlStateManager.scalef(0.9375f, 0.9375f, 0.9375f);
	}
	</#if>

	@Override public ResourceLocation getEntityTexture(${name}Entity entity) {
		return new ResourceLocation("${modid}:textures/entities/${data.mobModelTexture}");
	}

    <#if hasProcedure(data.transparentModelCondition)>
        @Override protected boolean isVisible(${name}Entity _ent) {
	        Entity entity = _ent;
	        World world = entity.world;
	        double x = entity.posX;
	        double y = entity.posY;
	        double z = entity.posZ;
		    return !<@procedureOBJToConditionCode data.transparentModelCondition/>;
	    }
    </#if>

    @OnlyIn(Dist.CLIENT) private static class ${name}EyesLayer<T extends LivingEntity> extends LayerRenderer<T, ${model}<T>> {
        private static final ResourceLocation ${data.getModElement().getRegistryNameUpper()}_EYES = new ResourceLocation("${modid}:textures/entities/${data.mobModelGlowTexture}");
	
        public ${name}EyesLayer(IEntityRenderer<T, ${model}<T>> er) {
		super(er);
	}
	
	public void render(T entityIn, float l1, float l2, float l3, float l4, float l5, float l6, float l7) {
		this.bindTexture(${data.getModElement().getRegistryNameUpper()}_EYES);
		GlStateManager.enableBlend();
	      	GlStateManager.disableAlphaTest();
	      	GlStateManager.blendFunc(GlStateManager.SourceFactor.ONE, GlStateManager.DestFactor.ONE);
	      	GlStateManager.disableLighting();
	      	GlStateManager.depthMask(!entityIn.isInvisible());
	      	int i = 61680;
	      	int j = 61680;
	      	int k = 0;
	      	GLX.glMultiTexCoord2f(GLX.GL_TEXTURE1, 61680.0F, 0.0F);
	      	GlStateManager.enableLighting();
	      	GlStateManager.color4f(1.0F, 1.0F, 1.0F, 1.0F);
	      	GameRenderer gamerenderer = Minecraft.getInstance().gameRenderer;
	      	gamerenderer.setupFogColor(true);
	      	this.getEntityModel().render(entityIn, l1, l2, l4, l5, l6, l7);
	      	gamerenderer.setupFogColor(false);
	      	this.func_215334_a(entityIn);
	      	GlStateManager.depthMask(true);
	      	GlStateManager.disableBlend();
	      	GlStateManager.enableAlphaTest();
	}
	
	public boolean shouldCombineTextures() {
		return false;
	}
    }
}
