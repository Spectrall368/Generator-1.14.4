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
package ${package}.world.features;

<#assign configuration = generator.map(featuretype, "features", 1)>
<#assign modifiedCode = placementcode?replace(".withPlacement(", "")?replace(".configure(", ',')?replace("NoPlacementConfig.INSTANCE", 'IPlacementConfig.NO_PLACEMENT_CONFIG')>

<#compress>
@Mod.EventBusSubscriber public class ${name}Feature extends ${generator.map(featuretype, "features")} {
	private static Feature<${configuration}> feature = null;
	
	public ${name}Feature() {
		super(${configuration}::deserialize);

		MinecraftForge.EVENT_BUS.register(this);
		FMLJavaModLoadingContext.get().getModEventBus().register(new FeatureRegisterHandler());
	}

	@Mod.EventBusSubscriber(bus = Mod.EventBusSubscriber.Bus.MOD) private static class FeatureRegisterHandler {
		@SubscribeEvent public static void registerFeature(RegistryEvent.Register<Feature<?>> event) {
		feature = new ${name}Feature() {
	<#if data.hasGenerationConditions() || featuretype == "feature_simple_block">
			@Override public boolean place(IWorld world, ChunkGenerator generator, Random rand, BlockPos pos, ${configuration} config) {
		<#if data.restrictionDimensions?has_content>
					DimensionType dimensionType = world.getDimension().getType();
					boolean dimensionCriteria = false;
	
			<#list data.restrictionDimensions as dimension>
				<#if dimension=="Surface">
							if(dimensionType == DimensionType.OVERWORLD)
								dimensionCriteria = true;
				<#elseif dimension=="Nether">
							if(dimensionType == DimensionType.THE_NETHER)
								dimensionCriteria = true;
				<#elseif dimension=="End">
							if(dimensionType == DimensionType.THE_END)
								dimensionCriteria = true;
				<#else>
							if(dimensionType == ${(worldType.toString().replace("CUSTOM:", ""))}Dimension.type)
								dimensionCriteria = true;
				</#if>
			</#list>

					if(!dimensionCriteria)
						return false;
		</#if>
	
		<#if hasProcedure(data.generateCondition)>
					int x = pos.getX();
					int y = pos.getY();
					int z = pos.getZ();
					if (!<@procedureOBJToConditionCode data.generateCondition/>)
						return false;
		</#if>

		<#if featuretype == "feature_simple_block">
					BlockState state = config.state;
					if (state.isValidPosition(world, pos)) {
						if (state.getBlock() instanceof DoublePlantBlock) {
							if (!world.isAirBlock(pos.up()))
								return false;
							((DoublePlantBlock) state.getBlock()).placeAt(world, pos, 2);
						} else
							world.setBlockState(pos, config.state, 2);
						return true;
					}
					return false;
		<#else>
					return super.place(world, generator, rand, pos, config);
		</#if>
		}
	</#if>
	};
			event.getRegistry().register(feature.setRegistryName("${registryname}"));
		}

		@SubscribeEvent public static void init(FMLCommonSetupEvent event) {
			for (Biome biome : ForgeRegistries.BIOMES.getValues()) {
			<#if data.restrictionBiomes?has_content>
				boolean biomeCriteria = false;
				<#list data.restrictionBiomes as restrictionBiome>
					<#if restrictionBiome.canProperlyMap()>
						if (ForgeRegistries.BIOMES.getKey(biome).equals(new ResourceLocation("${restrictionBiome}")))
							biomeCriteria = true;
					</#if>
				</#list>
				if (!biomeCriteria)
					continue;
			</#if>
			biome.addFeature(GenerationStage.Decoration.${generator.map(data.generationStep, "generationsteps")}, Biome.createDecoratedFeature(feature, ${configurationcode}, ${modifiedCode};
			}
		}
	};
}</#compress>
