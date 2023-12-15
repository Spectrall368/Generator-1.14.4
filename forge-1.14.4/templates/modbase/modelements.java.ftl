<#-- @formatter:off -->
/*
 *    MCreator note:
 *
 *    This file is autogenerated to connect all MCreator mod elements together.
 *
 */
package ${package};

import ${package}.${JavaModName};

import net.minecraftforge.fml.ModList;
import java.util.Map;

public class ${JavaModName}Elements {

	public final List<ModElement> elements = new ArrayList<>();

	<#if w.hasElementsOfBaseType("block")>
	public final List<Supplier<Block>> blocks = new ArrayList<>();
	</#if>

	public ${JavaModName}Elements () {

		try {
			ModFileScanData modFileInfo = ModList.get().getModFileById("${modid}").getFile().getScanResult();
			Set<ModFileScanData.AnnotationData> annotations = modFileInfo.getAnnotations();
			for (ModFileScanData.AnnotationData annotationData : annotations) {
				if (annotationData.getAnnotationType().	getClassName().equals(ModElement.Tag.class.getName())) {
					Class<?> clazz = Class.forName(annotationData.getClassType().getClassName());
					if(clazz.getSuperclass() == ${JavaModName}Elements.ModElement.class)
						elements.add((${JavaModName}Elements.ModElement) clazz.getConstructor(this.getClass()).newInstance(this));
					}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		Collections.sort(elements);
		elements.forEach(${JavaModName}Elements.ModElement::initElements);
	}

	public List<ModElement> getElements() {
		return elements;
	}

	<#if w.hasElementsOfBaseType("dimension")>
	public List<Supplier<Block>> getBlocks() {
		return blocks;
	}
	</#if>

	public static class ModElement implements Comparable<ModElement> {

		@Retention(RetentionPolicy.RUNTIME)
		public @interface Tag { }

		protected final ${JavaModName}Elements elements;
		protected final int sortid;

		public ModElement(${JavaModName}Elements elements, int sortid) {
			this.elements = elements;
			this.sortid = sortid;
		}

		public void initElements() {
		}

		public void init(FMLCommonSetupEvent event) {
		}

		public void serverLoad(FMLServerStartingEvent event) {
		}

		@OnlyIn(Dist.CLIENT) public void clientLoad(FMLClientSetupEvent event) {
        	}

		@Override public int compareTo(ModElement other) {
        		return this.sortid - other.sortid;
    		}
	}
}
<#-- @formatter:on -->
