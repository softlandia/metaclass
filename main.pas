unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids;

type
  TIntGrid = class helper for TStringGrid
  private
    procedure setInt(c,r,val:integer);
  public
    property ints[c,r:integer]:integer write setInt;
  end;

  TSolver = class
    function getResults(index:integer):integer; virtual;abstract;
    procedure solve(); virtual; abstract;
    property results[index:integer]:integer read getResults;
  end;

  TSolverClass = class of TSolver;

  TFirstSolver = class(TSolver)
    first : array[0..10] of integer;
    function getResults(index:integer):integer; override;
    procedure solve(); override;
  end;

  TSecondSolver = class (TSolver)
    second : array[0..10] of integer;
    function getResults(index:integer):integer; override;
    procedure solve(); override;
  end;

  TfrmMain = class(TForm)
    typeSelect: TComboBox;
    grid: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure typeSelectChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TIntGrid.setInt(c, r,val: integer);
begin
    cells[c,r] := intToStr(val);
end;

function TFirstSolver.getResults(index: integer): integer;
begin
    result := first[index];
end;

procedure TFirstSolver.solve();
var i:byte;
begin
    for i in [0..10] do
        first[i] := i + 1;
end;

procedure TSecondSolver.solve();
var i:byte;
begin
    for i:=0 to 10 do
        second[i] := i*i;
end;
function TSecondSolver.getResults(index: integer): integer;
begin
    result := second[index];
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
    with typeSelect.Items do begin
        addObject('first',  TObject(TFirstSolver));
        addObject('second', TObject(TSecondSolver));
    end;
end;

procedure TfrmMain.typeSelectChange(Sender: TObject);
var solverType : TSolverClass;
    solver : TSolver;
    i : integer;
begin
    i := typeSelect.ItemIndex;
    solverType := TSolverClass(typeSelect.Items.Objects[i]);
    solver := solverType.Create;
    solver.solve();

    for i:= 0 to 10 do begin
         grid.ints[i,0 ] := i;
         grid.ints[i,1 ] := solver.results[i];
    end;
    solver.Free;
end;

end.
