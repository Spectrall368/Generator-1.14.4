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
<#include "procedures.java.ftl">

package ${package}.block;

@${JavaModName}Elements.ModElement.Tag public class ${name}Block extends ${JavaModName}Elements.ModElement{

	@ObjectHolder("${modid}:${registryname}")
	public static final FlowingFluidBlock block = null;

	@ObjectHolder("${modid}:${registryname}_bucket")
	public static final Item bucket = null;

	public static FlowingFluid flowing = null;
	public static FlowingFluid still = null;

	private ForgeFlowingFluid.Properties fluidproperties = null;

	public ${name}Block (${JavaModName}Elements instance) {
		super(instance, ${data.getModElement().getSortID()});

		FMLJavaModLoadingContext.get().getModEventBus().register(this);
	}

	@SubscribeEvent public void registerFluids(RegistryEvent.Register<Fluid> event) {
		event.getRegistry().register(still);
		event.getRegistry().register(flowing);
	}

	@Override public void initElements() {
		fluidproperties = new ForgeFlowingFluid.Properties(() -> still, () -> flowing, FluidAttributes
				.builder(new ResourceLocation("${modid}:blocks/${data.textureStill}"), new ResourceLocation("${modid}:blocks/${data.textureFlowing}"))
					.luminosity(${data.luminosity})
					.density(${data.density})
					.viscosity(${data.viscosity})
					<#if data.isGas>.gaseous()</#if>)
                    <#if data.generateBucket>.bucket(() -> bucket)</#if>
					.block(() -> block);

		still = (FlowingFluid) new ForgeFlowingFluid.Source(fluidproperties).setRegistryName("${registryname}");
		flowing = (FlowingFluid) new ForgeFlowingFluid.Flowing(fluidproperties).setRegistryName("${registryname}_flowing");

		elements.blocks.add(() -> new FlowingFluidBlock(still, Block.Properties.create(Material.${data.type})){
			<#if hasProcedure(data.onBlockAdded)>
			@Override public void onBlockAdded(BlockState state, World world, BlockPos pos, BlockState oldState, boolean moving) {
				super.onBlockAdded(state, world, pos, oldState, moving);
				int x = pos.getX();
				int y = pos.getY();
				int z = pos.getZ();
				<@procedureOBJToCode data.onBlockAdded/>
			}
            </#if>

			<#if hasProcedure(data.onNeighbourChanges)>
			public void neighborChanged(BlockState state, World world, BlockPos pos, Block neighborBlock, BlockPos fromPos, boolean moving) {
				super.neighborChanged(state, world, pos, neighborBlock, fromPos, moving);
				int x = pos.getX();
				int y = pos.getY();
				int z = pos.getZ();
				<@procedureOBJToCode data.onNeighbourChanges/>
			}
			</#if>

			<#if hasProcedure(data.onTickUpdate)>
			@Override public void tick(BlockState state, World world, BlockPos pos, Random random) {
				super.tick(state, world, pos, random);
				int x = pos.getX();
				int y = pos.getY();
				int z = pos.getZ();
				<@procedureOBJToCode data.onTickUpdate/>
				world.getPendingBlockTicks().scheduleTick(new BlockPos(x, y, z), this, this.tickRate(world));
			}
			</#if>

			<#if hasProcedure(data.onEntityCollides)>
			@Override public void onEntityCollision(BlockState state, World world, BlockPos pos, Entity entity) {
				super.onEntityCollision(state, world, pos, entity);
				int x = pos.getX();
				int y = pos.getY();
				int z = pos.getZ();
    			<@procedureOBJToCode data.onEntityCollides/>
			}
			</#if>
		}.setRegistryName("${registryname}"));

		<#if data.generateBucket>
		elements.items.add(() -> new BucketItem(still, new Item.Properties().containerItem(Items.BUCKET).maxStackSize(1)
				<#if data.creativeTab??>.group(${data.creativeTab})<#else>.group(ItemGroup.MISC)</#if>).setRegistryName("${registryname}_bucket"));
		</#if>
	}

	<#if (data.spawnWorldTypes?size > 0)>
	@Override public void init(FMLCommonSetupEvent event) {
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

			biome.addFeature(GenerationStage.Decoration.LOCAL_MODIFICATIONS, Biome.createDecoratedFeature(new LakesFeature(LakesConfig::deserialize) {
					@Override public boolean place(IWorld world, ChunkGenerator generator, Random rand, BlockPos pos, LakesConfig config) {
					DimensionType dimensionType = world.getDimension().getType();
					boolean dimensionCriteria = false;

    				<#list data.spawnWorldTypes as worldType>
						<#if worldType=="Surface">
							if(dimensionType == DimensionType.OVERWORLD)
								dimensionCriteria = true;
						<#elseif worldType=="Nether">
							if(dimensionType == DimensionType.THE_NETHER)
								dimensionCriteria = true;
						<#elseif worldType=="End">
							if(dimensionType == DimensionType.THE_END)
								dimensionCriteria = true;
						<#else>
							if(dimensionType == ${(worldType.toString().replace("CUSTOM:", ""))}Dimension.type)
								dimensionCriteria = true;
						</#if>
					</#list>

					if(!dimensionCriteria)
						return false;

					<#if hasCondition(data.generateCondition)>
					int x = pos.getX();
					int y = pos.getY();
					int z = pos.getZ();
					if (!<@procedureOBJToConditionCode data.generateCondition/>)
						return false;
					</#if>

					return super.place(world, generator, rand, pos, config);
				}}, new LakesConfig(block.getDefaultState()), Placement.WATER_LAKE, new LakeChanceConfig(${data.frequencyOnChunks})));
		}
	}
	</#if>

}
<#-- @formatter:on -->
