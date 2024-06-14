unit calculatorform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  calculator;

type

  { TmyCalculatorForm }

  TmyCalculatorForm = class(TForm)
    ButtonCalculate: TButton;
    ButtonClear: TButton;
    ButtonBack: TButton;
    ButtonClearHist: TButton;
    ButtonZero: TButton;
    ButtonZap: TButton;
    ButtonNine: TButton;
    ButtonDiv: TButton;
    ButtonMult: TButton;
    ButtonScobZakr: TButton;
    ButtonScobOt: TButton;
    ButtonPlus: TButton;
    ButtonMinus: TButton;
    ButtonOne: TButton;
    ButtonTwo: TButton;
    ButtonThree: TButton;
    ButtonFour: TButton;
    ButtonFive: TButton;
    ButtonSeven: TButton;
    ButtonEight: TButton;
    ButtonSix: TButton;
    editExpression: TEdit;
    editResult: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    memoText: TMemo;
    procedure ButtonCalculateClick(Sender: TObject);
    procedure ButtonClearClick(Sender: TObject);
    procedure ButtonBackClick(Sender: TObject);
    procedure ButtonClearHistClick(Sender: TObject);
    procedure ButtonZeroClick(Sender: TObject);
    procedure ButtonDivClick(Sender: TObject);
    procedure ButtonEightClick(Sender: TObject);
    procedure ButtonFiveClick(Sender: TObject);
    procedure ButtonFourClick(Sender: TObject);
    procedure ButtonMinusClick(Sender: TObject);
    procedure ButtonMultClick(Sender: TObject);
    procedure ButtonNineClick(Sender: TObject);
    procedure ButtonOneClick(Sender: TObject);
    procedure ButtonPlusClick(Sender: TObject);
    procedure ButtonScobOtClick(Sender: TObject);
    procedure ButtonScobZakrClick(Sender: TObject);
    procedure ButtonSevenClick(Sender: TObject);
    procedure ButtonSixClick(Sender: TObject);
    procedure ButtonThreeClick(Sender: TObject);
    procedure ButtonTwoClick(Sender: TObject);
    procedure ButtonZapClick(Sender: TObject);
    procedure editExpressionChange(Sender: TObject);
    procedure editExpressionEnter(Sender: TObject);
    procedure editExpressionExit(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
  private

  public

  end;

var
  myCalculatorForm: TmyCalculatorForm;
  checkEnter : Boolean = true;

implementation

{$R *.lfm}

{ TmyCalculatorForm }

procedure TmyCalculatorForm.ButtonCalculateClick(Sender: TObject);
var
  str, temp : String;
  myCalculator : TCalculator;
begin
  str := editExpression.Text;
  temp := str;

  myCalculator := TCalculator.Create;
  str := MyCalculator.Calculate(str);

  if(str = 'Nan') then
    editResult.Text := 'not correct data! Try again.'
  else
    editResult.Text := str;

  memoText.Text := memoText.Text + temp + sLineBreak + 'Result: ' + editResult.Text + sLineBreak + sLineBreak;
end;

procedure TmyCalculatorForm.ButtonClearClick(Sender: TObject);
begin
  editExpression.Clear;
end;

procedure TmyCalculatorForm.ButtonBackClick(Sender: TObject);
var
  str: string;
begin
  str := editExpression.Text;
  delete(str, Length(editExpression.Text), 1);
  editExpression.Text := str;
end;

procedure TmyCalculatorForm.ButtonClearHistClick(Sender: TObject);
begin
  memoText.Clear;
end;

procedure TmyCalculatorForm.ButtonZeroClick(Sender: TObject);
begin
   editExpression.Text := editExpression.Text + '0';
end;

procedure TmyCalculatorForm.ButtonDivClick(Sender: TObject);
begin
  editExpression.Text := editExpression.Text + '/';
end;

procedure TmyCalculatorForm.ButtonEightClick(Sender: TObject);
begin
  editExpression.Text := editExpression.Text + '8';
end;

procedure TmyCalculatorForm.ButtonFiveClick(Sender: TObject);
begin
  editExpression.Text := editExpression.Text + '5';
end;

procedure TmyCalculatorForm.ButtonFourClick(Sender: TObject);
begin
  editExpression.Text := editExpression.Text + '4';
end;

procedure TmyCalculatorForm.ButtonMinusClick(Sender: TObject);
begin
   editExpression.Text := editExpression.Text + '-';
end;

procedure TmyCalculatorForm.ButtonMultClick(Sender: TObject);
begin
  editExpression.Text := editExpression.Text + '*';
end;

procedure TmyCalculatorForm.ButtonNineClick(Sender: TObject);
begin
  editExpression.Text := editExpression.Text + '9';
end;

procedure TmyCalculatorForm.ButtonOneClick(Sender: TObject);
begin
  editExpression.Text := editExpression.Text + '1';
end;

procedure TmyCalculatorForm.ButtonPlusClick(Sender: TObject);
begin
   editExpression.Text := editExpression.Text + '+';
end;

procedure TmyCalculatorForm.ButtonScobOtClick(Sender: TObject);
begin
   editExpression.Text := editExpression.Text + '(';
end;

procedure TmyCalculatorForm.ButtonScobZakrClick(Sender: TObject);
begin
   editExpression.Text := editExpression.Text + ')';
end;

procedure TmyCalculatorForm.ButtonSevenClick(Sender: TObject);
begin
   editExpression.Text := editExpression.Text + '7';
end;

procedure TmyCalculatorForm.ButtonSixClick(Sender: TObject);
begin
   editExpression.Text := editExpression.Text + '6';
end;

procedure TmyCalculatorForm.ButtonThreeClick(Sender: TObject);
begin
   editExpression.Text := editExpression.Text + '3';
end;

procedure TmyCalculatorForm.ButtonTwoClick(Sender: TObject);
begin
  editExpression.Text := editExpression.Text + '2';
end;

procedure TmyCalculatorForm.ButtonZapClick(Sender: TObject);
begin
  editExpression.Text := editExpression.Text + ',';
end;

procedure TmyCalculatorForm.editExpressionChange(Sender: TObject);
var
  expression : string;
  symbExpression : char;
  i : Cardinal;
begin
  expression := editExpression.Text;
  if not (Length(expression) = 0) then
    begin
      for i:= 1 to Length(expression) do
      begin
        if not ((expression[i] in ['+', '-', '/', '*', '(', ')', ',']) or (Ord(expression[i]) > 47) and (Ord(expression[i]) < 58)) then
          delete(expression, i, 1);
      end;
    end;
  editExpression.Text := expression;
end;

procedure TmyCalculatorForm.editExpressionEnter(Sender: TObject);
begin
  checkEnter := false;
end;

procedure TmyCalculatorForm.editExpressionExit(Sender: TObject);
begin
  checkEnter := true;
end;

procedure TmyCalculatorForm.FormKeyPress(Sender: TObject; var Key: char);
begin
  if(checkEnter) then
     editExpression.Text := editExpression.Text + Key;
end;

end.

