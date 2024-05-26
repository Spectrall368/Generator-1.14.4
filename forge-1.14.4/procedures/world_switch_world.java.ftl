if (world instanceof ServerWorld) {
    IWorld _worldorig = world;

    <#if field$dimension=="Surface">
        world = ((ServerWorld) world).getServer().getWorld(DimensionType.OVERWORLD);
    <#elseif field$dimension=="Nether">
        world = ((ServerWorld) world).getServer().getWorld(DimensionType.THE_NETHER);
    <#elseif field$dimension=="End">
        world = ((ServerWorld) world).getServer().getWorld(DimensionType.THE_END);
    <#else>
        world = ((ServerWorld) world).getServer().getWorld(DimensionType.byName(new ResourceLocation("${generator.getResourceLocationForModElement(field$dimension.replace("CUSTOM:", ""))}")));
    </#if>

    if (world != null) {
        ${statement$worldstatements}
    }

    world = _worldorig;
}
