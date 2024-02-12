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
<#include "../triggers.java.ftl">
package ${package}.block;

public class ${name}Block extends FlowingFluidBlock {
	public ${name}Block() {
		super(() -> (FlowingFluid) ${JavaModName}Fluids.${data.getModElement().getRegistryNameUpper()}.get(),
			<#if generator.map(data.colorOnMap, "mapcolors") != "DEFAULT">
			Block.Properties.create(Material.${data.type}, MaterialColor.${generator.map(data.colorOnMap, "mapcolors")})
			<#else>
			Block.Properties.create(Material.${data.type})
			</#if>
			.hardnessAndResistance(${data.resistance}f)
			<#if data.luminance != 0>.lightValue(${data.luminance})</#if>
		);
	}

	@OnlyIn(Dist.CLIENT) @Override public BlockRenderLayer getRenderLayer() {
		return BlockRenderLayer.TRANSLUCENT;
	}

	<#if data.flammability != 0>
	@Override public int getFlammability(BlockState state, IBlockReader world, BlockPos pos, Direction face) {
		return ${data.flammability};
	}
	</#if>

	<#if data.fireSpreadSpeed != 0>
	@Override public int getFireSpreadSpeed(BlockState state, IBlockReader world, BlockPos pos, Direction face) {
		return ${data.fireSpreadSpeed};
	}
	</#if>

	<#if data.emissiveRendering>
	@OnlyIn(Dist.CLIENT) @Override public int getPackedLightmapCoords(BlockState state, IEnviromentBlockReader worldIn, BlockPos pos) {
		return 15728880;
	}
	</#if>

	<#if data.lightOpacity == 0>
	@Override public boolean propagatesSkylightDown(BlockState state, IBlockReader reader, BlockPos pos) {
		return true;
	}
	<#elseif data.lightOpacity != 1>
	@Override public int getOpacity(BlockState state, IBlockReader worldIn, BlockPos pos) {
		return ${data.lightOpacity};
	}
	</#if>

	<@onBlockAdded data.onBlockAdded, hasProcedure(data.onTickUpdate) && data.tickRate gt 0, data.tickRate/>

	<@onRedstoneOrNeighborChanged "", "", data.onNeighbourChanges/>

	<@onBlockTick data.onTickUpdate, data.tickRate gt 0, data.tickRate/>

	<@onEntityCollides data.onEntityCollides/>

	<@onAnimateTick data.onRandomUpdateEvent/>

	<@onDestroyedByExplosion data.onDestroyedByExplosion/>
}
