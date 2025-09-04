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
package ${package}.client.renderer.block;

@Mod.EventBusSubscriber(bus = Mod.EventBusSubscriber.Bus.MOD, value = Dist.CLIENT) public class ${name}Renderer extends TileEntityRenderer<${name}BlockEntity> {

	private final CustomHierarchicalModel model;
	private final ResourceLocation texture;

	${name}Renderer() {
		this.model = new CustomHierarchicalModel();
		this.texture = new ResourceLocation("${data.texture.format("%s:textures/block/%s")}.png");
	}

	@Override public void render(${name}BlockEntity blockEntity, double x, double y, double z, float partialTicks, int destroyStage) {
		<#compress>
		GlStateManager.pushMatrix();
		GlStateManager.translated(x + 0.5d, y + 0.5d, z + 0.5d);
		GlStateManager.scalef(-1f, -1f, 1f);
		<#if data.rotationMode != 0>
			BlockState state = blockEntity.getBlockState();
        	<#if data.rotationMode != 5>
				Direction facing = state.get(${name}Block.FACING);
        	    switch (facing) {
					case NORTH: break;
					case EAST:
					    GlStateManager.rotatef(90.0F, 0.0F, 1.0F, 0.0F);
					    break;
					case WEST:
					    GlStateManager.rotatef(-90.0F, 0.0F, 1.0F, 0.0F);
					    break;
					case SOUTH:
					    GlStateManager.rotatef(180.0F, 0.0F, 1.0F, 0.0F);
					    break;
        	    	<#if data.rotationMode == 2 || data.rotationMode == 4>
        	    		case UP:
        	    		    GlStateManager.rotatef(90.0F, -1.0F, 0.0F, 0.0F);
        	    		    break;
        	    		case DOWN:
        	    		    GlStateManager.rotatef(-90.0F, -1.0F, 0.0F, 0.0F);
        	    		    break;
					</#if>
				}
				<#if data.enablePitch>
				if (facing != Direction.UP && facing != Direction.DOWN) {
					switch (state.get(${name}Block.FACE)) {
						case FLOOR: break;
						case WALL:
						    GlStateManager.rotatef(90.0F, 1.0F, 0.0F, 0.0F);
						    break;
						case CEILING:
						    GlStateManager.rotatef(180.0F, 1.0F, 0.0F, 0.0F);
						    break;
					};
				}
				</#if>
			<#else>
        	    switch (state.get(${name}Block.AXIS)) {
					case X:
					    GlStateManager.rotatef(90.0F, 0.0F, 0.0F, -1.0F);
					    break;
					case Y: break;
					case Z:
					    GlStateManager.rotatef(90.0F, 1.0F, 0.0F, 0.0F);
					    break;
				}
			</#if>
		</#if>
		GlStateManager.translatef(0f, -1f, 0f);
		if (destroyStage >= 0) {
		    this.bindTexture(DESTROY_STAGES[destroyStage]);
		    GlStateManager.matrixMode(5890);
		    GlStateManager.pushMatrix();
		    GlStateManager.scalef(4.0F, 2.0F, 1.0F);
		    GlStateManager.translatef(0.0625F, 0.0625F, 0.0625F);
		    GlStateManager.matrixMode(5888);
		} else {
		    this.bindTexture(texture);
		}
		GlStateManager.enableRescaleNormal();
		GlStateManager.pushMatrix();
		model.setupBlockEntityAnim(blockEntity, blockEntity.getWorld().getGameTime() + partialTicks);
		model.render(null, 0, 0, 0, 0, 0, 0.0625F);
		GlStateManager.popMatrix();
		GlStateManager.color4f(1.0F, 1.0F, 1.0F, 1.0F);
		GlStateManager.popMatrix();

		if (destroyStage >= 0) {
		    GlStateManager.matrixMode(5890);
		    GlStateManager.popMatrix();
		    GlStateManager.matrixMode(5888);
		}
		</#compress>
	}

	@SubscribeEvent public static void registerBlockEntityRenderers(FMLClientSetupEvent event) {
		renders();
	}

	@SubscribeEvent @OnlyIn(Dist.CLIENT) public static void registerBlockEntityModels(ModelRegistryEvent event) {
		renders();
	}

	private static void renders() {
		ClientRegistry.bindTileEntitySpecialRenderer(${name}BlockEntity.class, new ${name}Renderer());
	}

	private static final class CustomHierarchicalModel extends ${data.customModelName.split(":")[0]} {
		public CustomHierarchicalModel() {
			super();
		}

		public void setupBlockEntityAnim(${name}BlockEntity blockEntity, float ageInTicks) {
			super.setRotationAngles(null, 0, 0, ageInTicks, 0, 0, 0.0625F);
		}
	}
}
<#-- @formatter:on -->