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
 *    Keep the ${JavaModName}Elements object in this class and all calls to this object
 *    INTACT in order to preserve functionality of mod elements generated by MCreator.
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

		IEventBus bus = FMLJavaModLoadingContext.get().getModEventBus();
		<#if w.hasElementsOfBaseType("item")>${JavaModName}Items.REGISTRY.register(bus);</#if>
		<#if w.hasElementsOfBaseType("entity")>${JavaModName}Entities.REGISTRY.register(bus);</#if>
		<#if w.hasElementsOfType("potioneffect")>${JavaModName}PotionEffects.REGISTRY.register(bus);</#if>
		<#if w.hasElementsOfType("potion")>${JavaModName}Potions.REGISTRY.register(bus);</#if>
		<#if w.hasElementsOfType("painting")>${JavaModName}Paintings.REGISTRY.register(bus);</#if>
		<#if w.hasElementsOfType("particle")>${JavaModName}ParticleTypes.REGISTRY.register(bus);</#if>
		<#if w.hasElementsOfType("enchantment")>${JavaModName}Enchantments.REGISTRY.register(bus);</#if>
		<#if w.hasElementsOfType("tab")>${JavaModName}Tabs.load();</#if>
	}

	private void init(FMLCommonSetupEvent event) {
		elements.getElements().forEach(element -> element.init(event));
	}

	private void clientSetup(FMLClientSetupEvent event) {
        	OBJLoader.INSTANCE.addDomain(MODID);
	
        	elements.getElements().forEach(element -> element.clientLoad(event));
    	}

    	@SubscribeEvent public void serverLoad(FMLServerStartingEvent event) {
		elements.getElements().forEach(element -> element.serverLoad(event));
	}

	<#if w.hasElementsOfBaseType("block")>
	@SubscribeEvent public void registerBlocks(RegistryEvent.Register<Block> event) {
		event.getRegistry().registerAll(elements.getBlocks().stream().map(Supplier::get).toArray(Block[]::new));
	}
	</#if>

	<#if w.hasElementsOfBaseType("item")>
	@SubscribeEvent public void registerItems(RegistryEvent.Register<Item> event) {
		event.getRegistry().registerAll(elements.getItems().stream().map(Supplier::get).toArray(Item[]::new));
	}
	</#if>

	<#if w.hasElementsOfType("biome")>
	@SubscribeEvent public void registerBiomes(RegistryEvent.Register<Biome> event) {
		event.getRegistry().registerAll(elements.getBiomes().stream().map(Supplier::get).toArray(Biome[]::new));
	}
	</#if>
}
<#-- @formatter:on -->
