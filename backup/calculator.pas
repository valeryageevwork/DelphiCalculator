unit calculator;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Math;

type
  TCalculator = class

private
const
  mathSymb = '+-*/('; // математические символы
  priorityOperation: array [1 .. 5] of byte = (1, 1, 2, 2, 0); // приоритет операций
var
  arrNumbers: array of Real; // массив чисел
  arrCommands: array of Char; // массив команд
  lenNum, lenCom: Cardinal;
  // lenNum - длина массива чисел,
  // lenCom - массива команд
procedure PushNum(num: Real);

function PopNum: Real;

procedure PushCom(op: Char);

function PopCom: Char;

function TransfInNumber(firstNumber, secondNumber: Real; op: Char): Real;

function PreTransfInPostfix(expressionText: String) : String;

function TransfInPostfix(expressionText: String): String;

function CalculateInNumber(expressionText: String): Real;

function CheckExpression(expressionText: string; i : Cardinal): Boolean;

public

function Calculate(expressionText: String): String;

end;

implementation

procedure TCalculator.PushNum(num: Real);
begin
  Inc(lenNum);
  arrNumbers[lenNum] := num;
end;

function TCalculator.PopNum: Real;
begin
  PopNum := arrNumbers[lenNum];
  arrNumbers[lenNum] := 0;
  Dec(lenNum);
end;

procedure TCalculator.PushCom(op: Char);
begin
  Inc(lenCom);
  arrCommands[lenCom] := op;
end;

function TCalculator.PopCom: Char;
begin
  PopCom := arrCommands[lenCom];
  arrCommands[lenCom] := #0;
  Dec(lenCom);
end;

function TCalculator.TransfInNumber(firstNumber, secondNumber: Real; op: Char): Real;
var
  res: Real;
begin
  case op of
    '+': res := firstNumber + secondNumber;
    '-': res := firstNumber - secondNumber;
    '*': res := firstNumber * secondNumber;
    '/':
    begin
      if(secondNumber = 0) then
        res := NaN
      else
        res := firstNumber / secondNumber;
    end;
  end;
  TransfInNumber := res;
end;

function TCalculator.PreTransfInPostfix(expressionText: String) : String;
var
  i: Cardinal;
begin
  if(not (Length(expressionText) = 0)) then
  begin
    SetLength(arrNumbers, Length(expressionText));
    SetLength(arrCommands, Length(expressionText));
     if expressionText[1] = '-' then
       expressionText := '0' + expressionText;
    i := 1;
    while i <= Length(expressionText) do
    if (expressionText[i] = '(') and (expressionText[i + 1] = '-') then
      insert('0', expressionText, i + 1)
    else
      Inc(i);
    PreTransfInPostfix := expressionText;
  end;
end;

function TCalculator.CheckExpression(expressionText: string; i : Cardinal): Boolean;
var
  flag : Boolean;
  number : Real;
begin
  flag := false;
  if (expressionText[i] in ['+', '-', '*', '/', '(', ')']) then
    begin

      if expressionText[i] = '(' then
        if (i > 1) then
          if (TryStrToFloat(expressionText[i-1], number)) then
            begin
              flag := true;
            end;

      if expressionText[i] = ')' then
        begin
          if (i > 1) and not (i = Length(expressionText)) then
            if not (((expressionText[i-1] = ')') or TryStrToFloat(expressionText[i-1], number))
               and (expressionText[i+1] in ['+', '-', '*', '/', ')'])) then
              begin
                flag := true;
              end;
          if (lenCom = 0) then
            begin
              flag := true;
            end;
        end;

      if expressionText[i] in ['+', '-', '*', '/'] then
        begin
          if not ((i > 1) and not (i = Length(expressionText))) then
            flag := true
          else
            begin
              if not ((TryStrToFloat(expressionText[i-1], number) or (expressionText[i-1] = ')'))
              and ((expressionText[i+1] = '(') or TryStrToFloat(expressionText[i+1], number)))then
                flag := true;
            end;
        end;
    end;
  CheckExpression := flag;
end;

function TCalculator.TransfInPostfix(expressionText: String): String;
var
  i, lenExpString: Cardinal;
  resultString: String;
  flagProbel: Boolean;
  number: Real;
