<@addTemplate file="utils/entity/entity_from_uuid.java.ftl"/>
(world.getWorld() instanceof ServerWorld ? getEntityFromUUID((ServerWorld) world.getWorld(), ${input$uuid}) : null)