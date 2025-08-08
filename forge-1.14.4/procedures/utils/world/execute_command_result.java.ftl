private static String executeCommandGetResult(IWorld world, Vec3d pos, String command) {
	StringBuilder result = new StringBuilder();
	if (world instanceof ServerWorld) {
		ICommandSource dataConsumer = new ICommandSource() {
			@Override public void sendMessage(ITextComponent message) {
				result.append(message.getString());
			}

			@Override public boolean shouldReceiveFeedback() {
				return true;
			}

			@Override public boolean shouldReceiveErrors() {
				return true;
			}

			@Override public boolean allowLogging() {
				return false;
			}
		};
		world.getWorld().getServer().getCommandManager().handleCommand(new CommandSource(dataConsumer, pos, Vec2f.ZERO, (ServerWorld) world.getWorld(), 4, "", new StringTextComponent(""), world.getWorld().getServer(), null), command);
	}
	return result.toString();
}