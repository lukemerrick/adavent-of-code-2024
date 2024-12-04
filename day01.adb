with Ada.Text_IO; use Ada.Text_IO;
with Ada.Containers.Generic_Array_Sort;

procedure Day01 is
   -- Go overboard with types.
   subtype Line_Num is Integer range 1 .. 1_000;
   subtype Number is Integer range 1 .. 99999;
   type Number_Array_Unconstrained is array (Positive range <>) of Number;
   subtype Number_Array is Number_Array_Unconstrained (Line_Num);
   subtype Left_Number_Char_Range is Integer range 1 .. 5;
   subtype Right_Number_Char_Range is Integer range 9 .. 13;

   -- Instantiate the generic sorting function for our arrays.
   procedure Number_Array_Sort is new
     Ada.Containers.Generic_Array_Sort
       (Index_Type   => Positive,
        Element_Type => Number,
        Array_Type   => Number_Array_Unconstrained);

   -- Define our variables.
   F                : File_Type;
   Line             : String (1 .. 13);
   Left             : Number_Array;
   Right            : Number_Array;
   Total_Difference : Natural := 0;
   File_Name        : constant String := "input/day01.txt";
begin
   -- Read the input file.
   Open (F, In_File, File_Name);
   for I in Line_Num loop
      Line := Get_Line (F);
      Left (I) := Number'Value ((Line (Left_Number_Char_Range)));
      Right (I) := Number'Value ((Line (Right_Number_Char_Range)));
   end loop;
   Close (F);

   -- Sort the left and right arrays.
   Number_Array_Sort (Left);
   Number_Array_Sort (Right);

   -- Compute the differences.
   for I in Line_Num loop
      Total_Difference := Total_Difference + abs (Left (I) - Right (I));
   end loop;

   Put_Line (Natural'Image(Total_Difference));
end Day01;
