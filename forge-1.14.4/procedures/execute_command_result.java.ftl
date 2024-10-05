<#-- @formatter:off -->
(new Object(){
	public String getResult(IWorld world, Vec3d pos, String _command) {
		StringBuilder _result = new StringBuilder();
		if (world.getWorld() instanceof ServerWorld) {
			ICommandSource _dataConsumer = new ICommandSource() {
				@Override public void sendMessage(ITextComponent message) {
					_result.append(message.getString());
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
			((ServerWorld) world.getWorld()).getServer().getCommandManager().handleCommand(new CommandSource(_dataConsumer, pos, Vec2f.ZERO, (ServerWorld) world.getWorld(), 4, "", ITextComponent.appendText(""), ((ServerWorld) world.getWorld()).getServer(), null), _command);
		}
		return _result.toString();
	}
}.getResult(world, new Vec3d(${input$x}, ${input$y}, ${input$z}), ${input$command}))
<#-- @formatter:on -->
