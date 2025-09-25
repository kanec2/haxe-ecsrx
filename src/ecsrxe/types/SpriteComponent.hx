package ecsrx.types;

class SpriteComponent {
	public var texture:String;
	public var width:Float;
	public var height:Float;

	public function new(texture:String, width:Float = 32, height:Float = 32) {
		this.texture = texture;
		this.width = width;
		this.height = height;
	}
}