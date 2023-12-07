if(!world.getWorld().isRemote) {
	MinecraftServer _mcserv = ServerLifecycleHooks.getCurrentServer();
	if(_mcserv != null)
		_mcserv.getPlayerList().sendMessage(new StringTextComponent(${input$text}));
}
