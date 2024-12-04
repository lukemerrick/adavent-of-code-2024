with Ada.Text_IO;    use Ada.Text_IO;
with Ada.Real_Time;  use Ada.Real_Time;
with Ada.Containers.Vectors;
with Ada.Assertions; use Ada.Assertions;

procedure Day02 is
   -- Prepare variable-length container for numbers.
   package Natural_Vectors is new
     Ada.Containers.Vectors (Index_Type => Natural, Element_Type => Natural);
   use Natural_Vectors;

   subtype Line_Num is Integer range 1 .. 1_000;
   type Increasing_Status is
     (Status_Unknown, Status_Increasing, Status_Decreasing);

   -- Procedure to read the next line into a preallocated vector.
   procedure Read_Report (Report_Line : String; Report : out Vector) is
      Start_Index : Natural := Report_Line'First;
      Sep         : constant Character := ' ';
   begin
      Clear (Report);

      -- Go index-by-index, extracting on spaces.
      for I in Report_Line'Range loop
         if Report_Line (I) = Sep then
            Report.Append (Natural'Value (Report_Line (Start_Index .. I - 1)));
            Start_Index := I + 1;
         end if;
      end loop;

      -- Last item.
      Assert (Report_Line'Last >= Start_Index);
      Report.Append
        (Natural'Value (Report_Line (Start_Index .. Report_Line'Last)));
   end Read_Report;

   -- Procedure for printing report (for sanity checking).
   procedure Print_Report (Report : Vector) is
   begin
      Put ("Report: ");
      for X of Report loop
         Put (Natural'Image (X) & ",");
      end loop;
      Put_Line ("");
   end Print_Report;

   -- Helper function for unsafe patterns.
   function Is_Unsafe_Difference
     (Difference : Integer; Increasing : Increasing_Status) return Boolean is
   begin
      return
        abs (Difference) < 1
        or abs (Difference) > 3
        or (Increasing = Status_Increasing and Difference < 0)
        or (Increasing = Status_Decreasing and Difference > 0);
   end Is_Unsafe_Difference;

   -- Function for detecting unsafe patterns.
   -- NOTE: This got really hacky to handle skipping. TODO: Write a cleaner version!
   function Check_Report_Safety
     (Report : Vector; Skip : Integer := -1) return Integer
   is
      Increasing  : Increasing_Status := Status_Unknown;
      Difference  : Integer;
      First_Index : Natural;
      Current     : Natural;
      Previous    : Natural;
   begin
      First_Index :=
        (if Skip = Report.First_Index then Report.First_Index + 2
         else Report.First_Index + 1);
      for I in First_Index .. Report.Last_Index loop
         if Skip /= I then
            Current := Report (I);
            Previous :=
              (if Skip = I - 1 then Report (I - 2) else Report (I - 1));
            Difference := Current - Previous;

            -- If we're just starting, set increasing status.
            if Increasing = Status_Unknown then
               Increasing :=
                 (if Difference > 0 then Status_Increasing
                  else Status_Decreasing);
            end if;

            if Is_Unsafe_Difference (Difference, Increasing) then
               return I;
            end if;
         end if;
      end loop;
      return -1;
   end Check_Report_Safety;

   -- Part 2.
   function Check_Report_Safety_Dampened (Report : Vector) return Boolean is
      Failure_Index : Integer;
      Used_Dampener : Boolean := False;
   begin
      Failure_Index := Check_Report_Safety (Report);
      if Failure_Index = -1 then
         return True;
      end if;
      return
        Check_Report_Safety (Report, Skip => Failure_Index) = -1
        or Check_Report_Safety (Report, Skip => Failure_Index - 1) = -1
        or Check_Report_Safety (Report, Skip => Failure_Index - 2) = -1;
   end Check_Report_Safety_Dampened;

   Start_Time, End_Time : Time;
   F                    : File_Type;
   Report               : Vector;
   Safe_Count           : Natural := 0;
   Safe_Count_Dampened  : Natural := 0;
   File_Name            : constant String := "input/day02.txt";
begin
   Start_Time := Clock;
   Open (F, In_File, File_Name);
   for I in Line_Num loop
      declare
         Report_Line : String := Get_Line (F);
      begin
         Read_Report (Report_Line, Report);
         if Check_Report_Safety (Report) = -1 then
            Safe_Count := Safe_Count + 1;
         end if;
         if Check_Report_Safety_Dampened (Report) then
            Safe_Count_Dampened := Safe_Count_Dampened + 1;
         end if;
      end;
   end loop;
   Close (F);
   End_Time := Clock;
   Put_Line ("Part one: " & Natural'Image (Safe_Count));
   Put_Line ("Part two: " & Natural'Image (Safe_Count_Dampened));
   Put_Line
     ("Procedure took"
      & Duration'Image (To_Duration (End_Time - Start_Time))
      & " seconds");
end Day02;
