package net.mcreator.packloader;

import net.minecraftforge.fml.javafmlmod.FMLJavaModLoadingContext;
import net.minecraftforge.fml.event.lifecycle.FMLClientSetupEvent;
import net.minecraftforge.fml.common.Mod;

import net.minecraft.resources.ResourcePackInfo;
import net.minecraft.resources.IPackFinder;
import net.minecraft.resources.FolderPack;
import net.minecraft.client.Minecraft;

import java.util.Map;
import java.io.File;

@Mod(PackLoaderMod.MODID)
public class PackLoaderMod {
    public static final String MODID = "packloader";

    public PackLoaderMod() {
        FMLJavaModLoadingContext.get().getModEventBus().addListener(this::addPacks);
    }

    public void addPacks(FMLClientSetupEvent event) {
        Minecraft mc = event.getMinecraftSupplier().get();
        mc.getResourcePackRepository().addSource(new IPackFinder() {
            @Override
            public <T extends ResourcePackInfo> void loadPacks(Map<String, T> consumer, ResourcePackInfo.IFactory<T> factory) {
                if (mc.player != null)
                    consumer.put("packloader", ResourcePackInfo.create("packloader", true, () -> new FolderPack(new File("datapacks")), factory, ResourcePackInfo.Priority.TOP));
            }
        });
    }
}