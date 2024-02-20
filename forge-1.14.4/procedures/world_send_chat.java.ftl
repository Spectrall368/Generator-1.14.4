if (!world.getWorld().isRemote && world.getWorld().getServer() != null)
		world.getWorld().getServer().getPlayerList().sendMessage(new StringTextComponent(${input$text}));
