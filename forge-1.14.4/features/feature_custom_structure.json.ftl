new StructureFeatureConfiguration(new ResourceLocation("${modid}:${field$structure}"),
  <#if field$random_rotation == "TRUE">true<#else>false</#if>,
  <#if field$random_mirror == "TRUE">true<#else>false</#if>,
  ${input$ignored_blocks},
  new Vec3i(
    ${field$x},
    ${field$y},
    ${field$z}
  ))
