{
	final Vec3d _center = new Vec3d(${input$x}, ${input$y}, ${input$z});
	List<Entity> _entfound = world.func_225316_b(Entity.class, new AxisAlignedBB(_center, _center).grow(${input$range} / 2d), e -> true)
		.stream().sorted(Comparator.comparingDouble(_entcnd -> _entcnd.distanceToSqr(_center))).toList();
	for (Entity entityiterator : _entfound) {
		${statement$foreach}
	}
}
