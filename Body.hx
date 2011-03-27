// body class

class Body extends CellObject
{
  public var freshness: Int; // body freshness
  public var quality: Int; // body quality

  public function new(g: Game, xv: Int, yv: Int)
    {
      super(g, xv, yv);
      type = 'body';

      freshness = 3;//5 + Std.int(Math.random() * 4);
      quality = 1 + Std.int(Math.random() * 2);
    }


// test solution
  public function testSolution(player: Player): Bool
    {
      die();

      // failure
      if (100 * Math.random() < 45 - 15 * quality)
        {
          ui.msg("You test a new solution on the body... Nothing happens.");
          return true;
        }

      // gain theory
      var mod = 0;
      if (100 * Math.random() < 19 + 40 * (quality - 1))
        {
          player.theory++;
          mod = 1;
          if (quality == 3 && player.theory < 10)
            {
              player.theory++;
              mod = 2;
            }

          if (player.theory > 10)
            player.theory = 10;
        }

      // spawn reanimated
      var spawnOk = false;
      if (100 * Math.random() < 70)
        {
          spawnOk = true;

          // find empty spot near the lab
          var cell = map.findEmpty(player.lab.x - 3, player.lab.y - 3,
            player.lab.w + 6, player.lab.h + 6);
          if (cell == null)
            {
              trace('no empty spots near lab');
              return true;
            }

          var o = new Reanimated(game, cell.x, cell.y);
          o.life = 3 + Std.int(player.theory / 3);
          o.level = 1 + Std.int(player.theory / 3);
          o.skip = true;
        }

      ui.msg(
        (spawnOk ? "With the new solution the body is reanimated! " : 'You have failed to reanimate the body. ') +
        (mod > 0 ? '[Theory +' + mod + ']' : ''));

      return true;
    }


// body activation
  public override function activate(player: Player): Bool
    {
      if (map.get(x,y).subtype == 'lab' || player.theory >= 10)
        return false;

      // find empty spot in lab
      var nx = -1, ny = -1;
      for (yy in player.lab.y...(player.lab.y + player.lab.h))
        {
          for (xx in player.lab.x...(player.lab.x + player.lab.w))
            if (map.get(xx, yy).object == null)
              {
                nx = xx;
                ny = yy;
                break;
              }

          if (nx != -1)
            break;
        }
      
      if (nx == -1) // lab is full
        {
          ui.msg('Your laboratory is full!');
          return false;
        }

      // move this object to lab
      move(nx, ny);

      ui.msg('You bring the specimen to your laboratory.');
      game.panic += 10; // stealing bodies make people suspicious

      map.paint();
      ui.paintStatus();

      return false;//true;
    }


// rot body
  public override function ai()
    {
      // test solution
      if (map.get(x,y).subtype == 'lab')
        {
          testSolution(game.player);
          return;
        }

      // rot
      freshness--;
      if (freshness == 0)
        die();
    }


// object color
  public override function getColor(): String
    {
      if (quality == 1)
        return '#333333';
      else if (quality == 2)
        return '#999999';
      return 'white';
    }


// object symbol
  public override function getSymbol(): String
    {
      return '_';
    }


// object note
  public override function getNote(): String
    {
      return 'body (F ' + freshness + ',Q ' + quality + ')';
    }
}