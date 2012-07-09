# enchant.js
enchant()

# CoffeeScript のクラスと継承
class CSClassGame extends Game
	constructor : ->
		super 320, 240
		@fps = 24
		@preload 'chara1.gif'
		@onload = ->
			bear = new Sprite 32, 32
			bear.x = 8
			bear.y = 8
			bear.image = @assets['chara1.gif']
			game = @
			bear.addEventListener Event.ENTER_FRAME, ->
				if game.input.right
					bear.x += 2
				if game.input.left
					bear.x -= 2
				if game.input.up
					bear.y -= 2
				if game.input.down
					bear.y += 2
				return
			@rootScene.addChild bear
			return
		@start()
		return

# enchant.js が用意している方法
EJClassGame = Class.create Game,
	initialize : ->
		Game.call @, 320, 240
		@fps = 24
		@preload 'chara1.gif'
		@onload = ->
			bear = new Sprite 32, 32
			bear.x = 8
			bear.y = 8
			bear.image = @assets['chara1.gif']
			game = @
			bear.addEventListener Event.ENTER_FRAME, ->
				if game.input.right
					bear.x += 2
				if game.input.left
					bear.x -= 2
				if game.input.up
					bear.y -= 2
				if game.input.down
					bear.y += 2
				return
			@rootScene.addChild bear
			return
		@start()
		return

window.onload = -> new CSClassGame
#window.onload = -> new EJClassGame

