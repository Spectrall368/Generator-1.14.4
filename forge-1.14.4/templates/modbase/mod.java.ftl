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

	<#if w.hasElementsOfType("dimension")>public ${JavaModName}Elements elements;</#if>

	public ${JavaModName}() {
		MinecraftForge.EVENT_BUS.register(this);
		<#if w.hasElementsOfType("dimension")>elements = new ${JavaModName}Elements();</#if>

		IEventBus bus = FMLJavaModLoadingContext.get().getModEventBus();
		<#if w.hasElementsOfType("tab")>${JavaModName}Tabs.load();</#if>
		<#if w.hasElementsOfBaseType("block")>${JavaModName}Blocks.REGISTRY.register(bus);</#if>
		<#if w.hasElementsOfBaseType("item")>${JavaModName}Items.REGISTRY.register(bus);</#if>
		<#if w.hasElementsOfBaseType("blockentity")>${JavaModName}BlockEntities.REGISTRY.register(bus);</#if>
		<#if w.hasElementsOfType("fluid")>${JavaModName}Fluids.REGISTRY.register(bus);</#if>
		<#if w.hasElementsOfType("enchantment")>${JavaModName}Enchantments.REGISTRY.register(bus);</#if>
		<#if w.hasElementsOfType("potioneffect")>${JavaModName}PotionEffects.REGISTRY.register(bus);</#if>
		<#if w.hasElementsOfType("potion")>${JavaModName}Potions.REGISTRY.register(bus);</#if>
		<#if w.hasElementsOfType("biome")>${JavaModName}Biomes.REGISTRY.register(bus);</#if>
		<#if w.hasElementsOfType("painting")>${JavaModName}Paintings.REGISTRY.register(bus);</#if>
		<#if w.hasElementsOfType("particle")>${JavaModName}ParticleTypes.REGISTRY.register(bus);</#if>

		<#if w.hasElementsOfType("dimension")>bus.addListener(this::init);</#if>
		bus.addListener(this::clientSetup);
		bus.register(this);
	}

	private static final String PROTOCOL_VERSION = "1";
	public static final SimpleChannel PACKET_HANDLER = NetworkRegistry.newSimpleChannel(
			new ResourceLocation(MODID, MODID),
			() -> PROTOCOL_VERSION,
			PROTOCOL_VERSION::equals,
			<#if settings.isServerSideOnly()>clientVersion -> true<#else>PROTOCOL_VERSION::equals</#if>
	);

	private static int messageID = 0;

	public static <T> void addNetworkMessage(Class<T> messageType, BiConsumer<T, PacketBuffer> encoder, Function<PacketBuffer, T> decoder, BiConsumer<T, Supplier<NetworkEvent.Context>> messageConsumer) {
		PACKET_HANDLER.registerMessage(messageID, messageType, encoder, decoder, messageConsumer);
		messageID++;
	}

	private static final Collection<AbstractMap.SimpleEntry<Runnable, Integer>> workQueue = new ConcurrentLinkedQueue<>();

	public static void queueServerWork(int tick, Runnable action) {
		if (Thread.currentThread().getThreadGroup() == SidedThreadGroups.SERVER)
			workQueue.add(new AbstractMap.SimpleEntry<>(action, tick));
	}

	@SubscribeEvent public void tick(TickEvent.ServerTickEvent event) {
		if (event.phase == TickEvent.Phase.END) {
			List<AbstractMap.SimpleEntry<Runnable, Integer>> actions = new ArrayList<>();
			workQueue.forEach(work -> {
				work.setValue(work.getValue() - 1);
				if (work.getValue() == 0)
					actions.add(work);
			});
			actions.forEach(e -> e.getKey().run());
			workQueue.removeAll(actions);
		}
	}

	private void clientSetup(FMLClientSetupEvent event) {
        	OBJLoader.INSTANCE.addDomain(MODID);
		<#if w.hasElementsOfType("dimension")>
        	elements.getElements().forEach(element -> element.clientLoad(event));
		</#if>
    	}

	<#if w.hasElementsOfType("dimension")>
	private void init(FMLCommonSetupEvent event) {
		elements.getElements().forEach(element -> element.init(event));
	}

    	@SubscribeEvent public void serverLoad(FMLServerStartingEvent event) {
		elements.getElements().forEach(element -> element.serverLoad(event));
	}

	@SubscribeEvent public void registerBlocks(RegistryEvent.Register<Block> event) {
		event.getRegistry().registerAll(elements.getBlocks().stream().map(Supplier::get).toArray(Block[]::new));
	}
	</#if>
}
<#-- @formatter:on -->
