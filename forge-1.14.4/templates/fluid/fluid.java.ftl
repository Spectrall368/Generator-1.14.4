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
package ${package}.fluid;

import net.minecraftforge.common.property.Properties;

public abstract class ${name}Fluid extends ForgeFlowingFluid {

	public static final ForgeFlowingFluid.Properties PROPERTIES = new ForgeFlowingFluid.Properties(
			${JavaModName}Fluids.${data.getModElement().getRegistryNameUpper()},
			${JavaModName}Fluids.FLOWING_${data.getModElement().getRegistryNameUpper()},
			<#if data.extendsFluidAttributes()>${name}</#if>FluidAttributes
			.builder(new ResourceLocation("${data.textureStill.format("%s:block/%s")}"), new ResourceLocation("${data.textureFlowing.format("%s:block/%s")}"))
			<#if data.luminosity != 0>.luminosity(${data.luminosity})</#if>
			<#if data.density != 1000>.density(${data.density})</#if>
			<#if data.viscosity != 1000>.viscosity(${data.viscosity})</#if>
			<#if data.temperature != 300>.temperature(${data.temperature})</#if>
			<#if data.density lt 0>.gaseous()</#if>
			<#if data.rarity != "COMMON">.rarity(Rarity.${data.rarity})</#if>
			<#if data.emptySound?has_content && data.emptySound.getMappedValue()?has_content>
			.sound(ForgeRegistries.SOUND_EVENTS.getValue(new ResourceLocation("${data.emptySound}")))
			</#if>
			<#if data.isFluidTinted()>
			.color(<#if data.tintType == "Grass">
				-6506636
				<#elseif data.tintType == "Foliage" || data.tintType == "Default foliage">
				-12012264
				<#elseif data.tintType == "Birch foliage">
				-8345771
				<#elseif data.tintType == "Spruce foliage">
				-10380959
				<#elseif data.tintType == "Water">
				-13083194
				<#else>
				-16448205
				</#if>)
			</#if>)
		.explosionResistance(${data.resistance}f)
		<#if data.canMultiply>.canMultiply()</#if>
		<#if data.flowRate != 5>.tickRate(${data.flowRate})</#if>
		<#if data.levelDecrease != 1>.levelDecreasePerBlock(${data.levelDecrease})</#if>
		<#if data.slopeFindDistance != 4>.slopeFindDistance(${data.slopeFindDistance})</#if>
		<#if data.generateBucket>.bucket(${JavaModName}Items.${data.getModElement().getRegistryNameUpper()}_BUCKET)</#if>
		.block(() -> (FlowingFluidBlock) ${JavaModName}Blocks.${data.getModElement().getRegistryNameUpper()}.get());

	private ${name}Fluid(Properties properties) {
		super(properties);
	}

	<#if data.spawnParticles>
	@OnlyIn(Dist.CLIENT) @Override public IParticleData getDripParticleData() {
		return ${data.dripParticle};
	}
	</#if>

	<#if data.flowStrength != 1>
	@Override public Vec3d func_215663_a(IBlockReader world, BlockPos pos, IFluidState fluidstate) {
		return super.func_215663_a(world, pos, fluidstate).scale(${data.flowStrength});
	}
	</#if>

	<#if hasProcedure(data.flowCondition)>
	@Override protected boolean canFlow(IBlockReader worldIn, BlockPos fromPos, BlockState blockstate, Direction direction, BlockPos toPos, BlockState intostate, IFluidState toFluidState, Fluid fluidIn) {
		boolean condition = true;
		if (worldIn instanceof IWorld world) {
			int x = fromPos.getX();
			int y = fromPos.getY();
			int z = fromPos.getZ();
			condition = <@procedureOBJToConditionCode data.flowCondition/>;
		}
		return super.canFlow(worldIn, fromPos, blockstate, direction, toPos, intostate, toFluidState, fluidIn) && condition;
	}
	</#if>

	<#if hasProcedure(data.beforeReplacingBlock)>
	@Override protected void beforeReplacingBlock(IWorld world, BlockPos pos, BlockState blockstate) {
		<@procedureCode data.beforeReplacingBlock, {
			"x": "pos.getX()",
			"y": "pos.getY()",
			"z": "pos.getZ()",
			"world": "world",
			"blockstate": "blockstate"
		}/>
	}
	</#if>

	public static class Source extends ${name}Fluid {
		public Source(Properties properties) {
			super(properties);
		}

		public int getLevel(IFluidState state) {
			return 8;
		}

		public boolean isSource(IFluidState state) {
			return true;
		}
	}

	public static class Flowing extends ${name}Fluid {
		public Flowing(Properties properties) {
			super(properties);
		}

		protected void fillStateContainer(StateContainer.Builder<Fluid, IFluidState> builder) {
			super.fillStateContainer(builder);
			builder.add(LEVEL_1_8);
		}

		public int getLevel(IFluidState state) {
			return state.get(LEVEL_1_8);
		}

		public boolean isSource(IFluidState state) {
			return false;
		}
	}
}
<#-- @formatter:on -->
