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

   -- Define a procedure to read the input file.
   procedure Read_Input
     (File_Name : String; Left_Array, Right_Array : out Number_Array)
   is
      F    : File_Type;
      Line : String (1 .. 13);
   begin
      Open (F, In_File, File_Name);
      for I in Line_Num loop
         Line := Get_Line (F);
         Left_Array (I) := Number'Value ((Line (Left_Number_Char_Range)));
         Right_Array (I) := Number'Value ((Line (Right_Number_Char_Range)));
      end loop;
      Close (F);
   end Read_Input;

   -- Define a function to compute differences, solving part 1.
   function Part_One (Sorted_Left, Sorted_Right : Number_Array) return Natural
   is
      Total_Difference : Natural := 0;
   begin
      for I in Line_Num loop
         Total_Difference :=
           Total_Difference + abs (Sorted_Left (I) - Sorted_Right (I));
      end loop;
      return Total_Difference;
   end Part_One;

   -- Define a function to compute similarity score, solving part 2.
   function Part_Two (Sorted_Left, Sorted_Right : Number_Array) return Natural
   is
      I_Right  : Line_Num := 1;
      Similarity_Score : Natural := 0;
   begin
      for Left_Val of Sorted_Left loop
         -- Advance until right is not less than left.
         while Sorted_Right(I_Right) < Left_Val loop
            I_Right := I_Right + 1;
         end loop;

         -- Do all similarity.
         while Sorted_Right(I_Right) = Left_Val loop
            Similarity_Score := Similarity_Score + Left_Val;
            I_Right := I_Right + 1;
         end loop;
      end loop;
      return Similarity_Score;
   end Part_Two;

   -- Define our variables.
   Left, Right     : Number_Array;
   File_Name : constant String := "input/day01.txt";
begin
   -- Read the input file.
   --  Open (F, In_File, File_Name);
   --  for I in Line_Num loop
   --     Line := Get_Line (F);
   --     Left (I) := Number'Value ((Line (Left_Number_Char_Range)));
   --     Right (I) := Number'Value ((Line (Right_Number_Char_Range)));
   --  end loop;
   --  Close (F);
   Read_Input (File_Name, Left, Right);

   -- Sort the left and right arrays.
   Number_Array_Sort (Left);
   Number_Array_Sort (Right);

   -- Compute the differences, solving part 1.
   Put_Line (Natural'Image (Part_One (Left, Right)));

   -- Compute similarity score, solving part 2.
   Put_Line (Natural'Image (Part_Two (Left, Right)));
end Day01;
