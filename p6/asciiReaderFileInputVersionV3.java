// Christian Winds
// CSC 322 Fall 2018
// Program 6.1 - ASCII Art
// This program creates an assembly data set for ASCII art.
// Friday, November 16th, 2018

import java.util.Scanner;
import java.io.File;
import java.lang.Object;

public class asciiReaderFileInputVersionV3
{
	public static void main(String[] args)
	{
		// Set the number of rows and columns of the input ASCII art
		int totalRowNumber = 30;
		int totalColumnNumber = 80;

		// Prepare counters for the current row and column numbers read
		int currentRowNumber = 0;
		int currentColumnNumber = 0;

		// Create booleans to handle use of leading zeroes while printing ASCII art data
		boolean useLeadingRowZero = false;
		boolean useLeadingColumnZero = false;

		// Create strings to place leading zeroes in the row and column number printouts
		String leadingRowZero = "";
		String leadingColumnZero = "";

		// Create a string variable to hold individual ASCII art lines
		String asciiArtLine = "";

		try
		{
			Scanner stdin = new Scanner(new File("Violet Dragon ASCII Art.txt"));

			// Move through the ASCII art's rows
			for (currentRowNumber = 0; currentRowNumber < totalRowNumber; currentRowNumber++)
			{
				// Store the current ASCII art line
				asciiArtLine = stdin.nextLine();

				// Print each ASCII art character's row and column numbers
				for (currentColumnNumber = 0; currentColumnNumber < totalColumnNumber; currentColumnNumber++)
				{
					String asciiArtCharacter = "";

					// Store the current ASCII art character
					asciiArtCharacter = asciiArtLine.substring(currentColumnNumber,currentColumnNumber+1);

					// Set the printed row number
					int printoutRowNumber = currentRowNumber + 1;

					// Set the leading row zero if necessary
					useLeadingRowZero = printoutRowNumber < 10;
					if (useLeadingRowZero)
						leadingRowZero = "0";
					else
						leadingRowZero = "";

					// Set the printed column number
					int printoutColumnNumber = currentColumnNumber + 1;

					// Set the leading column zero if necessary
					useLeadingColumnZero = printoutColumnNumber < 10;
					if (useLeadingColumnZero)
						leadingColumnZero = "0";
					else
						leadingColumnZero = "";

					// Print the current ASCII art character data line
					System.out.println("db 1bh, \"[" + leadingRowZero + printoutRowNumber + ";" + leadingColumnZero + printoutColumnNumber + "H" + asciiArtCharacter + "\"");
				}
			}
		}
		catch (Exception exception)
		{
			// State that the input source file was not found if the input file cannot be located
			System.out.println("The input source file was not found...");
		}
	}
}
