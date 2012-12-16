enchant()

main = ->
	game = new Game 320, 320
	game.fps = 24
	game.preload 'chara1.gif'

	game.onload = ->
		bear = new Sprite 32, 32
		bear.x = 8
		bear.y = 8
		bear.image = game.assets['chara1.gif']
		bear.addEventListener 'enterframe'
		, (e) ->
			if game.input.right
				bear.x += 2
			if game.input.left
				bear.x -= 2
			if game.input.up
				bear.y -= 2
			if game.input.down
				bear.y += 2
			return
		game.rootScene.addChild bear
		return
	game.start()
	return

$(document).ready main
