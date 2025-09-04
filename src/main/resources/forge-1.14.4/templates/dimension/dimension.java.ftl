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
<#include "../mcitems.ftl">
<#include "../procedures.java.ftl">
package ${package}.world.dimension;

<#compress>
@Mod.EventBusSubscriber(bus = Mod.EventBusSubscriber.Bus.MOD) public class ${name}Dimension extends Dimension {
	private static Biome[] dimensionBiomes;
	private ${name}BiomeProvider biomeProvider${name} = null;

	public ${name}Dimension(World world, DimensionType type) {
	    super(world, type);
	    this.nether = <#if data.worldGenType == "Nether like gen">true<#else>false</#if>;
	}

	@Mod.EventBusSubscriber(bus = Mod.EventBusSubscriber.Bus.FORGE) public static class ${name}SpecialEffectsHandler {
		@SubscribeEvent public static void onRegisterDimensionsEvent(RegisterDimensionsEvent event) {
			if (DimensionType.byName(new ResourceLocation("${modid}:${registryname}")) == null) {
				DimensionManager.registerDimension(new ResourceLocation("${modid}:${registryname}"), ${JavaModName}Dimensions.${REGISTRYNAME}.get(), null, ${data.hasSkyLight});
			}
		}
	}
	
	@SubscribeEvent public static void registerDimensionGen(FMLCommonSetupEvent event) {
		dimensionBiomes = new Biome[] {
	    	<#list w.filterBrokenReferences(data.biomesInDimension) as biome>
			ForgeRegistries.BIOMES.getValue(new ResourceLocation("${biome}"))<#sep>,
		</#list>};
	}

	public static class ${name}ModDimension extends ModDimension {
		@Override public BiFunction<World, DimensionType, ? extends Dimension> getFactory() {
			return ${name}Dimension::new;
		}
	}

	<#if data.coordinateScale != 1>
	@Override public double getMovementFactor() {
		return ${data.coordinateScale}f;
	}
	</#if>

	<#if !data.imitateOverworldBehaviour>
	@Override public void calculateInitialWeather() {}
	
	@Override public void updateWeather(Runnable defaultWeather) {}
	
    @Override public boolean canDoLightning(Chunk chunk) {
		return false;
	}
	
	@Override public boolean canDoRainSnowIce(Chunk chunk) {
		return false;
	}
	</#if>

	<#if data.ambientLight != 0>
	@Override protected void generateLightBrightnessTable() {
		float f = ${data.ambientLight}f;
		for (int i = 0; i <= 15; ++i) {
			float f1 = 1 - (float) i / 15f;
			this.lightBrightnessTable[i] = (1 - f1) / (f1 * 3 + 1) * (1 - f) + f;
		}
	}
	</#if>

	<#if data.useCustomEffects>
		@Override @OnlyIn(Dist.CLIENT)
		<#if !data.airColor?has_content>
			<#if data.skyType == "NONE">
				${mcc.getMethod("net.minecraft.world.dimension.NetherDimension", "getFogColor", "float", "float")?keep_before_last(";")}
			<#elseif data.skyType == "NORMAL">
				${mcc.getMethod("net.minecraft.world.dimension.OverworldDimension", "getFogColor", "float", "float")?keep_before_last(";")}
			<#else>
				${mcc.getMethod("net.minecraft.world.dimension.EndDimension", "getFogColor", "float", "float")?keep_before_last(";")}
			</#if>
		<#else>
		public Vec3d getFogColor(float celestialAngle, float partialTicks) {
			return new Vec3d(${data.airColor.getRed()/255},${data.airColor.getGreen()/255},${data.airColor.getBlue()/255})
		</#if><#if data.sunHeightAffectsFog>.mul(celestialAngle * 0.94 + 0.06, celestialAngle * 0.94 + 0.06, celestialAngle * 0.91 + 0.09)</#if>;
		}

		@OnlyIn(Dist.CLIENT) @Override public boolean doesXZShowFog(int x, int z) {
			return ${data.hasFog};
		}

		@Override
		<#if !data.hasFixedTime>
			<#if data.skyType == "NONE">
				${mcc.getMethod("net.minecraft.world.dimension.NetherDimension", "calculateCelestialAngle", "long", "float")}
			<#elseif data.skyType == "NORMAL">
				${mcc.getMethod("net.minecraft.world.dimension.OverworldDimension", "calculateCelestialAngle", "long", "float")}
			<#else>
				${mcc.getMethod("net.minecraft.world.dimension.EndDimension", "calculateCelestialAngle", "long", "float")}
			</#if>
		<#else>
		public float calculateCelestialAngle(long worldTime, float partialTicks) {
			return ${data.fixedTimeValue}f;
		}
		</#if>

		<#if !data.hasClouds || data.cloudHeight != 192>
		@Override @OnlyIn(Dist.CLIENT) public float getCloudHeight() {
			return <#if data.hasClouds>${data.cloudHeight}f<#else>Float.NaN</#if>;
		}
		</#if>
	
		<#if data.skyType == "END">
		@Nullable @OnlyIn(Dist.CLIENT) @Override ${mcc.getMethod("net.minecraft.world.dimension.EndDimension", "calcSunriseSunsetColors", "float", "float")}
	
		@Override @OnlyIn(Dist.CLIENT) ${mcc.getMethod("net.minecraft.world.dimension.EndDimension", "isSkyColored")}
		</#if>
	
	<#elseif data.defaultEffects == "overworld">
	   	@Override ${mcc.getMethod("net.minecraft.world.dimension.OverworldDimension", "calculateCelestialAngle", "long", "float")}
	
		@Override @OnlyIn(Dist.CLIENT) ${mcc.getMethod("net.minecraft.world.dimension.OverworldDimension", "getFogColor", "float", "float")}
	
		@Override @OnlyIn(Dist.CLIENT) ${mcc.getMethod("net.minecraft.world.dimension.OverworldDimension", "doesXZShowFog", "int", "int")}
	<#elseif data.defaultEffects == "the_nether">
		@Override @OnlyIn(Dist.CLIENT) ${mcc.getMethod("net.minecraft.world.dimension.NetherDimension", "getFogColor", "float", "float")}
	
	   	@Override ${mcc.getMethod("net.minecraft.world.dimension.NetherDimension", "calculateCelestialAngle", "long", "float")}
	
		@Override @OnlyIn(Dist.CLIENT) ${mcc.getMethod("net.minecraft.world.dimension.NetherDimension", "doesXZShowFog", "int", "int")}
	<#else>
		@Override ${mcc.getMethod("net.minecraft.world.dimension.EndDimension", "calculateCelestialAngle", "long", "float")}
	
		@Nullable @OnlyIn(Dist.CLIENT) @Override ${mcc.getMethod("net.minecraft.world.dimension.EndDimension", "calcSunriseSunsetColors", "float", "float")}
	
		@Override @OnlyIn(Dist.CLIENT) ${mcc.getMethod("net.minecraft.world.dimension.EndDimension", "getFogColor", "float", "float")}
	
		@Override @OnlyIn(Dist.CLIENT) ${mcc.getMethod("net.minecraft.world.dimension.EndDimension", "isSkyColored")}
	
		@Override @OnlyIn(Dist.CLIENT) ${mcc.getMethod("net.minecraft.world.dimension.EndDimension", "getCloudHeight")}
	
		@Override @OnlyIn(Dist.CLIENT) ${mcc.getMethod("net.minecraft.world.dimension.EndDimension", "doesXZShowFog", "int", "int")}
	</#if>

	@Override public ChunkGenerator<?> createChunkGenerator() {
		if(this.biomeProvider${name} == null)
			this.biomeProvider${name} = new ${name}BiomeProvider(this.world);
		return new ChunkProvider${name}(this.world, this.biomeProvider${name});
	}

	@Override public boolean isSurfaceWorld() {
		return ${data.imitateOverworldBehaviour};
	}

	@Override public boolean canRespawnHere() {
		return ${data.canRespawnHere};
	}

	@Override public SleepResult canSleepAt(PlayerEntity player, BlockPos pos){
       	return SleepResult.<#if data.bedWorks>ALLOW<#else>BED_EXPLODES</#if>;
	}

	@Nullable public BlockPos findSpawn(ChunkPos chunkPos, boolean checkValid) {
   	    return null;
   	}

   	@Nullable public BlockPos findSpawn(int x, int z, boolean checkValid) {
   	    return null;
   	}

	@Override public boolean doesWaterVaporize() {
        return ${data.doesWaterVaporize};
   	}

	<#if hasProcedure(data.onPlayerLeavesDimension) || hasProcedure(data.onPlayerEntersDimension)>
	@SubscribeEvent public void onPlayerChangedDimensionEvent(PlayerEvent.PlayerChangedDimensionEvent event) {
		Entity entity = event.getPlayer();
		World world = entity.world;
		double x = entity.posX;
		double y = entity.posY;
		double z = entity.posZ;

		<#if hasProcedure(data.onPlayerLeavesDimension)>
		if (event.getFrom() == DimensionType.byName(new ResourceLocation("${modid}:${registryname}"))) {
			<@procedureOBJToCode data.onPlayerLeavesDimension/>
		}
        	</#if>

		<#if hasProcedure(data.onPlayerEntersDimension)>
		if (event.getTo() == DimensionType.byName(new ResourceLocation("${modid}:${registryname}"))) {
			<@procedureOBJToCode data.onPlayerEntersDimension/>
		}
	        </#if>
	}
	</#if>

	<#if data.worldGenType == "Normal world gen">
	        <#include "cp_normal.java.ftl">
    	<#elseif data.worldGenType == "Nether like gen">
	        <#include "cp_nether.java.ftl">
    	<#else>
	        <#include "cp_end.java.ftl">
    	</#if>

	<#include "biomegen.java.ftl">
}
</#compress>
<#-- @formatter:on -->