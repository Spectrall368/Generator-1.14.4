<#include "mcelements.ftl">
(new Object() {
		public static boolean getRandomBlock(ResourceLocation name) {
		  return new Random().nextBoolean();
}}.getRandomBlock(${toResourceLocation(input$tag)}))
