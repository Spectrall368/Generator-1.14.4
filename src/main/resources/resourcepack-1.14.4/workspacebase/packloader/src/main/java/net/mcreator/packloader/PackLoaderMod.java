package net.mcreator.packloader;

import net.minecraft.client.Minecraft;
import net.minecraft.client.resources.ClientResourcePackInfo;
import net.minecraftforge.api.distmarker.Dist;
import net.minecraftforge.eventbus.api.SubscribeEvent;
import net.minecraftforge.fml.common.Mod;
import net.minecraftforge.fml.event.lifecycle.FMLClientSetupEvent;
import net.minecraftforge.fml.loading.FMLPaths;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collection;
import java.util.LinkedList;
import java.util.List;

@Mod(PackLoaderMod.MODID)
public class PackLoaderMod {

    public static final String MODID = "packloader";

    @Mod.EventBusSubscriber(modid = MODID, bus = Mod.EventBusSubscriber.Bus.MOD, value = Dist.CLIENT)
    public static class ClientModEvents {
        @SubscribeEvent
        public static void onClientSetup(FMLClientSetupEvent event) {
            List<String> resourcePacks = new ArrayList<>();
            Path resourcePacksPath = FMLPaths.getOrCreateGameRelativePath(Paths.get("resourcepacks"), "resourcepacks");
            if (resourcePacksPath.toFile().exists()) {
                File[] files = resourcePacksPath.toFile().listFiles();
                if (files != null) {
                    for (File file : files) {
                        resourcePacks.add(file.getName());
                    }
                }
            }

            boolean anyChanged = false;
            Collection<ClientResourcePackInfo> selectedPacks = new LinkedList<>(Minecraft.getInstance().getResourcePackRepository().getSelected());
            Collection<ClientResourcePackInfo> allPacks = Minecraft.getInstance().getResourcePackRepository().getAvailable();
            for (ClientResourcePackInfo pack : allPacks) {
                for (String resourcePack : resourcePacks) {
                    if (pack.getId().contains(resourcePack)) {
                        anyChanged = true;
                        selectedPacks.add(pack);
                    }
                }
            }

            if (anyChanged) {
                Minecraft.getInstance().getResourcePackRepository().setSelected(selectedPacks);
                Minecraft.getInstance().options.loadResourcePacks(Minecraft.getInstance().getResourcePackRepository());
            }
        }
    }
}