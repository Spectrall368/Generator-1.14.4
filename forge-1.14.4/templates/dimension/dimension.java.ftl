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
@Mod.EventBusSubscriber public class ${name}Dimension {
	private static Biome[] dimensionBiomes${name};

	<#if data.enablePortal>
	public static final ${name}PortalBlock portal${name} = null;
	</#if>

	@Mod.EventBusSubscriber(bus = Mod.EventBusSubscriber.Bus.MOD) public static class Fixers {
		@SubscribeEvent public static void onRegisterDimensionsEvent(RegisterDimensionsEvent event) {
			if (DimensionType.byName(new ResourceLocation("${modid}:${registryname}")) == null) {
				DimensionManager.registerDimension(new ResourceLocation("${modid}:${registryname}"), ${JavaModName}Dimensions.${name?upper_case}.get(), null, ${data.hasSkyLight});
			}
		}
	
		@SubscribeEvent public static void registerDimensionGen(FMLCommonSetupEvent event) {
			dimensionBiomes${name} = new Biome[] {
	    		<#list data.biomesInDimension as biome>
					<#if biome.canProperlyMap()>
					ForgeRegistries.BIOMES.getValue(new ResourceLocation("${biome}")),
					</#if>
				</#list>
			};
		}
	}

	public static class ${name}ModDimension extends ModDimension {
	
			@Override public BiFunction<World, DimensionType, ? extends Dimension> getFactory() {
				return ${name}World::new;
			}
	}

	public static class ${name}World extends Dimension {

		private BiomeProvider${name} biomeProvider${name} = null;

		public ${name}World(World world, DimensionType type) {
			super(world, type);
			this.nether = <#if data.worldGenType == "Nether like gen">true<#else>false</#if>;
		}

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

		@Override @OnlyIn(Dist.CLIENT) public Vec3d getFogColor(float celestialAngle, float partialTicks) {
		<#if data.airColor?has_content>
			return new Vec3d(${data.airColor.getRed()/255},${data.airColor.getGreen()/255},${data.airColor.getBlue()/255});
		<#else>
			float f = MathHelper.clamp(MathHelper.cos(celestialAngle * ((float)Math.PI * 2)) * 2 + 0.5f, 0, 1);
	      		float f1 = 0.7529412f;
	      		float f2 = 0.84705883f;
	      		float f3 = 1;
	      		f1 = f1 * (f * 0.94F + 0.06F);
	      		f2 = f2 * (f * 0.94F + 0.06F);
	      		f3 = f3 * (f * 0.91F + 0.09F);
	      		return new Vec3d(f1, f2, f3);
		</#if>
		}

		@Override public ChunkGenerator<?> createChunkGenerator() {
			if(this.biomeProvider${name} == null)
				this.biomeProvider${name} = new BiomeProvider${name}(this.world);
			return new ChunkProviderModded(this.world, this.biomeProvider${name});
		}

		@Override public boolean isSurfaceWorld() {
			return ${data.imitateOverworldBehaviour};
		}

		@Override public boolean canRespawnHere() {
			return ${data.canRespawnHere};
		}

		@OnlyIn(Dist.CLIENT) @Override public boolean doesXZShowFog(int x, int z) {
			return ${data.hasFog};
		}

		@Override public SleepResult canSleepAt(PlayerEntity player, BlockPos pos){
        	return SleepResult.${data.sleepResult};
		}

		@Nullable public BlockPos findSpawn(ChunkPos chunkPos, boolean checkValid) {
   		   return null;
   		}

   		@Nullable public BlockPos findSpawn(int x, int z, boolean checkValid) {
   		   return null;
   		}

		<#if !data.isDark>
		@Override protected void generateLightBrightnessTable() {
			float f = 0.5f;
			for (int i = 0; i <= 15; ++i) {
				float f1 = 1 - (float) i / 15f;
				this.lightBrightnessTable[i] = (1 - f1) / (f1 * 3 + 1) * (1 - f) + f;
			}
		}
		</#if>

		@Override public boolean doesWaterVaporize() {
      			return ${data.doesWaterVaporize};
   		}

		@Override ${mcc.getMethod("net.minecraft.world.dimension.OverworldDimension", "calculateCelestialAngle", "long", "float")}
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
    	<#elseif data.worldGenType == "End like gen">
	        <#include "cp_end.java.ftl">
    	</#if>

	<#include "biomegen.java.ftl">
}
</#compress>
<#-- @formatter:on -->
