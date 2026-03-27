((${input$entity} instanceof ServerPlayerEntity && !((ServerPlayerEntity) ${input$entity}).world.isRemote()) ?
((_player.getSpawnDimension().equals(_player.world.getDimension().getType()) && _player.getBedLocation(_player.getSpawnDimension()) != null) ?
_player.getBedLocation(_player.getSpawnDimension()).getX() : _player.world.getWorldInfo().getSpawnY()) : 0)