begin
  if(not (Length(expressionText) = 0)) then
    begin
      lenExpString := Length(expressionText);
      flagProbel := false; // для пробела после числа
      for i := 1 to lenExpString do
        begin
          if not(expressionText[i] in ['+', '-', '*', '/', '(', ')']) then  // записываем число
            begin
              if flagProbel then
                resultString := resultString + ' ';
              resultString := resultString + expressionText[i];
              flagProbel := false;
            end
          else // работаем с командами
            begin
              flagProbel := true;
              if expressionText[i] = '(' then // если скобка - добавляем в стек
                begin
                  if(CheckExpression(expressionText, i)) then
                  begin
                    resultString := '';
                    break;
                  end;
                  PushCom(expressionText[i]);
                end
              else
                if expressionText[i] = ')' then // если закр. скобка
                  // добавляем в результат-строку все команды
                  // которые были в стеке по принципу LIFO
                  // и извлекаем из стека откр. скобку в конце
                    begin
                      if(i > 1) then
                        if(CheckExpression(expressionText, i)) then
                          begin
                            resultString := '';
                            break;
                          end;
                        while ((arrCommands[lenCom] <> '(') and (lenCom > 0)) do
                          begin
                            resultString := resultString + ' ' + PopCom;
                          end;
                        if(CheckExpression(expressionText, i)) then
                          begin
                            resultString := '';
                            break;
                          end;
                        PopCom;
                    end;
              if expressionText[i] in ['+', '-', '*', '/'] then
                begin
                  while ((priorityOperation[Pos(arrCommands[lenCom], mathSymb)] >= priorityOperation[Pos(expressionText[i], mathSymb)])) do
                    // проходимся по стеку команд и сравниваем приоритет операций
                    // в стеке и в строке исходной. Если приоритет в стеке выше
                    // помещаем в результирующую строку и убираем из стека команду
                    // во всех случаях помещаем в стек новую команду
                    resultString := resultString + ' ' + PopCom;

                  PushCom(expressionText[i]);

                  if (CheckExpression(expressionText, i)) then
                    begin
                      resultString := '';
                      break;
                    end;
                end;
            end;
        end;

      if (not(Length(resultString) = 0)) then
        begin
          while lenCom <> 0 do // извлекаем из стека команды в результирующую строку
            resultString := resultString + ' ' + PopCom;
          TransfInPostfix := resultString + ' ';
        end
      else
        TransfInPostfix := resultString;
    end;
end;

function TCalculator.CalculateInNumber(expressionText: String): Real;
var
  charBufer: String;
  floatValue, firstNumber, secondNumber, temp: Real;
  charOperator, mathOperand: Char;
  i, j, n: Cardinal;
begin
  if(not (Length(expressionText) = 0)) then
    begin
      n := Length(expressionText);
      i := 1;
      repeat
        j := i;

        if(expressionText[1] = ' ') then
          delete(expressionText, 1, 1);

        while(not (expressionText[i] = ' ') and (i < n)) do
        begin
           Inc(i);
        end;

        charBufer := copy(expressionText, j, i - j);
        charOperator := charBufer[1];

        if (charOperator in ['+', '-', '*', '/']) then
          begin
            secondNumber := PopNum;
            firstNumber:= PopNum;
            mathOperand := charOperator;
            PushNum(TransfInNumber(firstNumber, secondNumber, mathOperand));
          end
        else
          begin
            if(TryStrToFloat(charBufer, temp) and not((charBufer[1] = ',') or
               (Pos('0', charBufer) = 1) and not (Length(charBufer) = 1) or
               (Pos(',', charBufer) = Length(charBufer)))) then
              begin
                floatValue := StrToFloat(charBufer);
                PushNum(floatValue);
              end
            else
              begin
                floatValue := NaN;
                break;
              end;
          end;
        Inc(i);
      until i >= n;
      if(IsNaN(floatValue)) then
        CalculateInNumber := NaN
      else
        begin
          floatValue := PopNum;
          CalculateInNumber := floatValue;
        end;
    end
  else
    CalculateInNumber := NaN;
end;

function TCalculator.Calculate(expressionText: String): String;
begin
  expressionText := PreTransfInPostfix(expressionText);
  expressionText := TransfInPostfix(expressionText);
  Calculate := FloatToStrF(CalculateInNumber(expressionText),ffFixed, 4, 4);
end;

end.


