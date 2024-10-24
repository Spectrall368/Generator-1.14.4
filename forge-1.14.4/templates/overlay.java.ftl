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
<#include "procedures.java.ftl">
package ${package}.client.screens;

@Mod.EventBusSubscriber({Dist.CLIENT}) public class ${name}Overlay {

	@SubscribeEvent(priority = EventPriority.${data.priority})
	<#if generator.map(data.overlayTarget, "screens") == "Ingame">
        public static void eventHandler(RenderGameOverlayEvent.Post event) {
            if (event.getType() == RenderGameOverlayEvent.ElementType.HELMET) {
                int w = event.getWindow().getScaledWidth();
                int h = event.getWindow().getScaledHeight();
	<#else>
        public static void eventHandler(GuiScreenEvent.DrawScreenEvent.Post event) {
            if (event.getGui() instanceof ${generator.map(data.overlayTarget, "screens")}) {
                int w = event.getGui().width;
                int h = event.getGui().height;
	</#if>

        World world = null;
        double x = 0;
        double y = 0;
        double z = 0;

        PlayerEntity entity = Minecraft.getInstance().player;
        if (entity != null) {
            world = entity.world;
            x = entity.posX;
            y = entity.posY;
            z = entity.posZ;
        }

        <#if data.hasTextures()>
            GlStateManager.disableDepthTest();
            GlStateManager.depthMask(false);
            GlStateManager.blendFuncSeparate(GlStateManager.SourceFactor.SRC_ALPHA, GlStateManager.DestFactor.ONE_MINUS_SRC_ALPHA,
                GlStateManager.SourceFactor.ONE, GlStateManager.DestFactor.ZERO);
            GlStateManager.color4f(1, 1, 1, 1);
            GlStateManager.disableAlphaTest();
        </#if>

        if (<@procedureOBJToConditionCode data.displayCondition/>) {
            <#if data.baseTexture?has_content>
		Minecraft.getInstance().getTextureManager().bindTexture(new ResourceLocation("${modid}:textures/screens/${data.baseTexture}"));
                Minecraft.getInstance().ingameGUI.blit(0, 0, 0, 0, w, h, w, h);
            </#if>

            <#list data.getComponentsOfType("Image") as component>
                <#if hasProcedure(component.displayCondition)>
                        if (<@procedureOBJToConditionCode component.displayCondition/>) {
                </#if>
                    	Minecraft.getInstance().getTextureManager().bindTexture(new ResourceLocation("${modid}:textures/screens/${component.image}"));
			Minecraft.getInstance().ingameGUI.blit(<@calculatePosition component/>, 0, 0,
                        ${component.getWidth(w.getWorkspace())}, ${component.getHeight(w.getWorkspace())},
                        ${component.getWidth(w.getWorkspace())}, ${component.getHeight(w.getWorkspace())});
                <#if hasProcedure(component.displayCondition)>}</#if>
            </#list>

            <#list data.getComponentsOfType("Label") as component>
                <#if hasProcedure(component.displayCondition)>
                    if (<@procedureOBJToConditionCode component.displayCondition/>)
                </#if>
                Minecraft.getInstance().fontRenderer.drawString(
                    <#if hasProcedure(component.text)><@procedureOBJToStringCode component.text/><#else>I18n.format("gui.${modid}.${registryname}.${component.getName()}")</#if>,
                    <@calculatePosition component/>, ${component.color.getRGB()});
            </#list>

			<#list data.getComponentsOfType("EntityModel") as component>
			    if (<@procedureOBJToConditionCode component.entityModel/> instanceof LivingEntity) {
			    	<#if hasProcedure(component.displayCondition)>
                        if (<@procedureOBJToConditionCode component.displayCondition/>)
                    </#if>
					InventoryScreen.drawEntityOnScreen(<@calculatePosition component=component x_offset=10 y_offset=20/>,
                        ${component.scale}, ${component.rotationX / 20.0}f, 0, (LivingEntity) <@procedureOBJToConditionCode component.entityModel/>);
			    }
			</#list>
        }

        <#if data.hasTextures()>
            GlStateManager.depthMask(true);
            GlStateManager.enableDepthTest();
            GlStateManager.enableAlphaTest();
            GlStateManager.color4f(1, 1, 1, 1);
        </#if>
        }
	}
}
<#macro calculatePosition component x_offset=0 y_offset=0>
	<#if component.anchorPoint.name() == "TOP_LEFT">
		${component.x + x_offset}, ${component.y + y_offset}
	<#elseif component.anchorPoint.name() == "TOP_CENTER">
		w / 2 + ${component.x - (213 - x_offset)}, ${component.y + y_offset}
	<#elseif component.anchorPoint.name() == "TOP_RIGHT">
		w - ${427 - (component.x + x_offset)}, ${component.y + y_offset}
	<#elseif component.anchorPoint.name() == "CENTER_LEFT">
		${component.x + x_offset}, h / 2 + ${component.y - (120 - y_offset)}
	<#elseif component.anchorPoint.name() == "CENTER">
		w / 2 + ${component.x - (213 - x_offset)}, h / 2 + ${component.y - (120 - y_offset)}
	<#elseif component.anchorPoint.name() == "CENTER_RIGHT">
		w - ${427 - (component.x + x_offset)}, h / 2 + ${component.y - (120 - y_offset)}
	<#elseif component.anchorPoint.name() == "BOTTOM_LEFT">
		${component.x + x_offset}, h - ${240 - (component.y + y_offset)}
	<#elseif component.anchorPoint.name() == "BOTTOM_CENTER">
		w / 2 + ${component.x - (213 - x_offset)}, h - ${240 - (component.y + y_offset)}
	<#elseif component.anchorPoint.name() == "BOTTOM_RIGHT">
		w - ${427 - (component.x + x_offset)}, h - ${240 - (component.y + y_offset)}
	</#if>
</#macro>
<#-- @formatter:on -->
