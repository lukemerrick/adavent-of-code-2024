with Ada.Text_IO;    use Ada.Text_IO;
with Ada.Real_Time;  use Ada.Real_Time;
with Ada.Assertions; use Ada.Assertions;
with Ada.Strings.Bounded;

procedure Day03 is
   package B_Str is new Ada.Strings.Bounded.Generic_Bounded_Length (Max => 3);
   use B_Str;
   subtype Numerals is Character range '0' .. '9';
   type Parse_State is
     (Before_M,
      After_M,
      After_Mu,
      After_Mul,
      In_First_Number,
      In_Second_Number);
   Start_Time, End_Time        : Time;
   F                           : File_Type;
   Char                        : Character;
   Part_One                    : Natural := 0;
   State                       : Parse_State := Before_M;
   Number_Chars                : Bounded_String := To_Bounded_String ("");
   First_Number, Second_Number : Natural;
   File_Name                   : constant String := "input/day03.txt";
begin
   Start_Time := Clock;
   Open (F, In_File, File_Name);
   while not End_Of_File (F) loop
      Get (F, Char);
      case State is
         when Before_M =>
            State := (if Char = 'm' then After_M else Before_M);

         when After_M =>
            State := (if Char = 'u' then After_Mu else Before_M);

         when After_Mu =>
            State := (if Char = 'l' then After_Mul else Before_M);

         when After_Mul =>
            State := (if Char = '(' then In_First_Number else Before_M);

         when In_First_Number =>
            case Char is
               when Numerals =>
                  Append (Number_Chars, Char);

               when ',' =>
                  if Length (Number_Chars) = 0 then
                     -- Edge case: `mul(,` is invalid.
                     State := Before_M;
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
                  State := Before_M;
            end case;

         when In_Second_Number =>
            case Char is
               when Numerals =>
                  Append (Number_Chars, Char);

               when ')' =>
                  if Length (Number_Chars) = 0 then
                     -- Edge case: `mul(123,)` is invalid.
                     State := Before_M;
                  else
                     declare
                        Number_String : String := To_String (Number_Chars);
                     begin
                        Second_Number := Natural'Value (Number_String);
                     end;
                     Part_One := Part_One + First_Number * Second_Number;
                     State := Before_M;
                     Number_Chars := To_Bounded_String ("");
                  end if;

               when others =>
                  State := Before_M;
                  Number_Chars := To_Bounded_String ("");
            end case;

         when others =>
            State := Before_M;
      end case;
   end loop;
   Close (F);
   End_Time := Clock;
   Put_Line ("Part one: " & Natural'Image (Part_One));
   Put_Line
     ("Procedure took"
      & Duration'Image (To_Duration (End_Time - Start_Time))
      & " seconds");
end Day03;
