with Ada.Text_IO;    use Ada.Text_IO;
with Ada.Real_Time;  use Ada.Real_Time;
with Ada.Assertions; use Ada.Assertions;
with Ada.Strings.Bounded;
with Ada.Characters.Latin_1;

procedure Day03 is
   package B_Str is new Ada.Strings.Bounded.Generic_Bounded_Length (Max => 3);
   use B_Str;
   subtype Numerals is Character range '0' .. '9';
   type Parse_State is
     (Before,
      After_M,
      After_Mu,
      After_Mul,
      In_First_Number,
      In_Second_Number,
      After_D,
      After_Do,
      After_Don,
      After_Don_Apostrophe,
      After_Dont,
      After_Do_Lparen,
      After_Dont_Lparen);
   Start_Time, End_Time        : Time;
   F                           : File_Type;
   Char                        : Character;
   Part_One                    : Natural := 0;
   Part_Two                    : Natural := 0;
   State                       : Parse_State := Before;
   Is_Do                       : Boolean := True;
   Number_Chars                : Bounded_String := To_Bounded_String ("");
   First_Number, Second_Number : Natural;
   File_Name                   : constant String := "input/day03.txt";
begin
   Start_Time := Clock;
   Open (F, In_File, File_Name);
   while not End_Of_File (F) loop
      Get (F, Char);
      case State is
         when Before =>
            case Char is
               when 'd' =>
                  State := After_D;

               when 'm' =>
                  State := After_M;

               when others =>
                  null;
            end case;

         when After_D =>
            State := (if Char = 'o' then After_Do else Before);

         when After_Do =>
            case Char is
               when 'n' =>
                  State := After_Don;

               when '(' =>
                  State := After_Do_Lparen;

               when others =>
                  State := Before;
            end case;

         when After_Don =>
            State :=
              (if Char = Ada.Characters.Latin_1.Apostrophe
               then After_Don_Apostrophe
               else Before);

         when After_Don_Apostrophe =>
            State := (if Char = 't' then After_Dont else Before);

         when After_Dont =>
            State := (if Char = '(' then After_Dont_Lparen else Before);

         when After_Do_Lparen =>
            if Char = ')' then
               Is_Do := True;
            end if;
            State := Before;

         when After_Dont_Lparen =>
            if Char = ')' then
               Is_Do := False;
            end if;
            State := Before;

         when After_M =>
            State := (if Char = 'u' then After_Mu else Before);

         when After_Mu =>
            State := (if Char = 'l' then After_Mul else Before);

         when After_Mul =>
            State := (if Char = '(' then In_First_Number else Before);

         when In_First_Number =>
            case Char is
               when Numerals =>
                  Append (Number_Chars, Char);

               when ',' =>
                  if Length (Number_Chars) = 0 then
                     -- Edge case: `mul(,` is invalid.
                     State := Before;
                  else
                     declare
                        Number_String : String := To_String (Number_Chars);
                     begin
                        First_Number := Natural'Value (Number_String);
                     end;
                     Number_Chars := To_Bounded_String ("");
                     State := In_Second_Number;
                  end if;

               when others =>
                  Number_Chars := To_Bounded_String ("");
                  State := Before;
            end case;

         when In_Second_Number =>
            case Char is
               when Numerals =>
                  Append (Number_Chars, Char);

               when ')' =>
                  if Length (Number_Chars) = 0 then
                     -- Edge case: `mul(123,)` is invalid.
                     State := Before;
                  else
                     declare
                        Number_String : String := To_String (Number_Chars);
                     begin
                        Second_Number := Natural'Value (Number_String);
                     end;
                     Part_One := Part_One + First_Number * Second_Number;
                     if Is_Do then
                        Part_Two := Part_Two + First_Number * Second_Number;
                     end if;
                     State := Before;
                     Number_Chars := To_Bounded_String ("");
                  end if;

               when others =>
                  State := Before;
                  Number_Chars := To_Bounded_String ("");
            end case;

         when others =>
            State := Before;
      end case;
   end loop;
   Close (F);
   End_Time := Clock;
   Put_Line ("Part one: " & Natural'Image (Part_One));
   Put_Line ("Part two: " & Natural'Image (Part_Two));
   Put_Line
     ("Procedure took"
      & Duration'Image (To_Duration (End_Time - Start_Time))
      & " seconds");
end Day03;
