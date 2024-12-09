#!/usr/bin/env wolframscript

(* The first argument is the input file, the second is the output file *)
inputFile  = $ScriptCommandLine[[2]];
outputFile = $ScriptCommandLine[[3]];

(* Import the single list from the input file *)
expr = Import[inputFile, "List"];

If[!ListQ[expr],
   Print["The input file did not contain a single list."];
   Exit[1];
];

(* Convert the list back to a string with controlled formatting *)
formatted = ToString[expr, InputForm, PageWidth -> 78];

(* Export the formatted string to the output file *)
Export[outputFile, formatted, "Text"];
