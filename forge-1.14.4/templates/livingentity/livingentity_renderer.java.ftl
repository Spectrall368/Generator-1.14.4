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
<#include "../procedures.java.ftl">
package ${package}.client.renderer;

<#assign humanoid = false>
<#assign model = "BipedModel(0)">

<#if data.mobModelName == "Chicken">
	<#assign model = "ChickenModel()">
<#elseif data.mobModelName == "Cod">
	<#assign model = "CodModel()">
<#elseif data.mobModelName == "Cow">
	<#assign model = "CowModel()">
<#elseif data.mobModelName == "Creeper">
	<#assign model = "CreeperModel()">
<#elseif data.mobModelName == "Ghast">
	<#assign model = "GhastModel()">
<#elseif data.mobModelName == "Ocelot">
	<#assign model = "OcelotModel(0)">
<#elseif data.mobModelName == "Pig">
	<#assign model = "PigModel()">
<#elseif data.mobModelName == "Slime">
	<#assign model = "SlimeModel(0)">
<#elseif data.mobModelName == "Salmon">
	<#assign model = "SalmonModel()">
<#elseif data.mobModelName == "Spider">
	<#assign model = "SpiderModel()">
<#elseif data.mobModelName == "Villager">
	<#assign model = "VillagerModel(0)">
<#elseif data.mobModelName == "Silverfish">
	<#assign model = "SilverfishModel()">
<#elseif data.mobModelName == "Witch">
	<#assign model = "WitchModel(0)">
<#elseif !data.isBuiltInModel()>
	<#assign model = data.mobModelName + "()">
<#else>
	<#assign humanoid = true>
</#if>

<#if data.mobModelName == "Ocelot" || data.mobModelName == "Villager" || data.mobModelName == "Witch">
<#assign num = "0.0F">
<#elseif data.mobModelName == "Slime">
<#assign num = "16">
</#else>
<#assign num = "">
</#if>

<#assign exmodel = data.mobModelName + "Model" + "<" + name + "Entity>">
<#assign asmodel = data.mobModelName + "Model" + "(" + num + ")">

public class ${name}Renderer extends <#if humanoid>Biped</#if>Renderer<${name}Entity, ${exmodel}> {

	public static class ModelRegisterHandler {

	public ${name}Renderer(EntityRendererManager renderManagerIn) {
		super(<#if !data.isBuiltInModel()>renderManagerIn, new ${data.mobModelName}<#else> renderManagerIn, new ${asmodel}<#if>, ${data.modelShadowSize});
		<#if data.mobModelGlowTexture?has_content>this.addLayer(new GlowingLayer<>(this));</#if>
		
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
			com.mojang.blaze3d.platform.GLX.glMultiTexCoord2f(com.mojang.blaze3d.platform.GLX.GL_TEXTURE1, (float)j, (float)k);
			GlStateManager.color4f(1.0F, 1.0F, 1.0F, 1.0F);
			GameRenderer gamerenderer = Minecraft.getInstance().gameRenderer;
			gamerenderer.setupFogColor(true);
			((EntityModel<T>)this.getEntityModel()).render(entityIn, l1, l2, l4, l5, l6, l7);
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
	</#if>

	<#if data.mobModelName == "Villager">
	@Override protected void preRenderCallback(${name}Entity entitylivingbaseIn, float partialTickTime) {
		float f = 0.9375F;
		if (entitylivingbaseIn.isChild()) {
	        	f = (float)((double)f * 0.5D);
			this.shadowSize = 0.25F;
		} else {
			this.shadowSize = 0.5F;
	      	}
		GlStateManager.scalef(f, f, f);
	}
	</#if>

	@Override public ResourceLocation getTextureLocation(${name}Entity entity) {
		return new ResourceLocation("${modid}:textures/entities/${data.mobModelTexture}");
	}
}
