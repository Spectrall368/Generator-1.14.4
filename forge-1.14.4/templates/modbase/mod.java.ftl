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
/*
 *    MCreator note:
 *
 *    If you lock base mod element files, you can edit this file and it won't get overwritten.
 *    If you change your modid or package, you need to apply these changes to this file MANUALLY.
 *
 *    Settings in @Mod annotation WON'T be changed in case of the base mod element
 *    files lock too, so you need to set them manually here in such case.
 *
 *    If you do not lock base mod element files in Workspace settings, this file
 *    will be REGENERATED on each build.
 *
 */

package ${package};

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

@Mod("${modid}") public class ${JavaModName} {

	public static final Logger LOGGER = LogManager.getLogger(${JavaModName}.class);

	public static final String MODID = "${modid}";

	private static final String PROTOCOL_VERSION = "1";
	public static final SimpleChannel PACKET_HANDLER = NetworkRegistry.newSimpleChannel(new ResourceLocation(MODID, MODID),
		() -> PROTOCOL_VERSION, PROTOCOL_VERSION::equals, PROTOCOL_VERSION::equals);

	public ${JavaModName}Elements elements;

	public ${JavaModName}() {
		elements = new ${JavaModName}Elements();

		FMLJavaModLoadingContext.get().getModEventBus().addListener(this::init);
		FMLJavaModLoadingContext.get().getModEventBus().addListener(this::clientSetup);

		FMLJavaModLoadingContext.get().getModEventBus().register(this);

		MinecraftForge.EVENT_BUS.register(this);
	}

	private void init(FMLCommonSetupEvent event) {
		elements.getElements().forEach(element -> element.init(event));
	}

	private void clientSetup(FMLClientSetupEvent event) {
        OBJLoader.INSTANCE.addDomain("${modid}");
	
        elements.getElements().forEach(element -> element.clientLoad(event));
    }

    @SubscribeEvent public void serverLoad(FMLServerStartingEvent event) {
		elements.getElements().forEach(element -> element.serverLoad(event));
	}

	@SubscribeEvent public void registerBlocks(RegistryEvent.Register<Block> event) {
		event.getRegistry().registerAll(elements.getBlocks().stream().map(Supplier::get).toArray(Block[]::new));
	}

	@SubscribeEvent public void registerItems(RegistryEvent.Register<Item> event) {
		event.getRegistry().registerAll(elements.getItems().stream().map(Supplier::get).toArray(Item[]::new));
	}

	@SubscribeEvent public void registerBiomes(RegistryEvent.Register<Biome> event) {
		event.getRegistry().registerAll(elements.getBiomes().stream().map(Supplier::get).toArray(Biome[]::new));
	}

	@SubscribeEvent public void registerEntities(RegistryEvent.Register<EntityType<?>> event) {
		event.getRegistry().registerAll(elements.getEntities().stream().map(Supplier::get).toArray(EntityType[]::new));
	}

	@SubscribeEvent public void registerEnchantments(RegistryEvent.Register<Enchantment> event) {
		event.getRegistry().registerAll(elements.getEnchantments().stream().map(Supplier::get).toArray(Enchantment[]::new));
	}

	@SubscribeEvent public void registerSounds(RegistryEvent.Register<net.minecraft.util.SoundEvent> event) {
		elements.registerSounds(event);
	}

}
<#-- @formatter:on -->
