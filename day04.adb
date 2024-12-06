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
         Put_Line ("Size: " & Num_Bytes'Image);
         Put_Line
           ("Chars per line: "
            & Natural'Image (Natural (Character_IO.Index (F)) - 1));
         Put_Line
           ("Lines: "
            & Natural'Image
                (Num_Bytes / (Natural (Character_IO.Index (F)) - 1)));
      end;
      declare
         Chars_Per_Line : constant Natural :=
           Natural (Character_IO.Index (F)) - 1;
         Lines          : constant Natural := Num_Bytes / Chars_Per_Line;
         -- NOTE: Chars_Per_Line -1 due to the newline being trimmed.
         Result         : Letter_Grid (1 .. Lines, 1 .. Chars_Per_Line - 1);
         I, J           : Natural := 1;
         Char           : Character;
      begin
         Character_IO.Set_Index (F, 1);
         while not Character_IO.End_Of_File (F) loop
            Character_IO.Read (F, Char);
            if Char = ASCII.LF then
               -- End of line.
               I := I + 1;
               J := 1;
            else
               Result (I, J) := Char;
            end if;
         end loop;
         Character_IO.Close (F);
         return Result;
      end;
   end Read_Grid;
   Part_One: Natural := 0;
   Part_Two: Natural := 0;
   Start_Time, End_Time : Time;
   File_Name            : constant String := "input/day04.txt";
   Grid                 : Letter_Grid := Read_Grid (File_Name);
begin
   Start_Time := Clock;
   End_Time := Clock;
   Put_Line ("Part one: " & Natural'Image (Part_One));
   Put_Line ("Part two: " & Natural'Image (Part_Two));
   Put_Line
     ("Procedure took"
      & Duration'Image (To_Duration (End_Time - Start_Time))
      & " seconds");
end Day04;
