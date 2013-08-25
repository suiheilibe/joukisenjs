// Generated by CoffeeScript 1.6.2
"use strict";
var Constants, StageVars, TheGame, TheShip, TheStage, Wave, WaveSurface;

enchant();

Constants = {
  WIDTH: 640,
  HEIGHT: 480,
  RDN: [0, 6, 12, 18, 24, 31, 37, 43, 48, 54, 60, 65, 71, 76, 81, 85, 90, 94, 98, 102, 106, 109, 112, 115, 118, 120, 122, 124, 125, 126, 127, 127, 127, 127, 127, 126, 125, 124, 122, 120, 118, 115, 112, 109, 106, 102, 98, 94, 90, 85, 81, 76, 71, 65, 60, 54, 48, 43, 37, 31, 24, 18, 12, 6, 0, -6, -12, -18, -24, -31, -37, -43, -48, -54, -60, -65, -71, -76, -81, -85, -90, -94, -98, -102, -106, -109, -112, -115, -118, -120, -122, -124, -125, -126, -127, -127, -127, -127, -127, -126, -125, -124, -122, -120, -118, -115, -112, -109, -106, -102, -98, -94, -90, -85, -81, -76, -71, -65, -60, -54, -48, -43, -37, -31, -24, -18, -12, -6],
  WDX: 2,
  WOC: 400,
  WCOLOR: '#0000ff',
  BGCOLOR: '#000000'
};

StageVars = WaveSurface = Class.create(Surface, {
  initialize: function(wys, wwidth, wheight) {
    var i, wdx, wxcount, x;

    Surface.call(this, wwidth, wheight);
    this.clear();
    this.context.fillStyle = Constants.WCOLOR;
    wxcount = wys.length;
    i = 0;
    x = 0;
    wdx = Constants.WDX;
    while (wwidth > 0) {
      this.context.fillRect(x, wys[i] - (Constants.HEIGHT - wheight), wdx, Constants.HEIGHT - wys[i]);
      i++;
      if (i >= wxcount) {
        i = 0;
      }
      x += wdx;
      wwidth -= wdx;
    }
  }
});

Wave = Class.create(Group, {
  initialize: function(ww1, ww2, wv1, wv2, wsp1, wsp2) {
    var i, maxwy, minwy, sp1, sp2, wheight, ws, wsp, wwidth, wx, wxcount, wy, wys;

    Group.call(this);
    wxcount = (ww1 === 0 ? 1 : Constants.RDN.length * ww2 / ww1);
    maxwy = 0;
    minwy = Constants.HEIGHT;
    wys = (function() {
      var _i, _results;

      _results = [];
      for (i = _i = 0; 0 <= wxcount ? _i < wxcount : _i > wxcount; i = 0 <= wxcount ? ++_i : --_i) {
        wy = ~~(Constants.WOC - (Constants.RDN[~~(i * ww1 / ww2) % 128] * wv1 / wv2));
        maxwy = Math.max(maxwy, wy);
        minwy = Math.min(minwy, wy);
        _results.push(wy);
      }
      return _results;
    })();
    wwidth = 0;
    wheight = Constants.HEIGHT - minwy;
    while (wwidth < Constants.WIDTH) {
      wwidth += wxcount * Constants.WDX;
    }
    wsp = (wsp1 === 0 ? 0 : wsp2 / wsp1);
    ws = new WaveSurface(wys, wwidth, wheight);
    wx = 0;
    sp1 = new Sprite(wwidth, wheight);
    sp1.image = ws;
    sp1.x = wx;
    sp1.y = minwy;
    sp2 = new Sprite(wwidth, wheight);
    sp2.image = ws;
    sp2.x = wx + wwidth;
    sp2.y = minwy;
    this.addChild(sp1);
    this.addChild(sp2);
    this.addEventListener('enterframe', function() {
      var right, rspace;

      wx -= wsp;
      right = wx + wwidth;
      rspace = wwidth - right;
      if (right <= 0) {
        wx = 0;
        right = wwidth;
      } else if (rspace > 0) {
        sp2.x = right;
      }
      sp1.x = wx;
    });
    this.getWaveTop = function(x) {
      return wys[~~((x - wx) / Constants.WDX) % wxcount];
    };
  }
});

TheShip = Class.create(Sprite, {
  initialize: function(wave) {
    var game;

    Sprite.call(this, 64, 32);
    game = Core.instance;
    this.image = game.assets['res/img/ship.gif'];
    this.x = 240;
    this.y = 120;
    return this.addEventListener('enterframe', function() {
      if (game.input.right) {
        this.x += 1;
      } else if (game.input.left) {
        this.x -= 1;
      }
      this.y = wave.getWaveTop(this.x + 32) - 28;
    });
  }
});

TheStage = Class.create(Scene, {
  initialize: function() {
    var bgm, game, ship, wave;

    Scene.call(this);
    game = Core.instance;
    bgm = game.assets['res/snd/stage1.mp3'];
    this.backgroundColor = Constants.BGCOLOR;
    wave = new Wave(1, 2, 1, 4, 1, 8);
    ship = new TheShip(wave);
    this.addChild(wave);
    this.addChild(ship);
    this.addEventListener('enter', function() {
      var bufsrc;

      if (bgm.src) {
        bufsrc = bgm.src;
        bufsrc.loop = true;
        bufsrc.buffer = bgm.buffer;
        bufsrc.connect(bgm.connectTarget);
        bufsrc.noteOn(0);
      }
    });
    return this.addEventListener('enterframe', function() {
      if (!bgm.src) {
        bgm.play();
      }
    });
  }
});

TheGame = Class.create(Core, {
  initialize: function() {
    Core.call(this, Constants.WIDTH, Constants.HEIGHT);
    this.fps = 30;
    this.preload(['res/img/ship.gif']);
    this.preload(['res/snd/stage1.mp3']);
    this.onload = function() {
      this.replaceScene(new TheStage);
    };
    this.start();
  }
});

window.onload = function() {
  return new TheGame;
};
