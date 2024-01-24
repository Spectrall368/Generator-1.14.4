if (!world.getWorld().isRemote && world.getServer() != null)
		world.getWorld().getServer().getPlayerList().sendMessage(new StringTextComponent(${input$text}));
