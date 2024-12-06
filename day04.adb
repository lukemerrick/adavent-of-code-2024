with Ada.Text_IO;    use Ada.Text_IO;
with Ada.Direct_IO;
with Ada.Real_Time;  use Ada.Real_Time;
with Ada.Assertions; use Ada.Assertions;

procedure Day04 is
   type Letter_Grid is array (Natural range <>, Natural range <>) of Character;

   -- Read the file into an array.
   -- NOTE: This is a cool Ada feature -- we can define an array of undefined shape
   -- as the type we work with, and at runtime we'll end up with an array on the stack
   -- using runtime-determined shape!
   package Character_IO is new Ada.Direct_IO (Character);
   function Read_Grid (File_Name : String) return Letter_Grid is
      F         : Character_IO.File_Type;
      Num_Bytes : Natural;
   begin
      Character_IO.Open (F, Character_IO.In_File, File_Name);
      Num_Bytes := Natural (Character_IO.Size (F));
      declare
         Char : Character;
      begin
         Character_IO.Read (F, Char);
         while Char /= ASCII.LF loop
            Character_IO.Read (F, Char);
         end loop;
      end;
      declare
         Chars_Per_Line : constant Natural :=
           Natural (Character_IO.Index (F)) - 1;
         Lines          : constant Natural := Num_Bytes / Chars_Per_Line;
         -- NOTE: Chars_Per_Line -1 due to the newline being trimmed.
         Result         : Letter_Grid (1 .. Lines, 1 .. Chars_Per_Line - 1);
         Line           : Natural := 1;
         Char           : Character;
      begin
         Character_IO.Set_Index (F, 1);
         for I in 1 .. Num_Bytes loop
            Character_IO.Read (F, Char);
            if Char = ASCII.LF then
               Line := Line + 1;
            else
               declare
                  Column : Natural := I mod Chars_Per_Line;
               begin
                  Result (Line, Column) := Char;
               end;
            end if;
         end loop;
         Character_IO.Close (F);
         return Result;
      end;
   end Read_Grid;

   function Count_From_X
     (Grid : Letter_Grid; I : Natural; J : Natural) return Natural
   is
      Result : Natural := 0;
   begin
      for Row_Sign in -1 .. 1 loop
         for Col_Sign in -1 .. 1 loop
            if not (Row_Sign = 0 and then Col_Sign = 0) then
               declare
                  I_Final    : Integer := I + Row_Sign * 3;
                  J_Final    : Integer := J + Col_Sign * 3;
                  I_Inbounds : Boolean :=
                    I_Final >= 1 and then I_Final <= Grid'Last(1);
                  J_Inbounds : Boolean :=
                    J_Final >= 1 and then J_Final <= Grid'Last(2);
                  Hit        : Boolean :=
                    I_Inbounds
                    and then J_Inbounds
                    and then Grid (I + Row_Sign * 1, J + Col_Sign * 1) = 'M'
                    and then Grid (I + Row_Sign * 2, J + Col_Sign * 2) = 'A'
                    and then Grid (I + Row_Sign * 3, J + Col_Sign * 3) = 'S';
               begin
                  if Hit then
                     Result := Result + 1;
                  end if;
               end;
            end if;
         end loop;
      end loop;
      return Result;
   end Count_From_X;

   function Count_From_A
     (Grid : Letter_Grid; I : Natural; J : Natural) return Boolean
   is
      Signs      : constant array (Natural range <>) of Integer := (-1, 1);
      I_Inbounds : constant Boolean := I >= 2 and then I <= Grid'Last(1) - 1;
      J_Inbounds : constant Boolean := J >= 2 and then J <= Grid'Last(2) - 1;
   begin
      if not (I_Inbounds and then J_Inbounds) then
         return False;
      end if;
      return
        -- Top left and bottom right.
        ((Grid (I - 1, J - 1) = 'M' and then Grid (I + 1, J + 1) = 'S')
         or (Grid (I - 1, J - 1) = 'S' and then Grid (I + 1, J + 1) = 'M'))
        -- Top right and bottom left.
        and then ((Grid (I + 1, J - 1) = 'M'
                   and then Grid (I - 1, J + 1) = 'S')
                  or (Grid (I + 1, J - 1) = 'S'
                      and then Grid (I - 1, J + 1) = 'M'));
   end Count_From_A;

   Part_One             : Natural := 0;
   Part_Two             : Natural := 0;
   Start_Time, End_Time : Time;
   File_Name            : constant String := "input/day04.txt";
   Grid                 : constant Letter_Grid := Read_Grid (File_Name);
begin
   Start_Time := Clock;
   for I in Grid'Range(1) loop
      for J in Grid'Range(2) loop
         declare
            Char : Character := Grid (I, J);
         begin
            if Char = 'X' then
               Part_One :=
                 Part_One + Count_From_X (Grid => Grid, I => I, J => J);
            end if;
            if Char = 'A' and Count_From_A (Grid => Grid, I => I, J => J) then
               Part_Two := Part_Two + 1;
            end if;
         end;
      end loop;
   end loop;
   End_Time := Clock;
   Put_Line ("Part one: " & Natural'Image (Part_One));
   Put_Line ("Part two: " & Natural'Image (Part_Two));
   Put_Line
     ("Procedure took"
      & Duration'Image (To_Duration (End_Time - Start_Time))
      & " seconds");
end Day04;
