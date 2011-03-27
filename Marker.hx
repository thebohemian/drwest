// marker object

class Marker extends CellObject
{
  public function new(g: Game, xv: Int, yv: Int)
    {
      super(g, xv, yv, true);
      type = 'marker';
      life = 0;
    }


  public override function activate(p: Player): Bool
    {
      die();
      return false;
    }


// object color
  public override function getColor(): String
    {
      return 'red';
    }


// object symbol
  public override function getSymbol(): String
    {
      return '!';
    }
}
