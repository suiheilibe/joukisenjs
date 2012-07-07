enchant();

var main = function () {
	var game = new Game(320, 320);
	game.fps = 24;
	game.preload('chara1.gif');
	// The images used in the game should be preloaded

	game.onload = function() {
		var bear = new Sprite(32, 32);
		bear.x = 8;
		bear.y = 8;
		bear.image = game.assets['chara1.gif'];

		bear.addEventListener('enterframe', function(e) {
			// check input (from key or pad) on every frame
			if (game.input.right) {
				bear.x += 2;
			}
			if (game.input.left) {
				bear.x -= 2;
			}

			if (game.input.up) {
				bear.y -= 2;
			}
			if (game.input.down) {
				bear.y += 2;
			}
		});

		// add bear to rootScene (default scene)
		game.rootScene.addChild(bear);

		// display d-pad
		var pad = new Pad();
		pad.x = 0;
		pad.y = 224;
		game.rootScene.addChild(pad);
		game.rootScene.backgroundColor = '#ffffff';
	};
	game.start();
}

$(document).ready(main);
