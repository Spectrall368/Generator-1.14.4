<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2020 Pylo and contributors
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
package ${package}.client.gui;
<#assign mx = data.W - data.width>
<#assign my = data.H - data.height>

public class ${name}Screen extends ContainerScreen<${name}Menu> {

	private final static HashMap<String, Object> guistate = ${name}Menu.guistate;

	private final World world;
	private final int x, y, z;
	private final PlayerEntity entity;

	<#list data.components as component>
		<#if component.getClass().getSimpleName() == "TextField">
	    TextFieldWidget ${component.getName()};
		<#elseif component.getClass().getSimpleName() == "Checkbox">
	    CheckboxButton ${component.getName()};
		</#if>
	</#list>

	public ${name}Screen(${name}Menu container, PlayerInventory inventory, ITextComponent text) {
		super(container, inventory, text);
		this.world = container.world;
		this.x = container.x;
		this.y = container.y;
		this.z = container.z;
		this.entity = container.entity;
		this.xSize = ${data.width};
		this.ySize = ${data.height};
	}

	<#if data.doesPauseGame>
	@Override public boolean isPauseScreen() {
		return true;
	}
	</#if>

	<#if data.renderBgLayer>
	private static final ResourceLocation texture = new ResourceLocation("${modid}:textures/screens/${registryname}.png" );
	</#if>

	@Override public void render(int mouseX, int mouseY, float partialTicks) {
		this.renderBackground();
		super.render(mouseX, mouseY, partialTicks);
		this.renderHoveredToolTip(mouseX, mouseY);

		<#list data.components as component>
			<#if component.getClass().getSimpleName() == "TextField">
				${component.name}.render(mouseX, mouseY, partialTicks);
			</#if>
		</#list>
	}

	@Override protected void drawGuiContainerBackgroundLayer(float partialTicks, int gx, int gy) {
		GlStateManager.color4f(1, 1, 1, 1);
		GlStateManager.enableBlend();
		GlStateManager.blendFuncSeparate(GlStateManager.SourceFactor.SRC_ALPHA, GlStateManager.DestFactor.ONE_MINUS_SRC_ALPHA, GlStateManager.SourceFactor.ONE, GlStateManager.DestFactor.ZERO);

		<#if data.renderBgLayer>
		Minecraft.getInstance().getTextureManager().bindTexture(texture);
		int k = (this.width - this.xSize) / 2;
		int l = (this.height - this.ySize) / 2;
		this.blit(k, l, 0, 0, this.xSize, this.ySize, this.xSize, this.ySize);
		</#if>

		<#list data.components as component>
			<#if component.getClass().getSimpleName() == "Image">
				<#if hasProcedure(component.displayCondition)>if (<@procedureOBJToConditionCode component.displayCondition/>) {</#if>
					Minecraft.getInstance().getTextureManager().bindTexture(new ResourceLocation("${modid}:textures/screens/${component.image}"));
					this.blit(this.guiLeft + ${(component.x - mx/2)?int}, this.guiTop + ${(component.y - my/2)?int}, 0, 0,
						${component.getWidth(w.getWorkspace())}, ${component.getHeight(w.getWorkspace())},
						${component.getWidth(w.getWorkspace())}, ${component.getHeight(w.getWorkspace())});
				<#if hasProcedure(component.displayCondition)>}</#if>
			</#if>
		</#list>

		GlStateManager.disableBlend();
	}

	@Override public boolean keyPressed(int key, int b, int c) {
		if (key == 256) {
			this.minecraft.player.closeScreen();
			return true;
		}

		<#list data.components as component>
			<#if component.getClass().getSimpleName() == "TextField">
		    if(${component.getName()}.isFocused())
		    	return ${component.getName()}.keyPressed(key, b, c);
			</#if>
		</#list>

		return super.keyPressed(key, b, c);
	}

	@Override public void tick() {
		super.tick();
		<#list data.components as component>
			<#if component.getClass().getSimpleName() == "TextField">
				${component.getName()}.tick();
			</#if>
		</#list>
	}

	@Override protected void drawGuiContainerForegroundLayer(int mouseX, int mouseY) {
		<#list data.components as component>
			<#if component.getClass().getSimpleName() == "Label">
				<#if hasProcedure(component.displayCondition)>
				if (<@procedureOBJToConditionCode component.displayCondition/>)
				</#if>
		    	this.font.drawString(<#if hasProcedure(component.text)><@procedureOBJToStringCode component.text/><#else>"${component.text.getFixedValue()}"</#if>,
					${(component.x - mx / 2)?int}, ${(component.y - my / 2)?int}, ${component.color.getRGB()});
			</#if>
		</#list>
	}

	@Override public void removed() {
		super.removed();
		Minecraft.getInstance().keyboardListener.enableRepeatEvents(false);
	}

	@Override public void init(Minecraft minecraft, int width, int height) {
		super.init(minecraft, width, height);
		this.minecraft.keyboardListener.enableRepeatEvents(true);

		<#assign btid = 0>
		<#list data.components as component>
			<#if component.getClass().getSimpleName() == "TextField">
				${component.getName()} = new TextFieldWidget(this.font, this.guiLeft + ${(component.x - mx/2)?int}, this.guiTop + ${(component.y - my/2)?int},
				${component.width}, ${component.height}, "${component.placeholder}")
				<#if component.placeholder?has_content>
				{
					{
						setSuggestion("${component.placeholder}");
					}

					@Override public void writeText(String text) {
						super.writeText(text);

						if(getText().isEmpty())
							setSuggestion("${component.placeholder}");
						else
							setSuggestion(null);
					}

					@Override public void setCursorPosition(int pos) {
						super.setCursorPosition(pos);

						if(getText().isEmpty())
							setSuggestion("${component.placeholder}");
						else
							setSuggestion(null);
					}
				}
				</#if>;
                guistate.put("text:${component.getName()}", ${component.getName()});
				${component.getName()}.setMaxStringLength(32767);
				this.children.add(this.${component.getName()});
			<#elseif component.getClass().getSimpleName() == "Button">
				this.addButton(new Button(this.guiLeft + ${(component.x - mx/2)?int}, this.guiTop + ${(component.y - my/2)?int},
					${component.width}, ${component.height}, "${component.text}", e -> {
							<#if hasProcedure(component.onClick)>
							if (<@procedureOBJToConditionCode component.displayCondition/>) {
								${JavaModName}.PACKET_HANDLER.sendToServer(new ${name}ButtonMessage(${btid}, x, y, z));
								${name}ButtonMessage.handleButtonAction(entity, ${btid}, x, y, z);
							}
							</#if>
					}
				)
                <#if hasProcedure(component.displayCondition)>
                {
					@Override public void render(int gx, int gy, float ticks) {
						if (<@procedureOBJToConditionCode component.displayCondition/>)
							super.render(gx, gy, ticks);
					}
				}
				</#if>);
				<#assign btid +=1>
			<#elseif component.getClass().getSimpleName() == "Checkbox">
            	${component.getName()} = new CheckboxButton(this.guiLeft + ${(component.x - mx/2)?int}, this.guiTop + ${(component.y - my/2)?int},
						20, 20, "${component.text}", <#if hasProcedure(component.isCheckedProcedure)>
            	    <@procedureOBJToConditionCode component.isCheckedProcedure/><#else>false</#if>);
                guistate.put("checkbox:${component.getName()}", ${component.getName()});
                this.addButton(${component.getName()});
			</#if>
		</#list>
	}
}
<#-- @formatter:on -->
