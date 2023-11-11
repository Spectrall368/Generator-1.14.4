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
<#assign model = "BipedModel">

<#if data.mobModelName == "Chicken">
	<#assign super = "new MobRenderer(renderManager, new ChickenModel(), " + data.modelShadowSize + "f);">
	<#assign model = "ChickenModel">
<#elseif data.mobModelName == "Cod">
	<#assign super = "new MobRenderer(renderManager, new CodModel(), " + data.modelShadowSize + "f);">
	<#assign model = "CodModel">
<#elseif data.mobModelName == "Cow">
	<#assign super = "new MobRenderer(renderManager, new CowModel(), " + data.modelShadowSize + "f);">
	<#assign model = "CowModel">
<#elseif data.mobModelName == "Creeper">
	<#assign super = "new MobRenderer(renderManager, new CreeperModel(), " + data.modelShadowSize + "f);">
	<#assign model = "CreeperModel">
<#elseif data.mobModelName == "Ghast">
	<#assign super = "new MobRenderer(renderManager, new GhastModel(), " + data.modelShadowSize + "f);">
	<#assign model = "GhastModel">
<#elseif data.mobModelName == "Ocelot">
	<#assign super = "new MobRenderer(renderManager, new OcelotModel(0), " + data.modelShadowSize + "f);">
	<#assign model = "OcelotModel">
<#elseif data.mobModelName == "Pig">
	<#assign super = "new MobRenderer(renderManager, new PigModel(), " + data.modelShadowSize + "f);">
	<#assign model = "PigModel">
<#elseif data.mobModelName == "Slime">
	<#assign super = "new MobRenderer(renderManager, new SlimeModel(0), " + data.modelShadowSize + "f);">
	<#assign model = "SlimeModel">
<#elseif data.mobModelName == "Salmon">
	<#assign super = "new MobRenderer(renderManager, new SalmonModel(), " + data.modelShadowSize + "f);">
	<#assign model = "SalmonModel">
<#elseif data.mobModelName == "Spider">
	<#assign super = "new MobRenderer(renderManager, new SpiderModel(), " + data.modelShadowSize + "f);">
	<#assign model = "SpiderModel">
<#elseif data.mobModelName == "Villager">
	<#assign super = "new MobRenderer(renderManager, new VillagerModel(0), " + data.modelShadowSize + "f);">
	<#assign model = "VillagerModel">
<#elseif data.mobModelName == "Silverfish">
	<#assign super = "new MobRenderer(renderManager, new SilverfishModel(), " + data.modelShadowSize + "f);">
	<#assign model = "SilverfishModel">
<#elseif data.mobModelName == "Witch">
	<#assign super = "new MobRenderer(renderManager, new WitchModel(0), " + data.modelShadowSize + "f);">
	<#assign model = "WitchModel">
<#elseif !data.isBuiltInModel()>
	<#assign super = "new MobRenderer(renderManager, new ${data.mobModelName}(), " + data.modelShadowSize + "f);">
	<#assign model = data.mobModelName>
<#else>
	<#assign super = "new BipedRenderer(renderManager, new BipedModel(), " + data.modelShadowSize + "f);">
	<#assign model = "BipedModel">
	<#assign humanoid = true>
</#if>

<#assign model = model + "<" + name + "Entity>">

public class ${name}Renderer extends <#if humanoid>Biped</#if>MobRenderer<${name}Entity, ${model}> {

	public ${name}Renderer(EntityRendererProvider.Context context) {
		<#if !humanoid>
		RenderingRegistry.registerEntityRenderingHandler(${name}Entity.class, renderManager -> ${super}
    <#if data.mobModelGlowTexture?has_content>this.addLayer(new GlowingLayer<>(this));</#if>
		<#else>
			RenderingRegistry.registerEntityRenderingHandler(CustomEntity.class, renderManager -> {
				BipedRenderer customRender = new BipedRenderer(renderManager, new BipedModel(), ${data.modelShadowSize}f);
				customRender.addLayer(new BipedArmorLayer(customRender, new BipedModel(0.5f), new BipedModel(1)));
				<#if data.mobModelGlowTexture?has_content>customRender.addLayer(new GlowingLayer<>(customRender));</#if>
				return customRender;
			});
		</#if>

		<#if data.mobModelGlowTexture?has_content>
		this.addLayer(new EyesLayer<${name}Entity, ${model}>(this) {
			@Override public RenderType renderType() {
				return RenderType.eyes(new ResourceLocation("${modid}:textures/entities/${data.mobModelGlowTexture}"));
			}
		});
		</#if>
	}

	<#if data.mobModelName == "Villager">
	@Override protected void scale(${name}Entity villager, PoseStack poseStack, float f) {
		poseStack.scale(0.9375f, 0.9375f, 0.9375f);
	}
	</#if>

	@Override public ResourceLocation getEntityTexture(${name}Entity entity) {
		return new ResourceLocation("${modid}:textures/entities/${data.mobModelTexture}");
	}

    <#if hasProcedure(data.transparentModelCondition)>
        @Override protected boolean isVisible(${name}Entity _ent) {
	        Entity entity = _ent;
	        Level world = entity.world;
	        double x = entity.posX;
	        double y = entity.posY;
	        double z = entity.posZ;
		    return !<@procedureOBJToConditionCode data.transparentModelCondition/>;
	    }
	</#if>
}
