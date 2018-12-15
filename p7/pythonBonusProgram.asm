; * Conversions:
; *	structi.asm:
; *		mStruct > pStruct
; *		theMessage > pythonBody
; *		msgSize > pythonLen
; *		byebye > moveCursor
; *		message > python
; *		adjustMessage > adjustPython
; *		amTop > apTop
; *		carry > decreaseColCarry
; *		_displayMessage > _displayPython
; *	forkAndFile.asm:
; *		parent > parentProcess
; *		childProc > childProcess
; *		bob.txt > inputFile.txt
; *	getchar.asm
; *		childPID > childProcessID (-- {188} --)

; * Program Notes
;   [*] Completed Tasks/Progress
;	* The python currently moves left (since backup 20).
;	* The python can currently move rightward, downward, and presumably upward (since backup 34).
;	* Delay values have been determined (but not yet set) since backup 39:
;		*	1 second: 1,0
;		*	1/2 second: 0,500000000
;		*	1/3 second: 0,333333333
;		*	1/4 second: 0,250000000
;	* As of backup 67, second delay values have been set in source code.
;	* Second delay values have been tested successfully as of backup 73.
;	    * :: The seconds data is held as an array.
;	* As of backup 73, speed delay values may be changed by hard-coding the speed variable. Each speed delay length occurs properly.
;	[[* New Code Section *]] As of backup 78, the movement methods for the python have been set. Control of the python should be coded from backup 79 onward until python controls complete.
;		[[ ! Notice ! ]] Before coding control of the python's movement, from backup 81 onward, ensure that the child process properly ends at the program's conclusion.
;			* {191} As of backup 188, complete child process end code is present in this program. Confirmation that the end process code functions correctly with the quit command ('q'), as well as confirmation that the quit command ('q') will not cause immediate program closure in a later program re-run, have been achieved as of backup 189.
;				* {192} Program end testing with win and loss conditions, however, have not yet been tested as of backup 192. The win and loss condition quit processes will be tested with implementation of maze collision. Each of the win and loss exit processes will likely need a new screen to be printed before the game closes; thus, the win and loss condition exit processes cannot immediately direct the program code to the "quit" label; rather, the win and loss conditions must direct to respective areas of code to print win and loss screens respectively before the program accesses the quit label. 
;	* As of backup 83, parent and child functions have begun to be coded.
;	* As of backup 85, fork code has been added to main.
;	* As of backup 86, fileName and fileDescriptor variables have been added to SECTION .data to allow access to the input file.
;	* As of backup 87, the fileName variable's './bob.txt' has been changed to './inputFile.txt'
;	* main childProc code has been copied from forkAndFile.asm to this progam's main childProcess code as of backup 88.
;	* As of backup 89, LEN and inputBuffer code from forkAndFile's SECTION .bss have been copied to this program to run forkAndFile's original childProc code.
;	* As of backup 93, notes have been added to the parent process's top loop for the original four code lines used to display and move the python. Each note has been numbered with the code line's original placement.
;	* As of backup 95, code has been directly copied from forkAndFile.asm's parent process to this program's parent process. This unedited code will likely fail in this program if left unchanged.
;		* The parent process content from forkAndFile.asm has been encompassed by labels as of backup 97.
;	* From backup 103 (priorly 102 in backup 101's text) onward, comparison code has been begun for the parent process's responses to keyboard input.
;		* :: [NOTE]: The _adjustPython and _pause functions have been coded to read state change data from the direction and speed variables respectively. Each of the two functions copies the variables' data into the eax register. Ensure eax data is handled properly within, before, and after each of the two functions. Stack use may be needed to preserve the eax register as necessary.
;	* In backup 104, data was set aside for holding the child process's process ID. The child process ID will be used to end the child process when needed. The child's process ID was not saved yet, however.
;		* An attempt to save the child process's process ID was created in backup 107. As of backup 107, however, the attempt has not yet been tested.
;		* In backup 108, brackets were added around the child process ID variable when moving the ID from eax after the fork instruction, assuming the ID is an integer. Thee syntax and runtime effect have still not yet been tested, though.
;			* ([OK] {192}) In backup 131, the child process ID movement code line was found to cause a segmentation fault; the line was disabled in backup 130 for error checking. In backup 134, the code will be replaced by an alternate version without brackets to attempt to rectify the error.
;				* {192} Correction Successful: Prior to backup 192, the correction of "childProcess" to "childProcessID" in the child process ID movement line, as well as adddition of brackets around "ChildProcessID" in the same line rectified the error.
;		* In backup 109, the parent process was edited to change the python's motion with keyboard input, but the code is incomplete. _pause may need to be recoded for speed changes, or may simply benefit from recoding.
;			* :: Could the values for the _pause function be changed outside of _pause?
;	* As of backup 117 (now backup 111 due to a cppying error?), the "_time2sleep" duplicate pause code from forkAndFile.asm has been removed.
;	* As of backup 118, a "parent" jump call in the parent process has been corrected to a "parentProcess" jump call.
;	* As of backup 120, a "childProc" jump instruction in the child process has been corrected to a "childProcess" jump instruction.
;	* As of backup 122, leftover copied source code from forkAndFile.asm has been rempved from this program's parent process code, but the change's result has not yet been tested.
;	* As of backup 124, the parent process's original loop top code has been changed to jmp top to avert an error from a large jump. Presumably, as the python must continue moving until a win, loss, or quit condition occurs, the jmp top command may be safe, but as of backup 124, the change has not yet been tested.
;	* As of backup 136, the program's source code permits the python to change direction and speed via keyboard input. However, a "quit" keyboard command has not yet been fully coded. "Quit" command selection code exists in comment in the parent process, but the code does not yet redirect to a "quit" section, nor does a "quit label exist, nor is the "q" command yet recognized by the program asof backup 136.
;	* {139} When input is given to the program, the input appears near the python's then-current position. The program, as of backup 136, does not yet place the input cursor below where the maze would appear. Attempt to correct the cursor position will begin from backup 140 onward.
;		* {149} As of backup 148 or earlier, the cursor error has been corrected.
;	* {149} Information for placing the python's starting row has been found in structi.asm as of backup 149. From backup 150 onward, attempts will be made to place the python on the correct starting row and column, initially with the "default" incidental length of the python, but without presence of an actual maze.
;		* {151} The starting row of the python should be row 6 if the maze's first row is indexed at 0. If the maze's first row is indexed at 1 instead, the python should begin at row 7. the python will initially be placed on rows 0 and 1 during backup 152's (corrected from "151's" in backup 152) testing to determine the likely starting row.
;			* {153} The head of the python disappears briefly if the python turns southward from row 0. Further testing will be performed with backup 154 to determine if the same error occurs elsewhere, particularly in row 1. This error may be the same visual error priorly suspected, but not documented, with the python's motion.
;			* {154} The python at least began on the screen's topmost row when row 00 was tested as a starting row. Row 01 will be tested with backup 154.
;				* {155} The visual error of the python's head disappeaing ceases if the python is moved southward from a starting row of 01 instead of 00, and, as an added note, attempting to navigate the python to row 00 during runtime, moving the python westward in the suspected row 00, then turning the python southward produces the same visual bug. Additionally, the python still begins at the screen top if 01 is set as the starting row instead of 00; thus, from backup 155 onward, 07 will be chosen as the initial starting row for the python instead of row 06. The starting row may still be changed should further issues arise after maze printing is tested.
;	* {156} Information was found in notes for moving the cursor to row 26 once the python is printed; thus, unless an error occurs after maze printing, the moveCursor row setting will remain at row 26 as of backup 156.
;	* {157} In backup 158, an attempt will be made to correctly center the python, using the column placement (80 - python length) / 2 ({159} at the beginning of the parent function).
;		* {159} In backup 158, the program was found to be unable to directly use a slash ("/") for division with the particular column placement expression used. In backup 160, a shift right will be used with the expression's ax register-placed result instead to attempt division by 2.
;			* {160} As the particular division method used will cause bit loss, Dr. Allen will be asked if bit loss is acceptable for the assignment.
;				* {172} Dr. Allen has provided a response, stating that the bit loss is acceptable. Thus, the subtraction and division code will remain edited no further as of backup 172 unless additional problems arise.
;		* {161} An assembler error was found with the code line "-- mov     ax,80-pythonLen --" at the beginning of the parent process. Prior python backups will be checked to determine the nature of the assembler error.
;			* {162} The division symbol ("/") assembler error was present at earliest in backup 158, while an "invalid operand type" error with the code line "-- mov     ax,80-pythonLen --" appeared at earliestnin backup 160. Backup 157 has been found to assemble without assembler errors.
;				* {163} Backup 157 is able to successfully begin without apparent runtime errors. Backup 157's code will be checked to determineand rectify backup 160's expression issue.
;					* {165} Both "-- mov     ax,80-(pythonBody) --" and "-- mov     ax,80-(pythonBody) --" have been attempted unsuccessfully to center the python. Dr. Allen 's aid may be requested for determining the nature of the assembler error. While a response is awaited, "-- mov     ax,80-(pythonLen-pythonBody) --" will be used in combination with "-- shr    ax,1 --", reactivated from commented state in backup 165, to atempt to center the python within the maze. Should the centering attempt still be unsuccessful, Dr. Allen will be asked for aid.
;						* {166} Interestingly, the centering attempt combining the original "-- mov     ax,80-(pythonLen-pythonBody) --" and "-- shr    ax,1 --" appears to be successful, at least without the map's presence. For the time being, from backup 166 onward, Dr. Allen will not be contacted about the subtraction issue, at least in connection to Program 7 alone, unless any issue indeed arises after the mazes are printed, or else any other unforseen issues develop.
;	* {167} The python's default motion in SECTION .data has been set to west (direction is 'a') and 1 second delay (speed is '1') as of backup 167.
;	* {168} Testing of the SECTION .data values between backups 167 and 168 revealed that when the input file is empty at the program's opening, the python will default to the speed hard-coded in the SECTION .data speed variable, but if the SECTION .data direction variable is hard-coded to south motion ('s'), the python will default to moving westward. Presumably, the python will initially move westwar at the program's opening regardless of which direction is directly hard-coded into the direction variable.
;	* {174} During testing between backups 173 and 174, the python's body appeared to properly center upon the seventh row at both the minimum and maximum python lengths, rather than only the python's head centering in the seventh row as was the main concern. The python's column centering code, as of backup 174, appears to likely be correct, to be altered only if the python lacks proper centering in the mazes after maze printing.
;	* {176} In backup 175, the parent function's motion input comparison section was changed to use je instructions with the comparison instructions, though as on backup 175, the change is untested.
;		* {177} Syntax errors in the jump to endOfMotionChanges code lines were corrected, removing unneeded colons (":").
;		* {178} The comparison code changes made in backup 175 appear to be successful, though the exact bugs that the change may have removed or nwely introduced are unknown as of backup 178.
;	* {178 - Development pause} At the time of backup 178, midnight in the morning of December 12th was reached; thus, program development was paused for return home. At the time of the development's pause, the python's motion control, motion directionality, and motion speed appear to be complete. As for items that pertain to the python, only collision appears to remain, as well as perhaps unloading the python at the program's end, if the python is not "automatically" unloaded through the program's own development progress. Maze coding is to be commenced during December 12th for both maze printing and collisions of the python with the maze. After the maze coding completes, "quit" actions for wins, losses, and player-commanded quits may be coded into the program, taking care as to ensure the child process properly ends. After the quit code has been written, further code may be added to satisfy the bonus maze's requirements, including new data to handle a score counter, in addition to handling collisions with point-based items alongside the new win condition of ending the game once all dots have been consumed (perhaps this latter game-ending task could be done with a decrementing counter, reduced by one as the python consumes each dot, and ending the game once the counter reaches zero?). Additionally, before the program's primary version, before bonus content, is complete, at least one macro must be added to the source code, as, as of backup 178, no active macro exists yet within python.asm.
;	* {184} Information about the complete kill process code has been given by Dr. Allen; kill process code exits in getchar.asm. The code will be added to this program from backup 187 (formerly backup 186 prior to backup 186, and backup 185 in backup 184) onward.
;	* {185} The python now properly defaults to the SECTION .data specified starting direction as of backup 181, and a potential issue with the program immediately closing when reopened after a quit command last ended a game has also been rectified before the issue could be triggered in any source code version.
;	* {188} As of backup 188, possibly complete child process end code is present in this program from getchar.asm. The code will be tested in backup 188.
;		* {189} As of backup 189, the child process end code appears to function correctly with the quit command ('q').
;		* {190} As of backup 189, the program has also been confirmed to lack the quit session lingering input bug; the program reruns successfully even if a quit command ('q') was last used by the player to leave the program.
;	* {194} From advice from Dr. Allen, the changes to the seconds variable by inputs will be reworked to directly occur in the input process section of code.
;		* {194} [![WARNING]!] Potential Bug: The change to the input processing may cause unexpected changes to how the program handles python speed. Backup 194 will be established as a "safe" backup, pre-speed handle alteration. The program will likely be reverted to, or else compared with, backup 194 if any errors arise from the speed handle restructure.
;		* {195} With backup 195, alterations to the program's speed handling have begun.
;		* {196} With a backup beyond backup 196, macro use will be attmpted for changing the python's speed.
;		* {198} As of backup 197, seconds array alteration code has been copied to the input processing section of the parent function, replacing the jumps to alterTheSpeed. The alterTheSpeed label will likely be removed in backup 199.
;			* {199} The alterTheSpeed label and the label's held code have been removed from the program as of backup 199. Additionally, in backup 199, new jump to endOfMotionChanges code instructions have been added to the end of each speed change branch in the parent process's input processing section, and the _changeSpeed section has been commented out of the program as of backup 199.
;			* {200} The speed alteration code in the _pause function (including the label to the _pause function's main delay instruction, but not the delay instruction itself) has been commented out of the _pause function as of backup 200.
;		* {201} With backup 201, the restructured program will undergo testing to ensure no bugs appeared in python speed handling or elsewhere.
;			* {202} ([OK] {208}) Bug: The program, with speed initially set to '1' and seconds initially set to 1,0, sets the python to move west with a one second delay speed at each startup, but the program gives no visual response to any intended input other than the quit command ('q'), which still appears ton work properly. An issue may be occurring with the input processing, negating new speed and direction input.
;				* {204} The bug may have been caused by lacked use of the value comparison results in the parent process's input processing section. Code utilizing the comparison results will likely be added in backup 205 as an attempted repair.
;					* {206} In backup 205, new labels have been added to eight of the nine inputs of the parent process's input processing section. As of backup 205, only the quit input 'q' lacks a label. The label will be added in backup 206. Additionally, the parent process's speed input processing section has been recoded with new "jump not equal) (jne) conditional jumps to again use the input comparison code results. Similar form of comparison code is not yet active for the direction processing code, which uses the previous algorithm of jumping to a label, then to a separate function to change the direction variable.
;						* {207} The new comparison code handlers will be tested in backup 207.
;							* {208} As of backup 206, the input handler bug has been removed with the addition of comparison code handlers in the parent process's speed input processing.
;	* {203} A comment for processing keyboard input in the parent process has been changed away from the prior draft comment.
;	* {208} Restructure of the direction input algorithm will be begun at backup 210 or later (formerly backup 209 in backup 208), with backup 208 labeled as a "safe" post speed input algorithm change, pre-direction input algorithm change program version.
;	* {209} The _pause function's comment-disabled speed alteration code, including the inner function label to the top of the original _pause function instruction, as well as the _changeSpeed function's entirety have been removed from the program as of backup 209. The _changeDirection function's entirety may be removed from a later program version if the direction input restructure succeeds.
;	* {210} Direction change code has been transferred from the _changeDirection function to the parent process's direction input processing section as of backup 210. Both the alterTheDirection label's code section and the _changeDirection function have also been disabled via commenting as of backup 210.
;	* {211} After a check of _adjustPython's code in backup 211, none of _adjustPython's code will be disabled for the direction input restructure as of backup 211 unless additional errors arise. Testing of the direction input restructure will begin with backup 211.
;		* {212} The python appears to halt if an east ('d') input is given to the program, but inputs 'w,' 'a,' and 's' appear to function correctly. A problem may exist in the processing code for input 'd'. Other inputs will also be tested with backup 212 to determine the true problem.
;			* {212} Even after the python halts from 'd' input, the program appears to still succeed in writing new data to the input file, as well as in closig the child process if a Ctrl+C close command is sent. The issue appears to affect only the parent process, not the child process.
;				* {213} The input bug indeed only affects 'd' input; the problem may likely be in the parent process's input processing code for 'd', which was already planned to undergo possible change to remove a redundant jump. The input processing code for 'd' will be checked in backup 213.
;					* {214} An issue was found in the copied comparison handling code for transitioning from the inputS label section's code to the inputD label section's code. The inputS label's section held an erroneous loop back to inputS's own label if an 's' was not detected in eax by the program. The code has been changed to instruct the program to instead transition to the inputD label if an 's' is not present in eax at inputS's code section. The code change will be tested with backup 214.
;						* {216} As of backup 215, the input bug has been confirmed to be rectified with the change in the parent process's nput processing code for the inputS label to transition to the inputD label properly.
;	* {218} As of backup 217, the direction change algorithm restructure appears successful; thus, the _changeDirection function code and the parent process's adjustTheDirection function's code have been removed from the program as of backup 217.
;	* {219} A duplicate endOfMotionChanges jump at the end of the parent process's inputD label processing code has been marked with a comment as of backup 219. The code line may be removed in a final program version if no new code appears between the marked code line and the endOfMotionChanges label after the parent process's input processing code. Additionally, as of backup 219, a plan has been created to mark the program backup version that fully satisfies the original assignment requirements, but not the bonus requirements. If insufficient time remains, this marked program version's program development and debug comments will be removed to create a final program version (the process may take too long to begin before starting the bonus assignment content.)
;	* {220} Interestingly, in backup 219, the speed variable was found to have become unused as a result of the changes to the program; thus, removal of the speed variable's data will be tested in backup 221.
;		* {222} After the speed variable's removal, during program testing, the python's motion for speeds 2, 3, and 4 appeared to lose smoothness; owever, the smoothness loss may be from access of the assemble server both from an ssh from cobra and by wireless access via the personal HP laptop. The program will be re-tested with a Computer Science Building computer, likely in Lab 200, to test whether movement issues persist upon a computer with more direct access to the assemble server.
;			* {223} As of backup 222, no movement issues seem to occur with the speed variable's removal when the program is tested upon a Lab 200 computer directly accessing the assemble server. As of backup 223, the speed variable will remain removed unless a related issue arises later in the program's development.
;	* {224} As of backup 224, backup 223 has been marked as a "safe" post-input processing change, post-speed variable removal version of the program.
;	* {227} As of backup 226, the program has been deemed ready to progress to development of maze-related code, including maze printing and collision, but not yet bonus score record and score item collision code. As of backup 227, backup 226 will be marked as "python motion complete" (note the reference to "motion" excludes collision) to be used as a safe backup for return and comparison should any new program issues arise from backup 227 onward. Maze code development will likely begin in a backup after backup 227; in backup 228, either macro development will commence, or proper parameter passing will be added if Dr. Allen advises addition of parameter passing.
;	* {229B} The program has been reverted to backup 227 after backup 238, and a new B development branch has been begun from backup 228B, lasting until backup 238B. From backup 229B onward, attempt may be made to install at least one of Dr. Allen's macros into the program. Backup 227 remains a likely safe reversion point should the installation still fail.
;	* {231B} As of backup 231B, the reverted python.as has been re-tested, likely to have been reverted to a safe program version. Development will likely continue with backup 232B. ({233B} Backup 233B note: No macro development was begun in backup 232B.)
;	* {233B} Attempt to install the NormalTermination macro of macroDemo.asm will commence with backup 234B.
;		* {234B} Attempt to install the NormalTermination macro has begun with backup 234B. The macro code itself is now present, but not yet used, in this program.
;		* {235B} A use of the NormalTermination macro code from macroDemo.asm has been added to the program at backup 235B, the backup where the macro code will be tested. The normal termination code directly present in SECTION .text has been removed as of backup 235B for the purpose of testing.
;			* {236B} The NormalTermination macro use appears to succeed; program development will continue first into creating a macro for ending the child function, then into developing maze code.
;			* {238B} Development of a macro to end the child process has begin in backup 237B.
;	* {239} With backup 239, the use of branching B notation in backup numbers to denote branching has ended after establishing the branching from backup 228B onward.
;	* {243} As of backup 242, the source code has been changed to replace the original direct code for child process ending in SECTION .text with the EndChildProcess macro call.
;	* {246} As of backup 244, the program end macros installed to source code appear to work correctly. Maze code development will likely begin with backup 248 (formerly backup 247 in backup 246), with backup 246 marked as a safe "PythonMotionCompleteWithMacros" file.
;	* {247} Maze development will likely begin with printing the maze field from backup 248 onward.

; {251} Maze Development Begins (Backup 248 onward)

;	* {248} Maze code development has begun with backup 248, beginning with insertion of the initial maze (instead of the bonus maze) into the program's source code. Backup 248 will be labeled to indicate the beginning of maze development with the maze's presence in SECTION .data. A screenSize variable from the assignment instructions has also been copied into SECTION .data as of backup 248.
;	* {250} In backup 249, a comment has been placed in SECTION .text's main to indicate the location of code for printing the maze.
;	* {251} A macro for printing strings has been copied from macroDemo.asm in attempt to print the maze, but as of backup 251, no call has been made to the PrintString macro yet. A new marker has been added to the program log as well to denote the beginning of maze code development from backup 248.
;	* {253} In backup 252, a call was added to the PrintString macro to print the maze. The macro will be tested in backup 253.
;	* {255} In an error detected in backup 254 or earlier, the maze printing failed to begin at the screen's top. Dr. Allen advised clearing the screen via the program first, then setting the cursor to row 0, column 0 before maze printing begins. As the row 0 placement was found to be bugged during python placement testing row 01 may me used instead for the cursor's initial placement. In addition, to ensure that the maze placement code truly functions, the maze's cursor set code will be programmed and tested before clear screen code is installed.
;		* {257} A SetCursorPosition macro will be installed into the program in backup 258 from macroDemo.asm to assist with the cursor placement for the maze printing. The two other uses of cursor placement, placing the python's initial position and placing the input cursor below the maze, will also likely be recoded after the SetCursorPosition macro is successfully installed for maze printing.
;			* {258} As of backup 258, the SetCursorPosition macro from macroDemo.asm is now present in the program's source code, but the program does not yet call SetCursorPosition as of backup 258.
;				* {259} A new _setCursor function from macroDemo.asm will begin installation from macroDemo.asm in backup 260 to allow full use of macroDemo.asm's SetCursorPosition macro. Sections of this program's code involving cursor position changes will likely be changed to accommodate use of the _setCursor function at a later time.
;					* {260} The _setCursor function has been copied directly from macroDemo.asm into backup 260. As of backup 260, no code accommodations have yet been made to ensure the _setCursor function and SetCursorPosition macro are properly incorporated.
;						* {261} Attempts to further incorporate SetCursorPosition and _setCursor into the program will begin with backup 262.
;							* {263} A SetCursorPosition call attempt has been placed before the maze's printing call in SECTION .text's main section code. The SetCursorPosition call attempt will be tested with backup 263.
;								* {265} When an attempt was made to assemble backup 263, the below assembler errors appeared, seeming to address only the _setCursor function:
;python.asm:659: error: symbol `row' undefined
;python.asm:660: error: symbol `row' undefined
;python.asm:668: error: symbol `col' undefined
;python.asm:669: error: symbol `col' undefined
;python.asm:674: error: symbol `pos' undefined
;									* {267} In backup 266, the above assembler errors have been placed in comments at the errors' matching locations. The coments will have new asterisks beside them in backup 267.
;										* {269} New code for pos, row, and col parameters from macroDemo.asm have been copied to attempt permitting use of the _setCursor function. The new code will be tested in backup 269.
;											* {270} The paramater installation from macroDemo.asm appears to have completed the SetCursorPosition macro's operation. From a backup after 273 (formerly backup 273 in backup 272, and 271 in backup 270) onward, other code for cursor position placement will be rewritten to use the SetCursorPosition macro.
;	* {272} The error comments in the _setCursor function have been removed as of backup 272.
;	* {273} Beginning from backup 274, the program's python centering code will be tested with different python lengths.
;		* {274} Testing with python length of 2 revealed that the python was noticeably placed excessively left when the program began. Testing and image comparisons will be performed to determine the proper edits to center the python.
;			* {275} In backup 275, the maze printing's initial column placement was set to 1 to attempt to determine change or error removal. Python centering code testing will continue with backup 275.
;				* {276} After changing the beginning of the maze's printing locations to column 1 in backup 275, no observable difference has been noticed in the python's centering. Python centering testing will continue woth backup 276; offset error values are still being determined as of backup 276.
;					* {277} Dr. Allen has confirmed that as of backup 276, the python has indeed been properly centered when beginning the maze. The initial maze's own offset from center may have contributed to illusion of the python being off-center; the use of a space at the end of the python's body also may have furthered the off-center appearance.
;						* {278} As of backup 277, no additional code will be written in attempt to change the python's centering.
;	* {280} In backup 281, the moveCursor instruction's use will have been replaced by SetCursorPosition use.
;		* {281} To ensure adequate struct use for the assignment, the plan to replace moveCursor with SetCursorPosition instruction use has been cancelled as of backup 281.
;	* {283} With testing of backup 281 before creating backup 282, the python appeared to be able to move as expected, barring collision. The python also possesses ability to "erase" any visible characters from the maze if the python's path overlaps visible maze elements (e.g., the maze's walls). No additional code will need to be written for the python to "remove" maze items from the maze, particularly for the bonus maze, but the bonus maze will still require a method of score count as the python consumes dots.
;	* {283} [*NOTE* - BONUS information] For the bonus maze, a decrementing value has been recalled from the course's teachings. A decrementing counter may be usable to guarantee the game will end in a win state once every dot has been consumed, but, as warning, the program must still be able to internally track which dots have and have not yet been consumed; thus, in program memory alone (not in the maze shown to the player during gameplay), writing spaces atop the dots consumed may be ideal to regard each dot as "eaten".
;	* {285} From a backup after 288 (formerly backup 286 in backup 285) onward, collision coding will be installed into the program.
;	* {286} Before collision code is installed, clear screen code will be installed for use by the program beore printing the maze. The installation will likely begin in backup 287 ({287} actually begun in backup 288}, with macro data for screen clearing retrieved from macroDemo.asm.
;	* {287} As of backup 288, the ClearTheString macro will have been copied from macroDemo.asm into this program, in addition to a cls variable also being copied from macroDemo.asm as of the same backup to allow the ClearTheString macro to properly function.
;		* {288} The ClearTheScreen macro and the cls variable from macroDemo.asm have been copied into this program as a macro and into SECTION .data respectively as of backup 288, but no call has been made to ClearTheScreen in the program yet as of backup 288.
;			* {290} As of backup 289, a ClearTheScreen call has been written into this program's SECTION .data main section code before the maze's print code. The ClearTheScreen call will be tested with backup 290.
;				* {291} As of backup 290, the ClearTheScreen call has been confirmed to operate properly.
;	* {295} As of backup 295, backup 294 will be marked as "safe" pre-collision code.
;	* {297} As of backup 296, collision has been decided to be handled first via function for upcoming development.
;	* {298} A _collisionCheck function label has been created, with accompanying pusha, popa, and ret instructions, as of backup 298.
;	* {301} A _collisionCheck call has been placed before _displayPython's call in the parent function's "top:" label loop as of backup 300, but the _collisionCheck function does not yet properly operate, only pushing, then popping, all registers before returning the code line beyond the _collisionCheck function call as of backup 300.
;	* {304} From backup 305 onward, several code construction attempts will be made in the _collisionCheck function to attempt to retrieve the python head's row and column data for collision checks.
;		* {305} As of backup 305, python head row and column data retrieval attempts have begun by commenting the _collisionCheck function with algorithm information.
;			* {307} As of backup 306, progress to python head data access has been decided to initiate with use of the python's tail or tail space coordinates for collisio testing. Code to attempt python tail access may be retrieved from structi.asm.
;				* {309} As of backup 308, nonfunctional code has been copied from structi.asm's _adjustMessage function to this program's _collisionCheck function in attempt to access the python's tail coordinates. The code will likely be edited in later backups.
;					* {311} As of backup 310, the copied _adjustMessage code is being recoded to replace structi.asm label names with this program's label names.
;	* {331} As of backup 331, attempt will be made to access the python head with mov ebx, python in _collisionCheck from backup 332 onward. REVERT TO BACKUP 331 IF THE HEAD DATA ACCESS ATTEMPT FAILS. Backup 331 will also be labeled with "ReversionPointPreHeadAccessAttempt1."
;		* {332} With backup 332, the first attempt at python head data access has begun.
;	* {355} As of backup 354, a working method of storing the python head's row and column ASCII coordinates appears to have been found, but while the program runs during backup 354's testing, direct testing of the stored data from (presumably) the python head has not yet occurred, nor is backup 354 capable of directly testing the data presumably stored from the python head without gdb debugger use. As of backup 335, the next code installation planned is a converter to convert double digit ASCII values to equivalent int data, using subtraction of the ASCII character 0 and use of multiplication by ten as appropriate.
;		* {356} Backup 354 may also be used as a point of return and reference in regard to ensuring the program properly retrieved the python head's row and column ASCII code. Backup 354 was distinguished with a labelled title at the time of backup 354's saving.
;	* {360} The _collisionCheck function may be later renamed in accordance to the function's actual action, unless the function's functionality is later changed. This idea of renaming the function arose in a backup prior to backup 360, and the same is true of the function's functionality changing; the two possibilities have been recorded in the program log as of backup 360.
;	* {361} As of backup 361, coding of a _toInt function has begun. No function calls the _toInt function yet as of backup 361. The function is intended to be used for the collision check process, converting the python head's ASCII data form coordinates to int data through ax register passing.
;	* {373} Starting with backup 374, an attempt will be made to access ones ASCII data in the ax register of _toInt by adding 1 to ax's address ([ax+1] or similar).
;		* {375} In backup 374, assembly attempt led to report of [ax + 1] in _toInt having a report of no specified size; thus, as guess, BYTE now tentatively exists beside [ax + 1} in _toInt as of backup 375.
;			* {377} Attempting to assemble backup 376 with the BYTE [ax + 1] present caused an assembler error; thus, the affected code section in _toInt has been changed to "-- ax + 1 --" (without brackets or an adjacent "BYTE" code) to re-attempt assembly.
;				* {378} Attempt to use ax + 1 in _toInt still failed. Another code instruction may allow proper ones digit access.
;	* {383} In _toInt, could added variable use be installed to allow correct access to the ones and tens ASCII digits? For backup 384 onward, an assumption will be made, presuming that a word was properly extracted for each the row and column ASCII coordinates of the python head.
;	* {410} During edits to _toInt, backup 409 successfully compiled, and has been labeled in file name as a successfully assembling program between backups 409 and 410.
;	* {427} Program backup 426 assembles successfully, and has been renamed with a name to indicate successful assembly.
;	* {429} Pause point: 11:00 PM, December 12th - The last program section being written was _toInt - consideration was being given for where _toInt should be called. _toInt still requires proper use by copying the obtained ASCII coordinates for the python's head from the respective python head ASCII value variables to the ASCII value holder variable. A toIntResult variable must also be created to hold the _toInt result, or else perhaps the toInt result could be held in an ax-related register. When program development continues, focus upon developing _toInt, then continue development of collision-related code.
;	* {435} As of backup 434, the _collisionCheck function present in backup 434 has been decided to be renamed to _pythonConversionPreparation as of backup 436. A different function will be used for true collision detection once the python's ASCII coordinates have been converted to integers.
;	* {441} With arrangement finished for potential testing, but not yet tested, in backup 440, a new code section has been added to the parent function as per Dr. Allen's recommendations to attempt to convert the python's head's ASCII coordinates to int data to prepare for true collision detection.
;		* {442} As of backup 441, the new code section appears to assemble properly. Backup 441 will be labeled as an assembler safe program version.
;	* {445} As of backup 444, two new variables, pythonHeadIntRow and pythonHeadIntColumn, have been created as reserved word data in SECTION .bss to hold the results of the ASCII coordinate conversion.
;	* {446} Beginning with backup 446, a new, proper _collisionCheck function is being coded, beginning with a call to the function in the parent process. A later backup will receive a variable for holding the comparison result.
; * {450} As of backup 448, a new plan has been created for holding collision tile data. The data, being a single character, may be stored perfectly within a byte-sized register and a byte-sized variable. The variable collidedTile, a 1 byte reserved word variable, has been created as of backup 449 or earlier to store the tile that the python's head collided.
;		* {451} Additionally, as of backup 450, a new function, _collisionResponse, has been considered for collision reactions if the parent process itself cannot create collision response. As with the input processing code, however, collision response code may be better placed during the parent process. Also, as an additional note, the collision reaction should complete before the python is redisplayed.
;	* {455} As of backup 454 or earlier, a new _collisionCheck function has begun coding as function code.
;		* {462} As of backup 461, a new access to the screen variable's data has been at least partially written.
;			* {465} As of backup 464, in  _collisionCheck, the data transfer for the maze's tile data has been decided to be held through byte register al into collidedTile. ({467} In this comment, "collidedTile has been corrected from collisionTile in backup 467.)
;				* {466} al was directly placed into _collisionCheck's source code as of backup 464
;				* {469} As of backup 467, or near backup 467, _collisionCheck has been coded to transfer tile data from al to the collidedTile variable, though the code remains untested.
;	* {470} As of backup 470, a code line has been marked by comment in the parent process for where to begin writing collision reaction code. Collision reaction code will likely begin development from backup 471 onward.
;		* {472} As of backup 471, plans have been changed to rectify a syntax error, likely a variable use error, in the _collisionCheck function from backup 473 onward.
;	* {475} As of backup 474, program testing is ready withb the variable to register substitution in the _collisionCheck function
;		* {476} The substitution
;			mov bl, [pythonHeadIntRow]
;			mov bh, [bythonHeadIntColumn]
;			mov al, [screen + bl * 81 + bh]
;			does not assemble in _collisionCheck. ({478} This comment has been rewritten with line separation as of backup 478.)
;	* {481} As of backup 480, a typo has been corrected in _collisionCheck from [bythonHeadIntColumn] to [pythonHeadIntColumn]
;		* {482} Correction of the typo did not remove the assembler error. Multiple combinations will likely be attempted from backup 483 onward.
;			* {483B} The program version has been reverted from backup 483 to backup 482 to better log code corrections to the _collisionCheck function's code syntax. B-labeled branching will begin and end with backup 483B, while actual code correction attempts will persist and be saved from backup 434 onward, changed from the backup 483-recorded plan of using both backups 483B and 484 for saving code corrections in _collisionCheck.
;	* {487} Backup 486 successfully assembled with the code mov al, [screen] in the _collisionCheck function. Development of correct code will likely continue based upon this code line version. As an added note, mov bl, [pythonHeadIntRow] and mov bh, [pythonHeadIntColumn] appeared to successfully assemble in backup 482, though the code line mov al, [screen] + bl * 81 + bh] hadn an assembler error reported in the same backup...
;		* {490} As of backup 489, Program 6 - ASCII Art code has been considered as reference for screen variable access.
;			* {491} asciiArt.asm has been viewed for reference code information. Line 2431 of asciiArt.asm has been considered, adding a complete numeric value to the artArrayOffset variable. The screen variable may also need to be added to a register that holds the offset value... or is this mistaken thinking? Actually, maybe this would not be a mistake, as adding the variable screen, without brackets, to a register may create an address access in the register...
;				* {492} This coding plan will likely be installed in backup 496 ({493, 495} Priorly backup 494 in backup 493, and backup 493 in backup 492.)
;	* {523} As of backup 524, the program code development will be continued with assumption of the _collisionCheck function operating as intended. Backup 523's file will be named as a pre-assumed _collisionCheck operation backup version. As the code in _collisionCheck appears extremely near correct code, continued development of the program beyond _collisionCheck may be a relatively safe option. Backup 523 will remain as a state of reference and restoration if necessary.
;	* {541} As of backup 540, win screen and loss screen labels have begun to be coded in SECTION .data.
;	* {546} As of backup 545, the primary maze has been copied to the win screen and loss screen data.
;	* {552} As of backup 551, the win and loss screens have been created, but not yet set for printing.
;	* {558} As of backup 557, the win and loss screens have been fully coded, including printing ability.
;	* {560} With backup 559, the program logic for the main program appears to be near complete, still needing access to collision code and proper collision tile comparison for win and loss conditions only, at least seemingly... Backup 560 will be saved titled as a near safe near complete primary program pre debug comment removal version, with bonus maze coding likely beginning with backup 561 or later. Branching can be done from backup 560 or near backup 560 for submission of a primary code version, but python file versions from backup 561 onward will likely be titled with "Bonus" to help further distinguish the file versions.
;	* {569} In backup 568, the dotEatCheck code began to be written in the parent process.
;	* {572} As of backup 571, a dotsRemaining variable has begun to be coded to the program.
;	* {575} In backup 573, dotsRemaining's presence in SECTION .data was established.
;	* {577} As of backup 576, the win condition has been recoded to dot consumption
;	* {579} Coding of _eraseDot function has begun.
;	* {597} A new scorePrintout variable exists as of backup 596
;	* {611} The _collisionCheck line after screen variable offset mathematics in _collisionCheck must be refined with Dr. Allen's assistance. Go into the _collisionCheck function near that function's final code line to view the code line that failed to assemble.

; * Bug List
;	* ([OK] {192}) A logic error has been found, caught at backup 44 at latest and rectified in hard-coding by backup 77 at latest:
;		* Error: The program must constantly maintain the python's direction and speed using two sections of memory. Backup 44 and earlier used only one section of memory shared for both direction and speed, losing one data item as another item was changed.
;		* Partial Correction (as of backup 55): The program now determines python direction from a variable called "direction" stored in memory.
;		* Partial Correction (as of backup 77): The program has direction and speed variables that may be hard-coded to change the python's speed, but the variables must still be properly accessed by the parent function.
;		* {150} Partial Correction (as of backup 148 or earlier): The program can properly maintain the python's direction and speed, but if the input file is not empty, the program will default the python's motion to the first input character found in the input file at program startup.
;			* {192} Complete correction: Prior to backup 192, the python now defaults to the default direction specified in SECTION .data's direction variable, now written to the input file at program startup. The bug correction method also prevents the python's speed from defaulting to data lingering in the input file; however, an oddity may still occur if the default speeds in the SECTION .data speed variable and the SECTION .data seconds array conflict. In backup 193, a repair to the speed and seconds variables' potential conflict issue may be attempted by moving the seconds variable to SECTION .bss, reserving data for the seconds array instead of directly setting the seconds array's data in SECTION .data.
;	* [OK] A bug has been corrected from backup 55 onward, caught at backup 52:
;		* Bug: The program does not change the python's movement direction to the direction variable's direction.
;		* Correction: The call to the direction variable in _adjustPython to move direction's data to eax has been changed to use brackets, allowing correct data access.
;	* [OK] The python's speed was not correctly changed by the speed variable. The bug was caught at backup 69 and repaired as of backup 72.
;		* Correction: The 1's for half second, third second, and fourth second speed changes have been corrected to 0's.
;	* [(Amended Below)] A logic error has been found as of backup 109. The _pause function was incorrectly planned to be called both during inputless python motion and upon input entry, doubling the _pause function's delay time at the time of each input.
;		* Possible Correction [(Amended Below)]: The code in _pause used to alter the delay length will be moved to a new code section in backup 114 (priorly backup 113 in backup 112).
;	* [OK] A different logic error has been found as of backup 113, replacing the suspected error above. The program was incorrectly planned to call _adjustMessage and _pause to directly change python direction and speed, respectively.
;		* Possible Correction: Two new functions will be made exclusively to handle speed variable changes and direction variable changes, leaving _adjustMessage and _pause's code as of backup 113 unchanged.
;			* Correction Succeeded: The correction allows the python to change direction and speed with keyboard input as of backup 136.
;			* As of backup 115, an attempt has been created for changing the python's speed and direcion variables with functions, but as of backup 115, the new functions have not yet been tested.
;	* [OK] Confirmed Bug (Potential until backup 139): The cursor may not move below the maze during the parent process's run. The possible bug was recorded in backup 126.
;		* {139} Confirmed Bug: The bug has been confirmed as of backup 136's behavior and recorded in backup 139.
;		* {139} Possible correction: As of backup 140, cursor placement code will be run during the parent process's python movement loop; the cursor's placement will be set after each movement of the python. If the cursor position is necessary for the python's head movement, however, the attempted solution may change the python's motion without debug to the solution code.
;			* {140} Corrections Attempted: The moveCursor values have been set to row 81 and column 00 (changed from row 20 and column 00) to attempt to move the input cursor below the maze. The moveCursor print instruction has also been placed before the _pause call in the parent process's python movement loop. The original instance of the moveCursor print instruction was disabled by commenting in backup 140
;				* {141} Correction Failed: The moveCursor correction failed to move the cursor as desired. The cursor position appeared to remain near the python's tail as the program ran.
;					* {142} Correction Error Found: The row value set for moveCursor may be excessive. The mazes' row numbers will be checked to change the moveCursor row value for backup 143.
;						* {143} Recorrection Attempted: The number of rows of the original maze was found to be 25. moveCursor's row value has been set to 26 to reattempt the correction. If successful, the value may be later reduced to 25 if needed to place the cursor rest adjacent to the maze.
;							* {144} Partial Success: The cursor appears to rest at the desired row, but the python's beginning location appears to have changed. Backup 143's python will be compared with prior pythons to determine if the starting position changed unintentionally.
;								* {145} Complete Success: The python's starting location was not changed by the moveCursor change; however, the python does begin near the extreme right of an 80 width screen. The python's starting position will later need to be changed to center as desired within the mazes.
;	* [OK] Segmentaton fault: A segmentation fault has been detected in backup 126. The segmentation fault is detectable as early as backup 124. Backup 123 exists prior to the shortn jump correction in the parent process.
;		* As of backup 131, the code line " -- mov [childProcess], eax -- " in main has been found to cause a segmentation fault. As of backup 130, the code line has been disabled, allowing the code to run, but leaving child process a.outs active after the program is ended with  Ctrl + C.
;			* As of backup 134, an alternate child process ID movement code line has been written to attempt to rectify the error. The line may be tested at earliest in backup 134.
;		* In backup 135, the child process ID variable was found to have been written incorrectly in the original disabled code line. Backup 136 (priorly backup 135 in backup 135) will be tested to determine if the variable miswrite was the true issue.
;			* Checking backup 126 revealed that the childProcessID variable was indeed miswritten as "childProcess" in the childProcessID movement code line. Backup 136 will be tested to determine if the miswriting caused the segmentation fault error.
;				* Correction Succeeded: The segmentation fault error was caused by mistyping "childProcessID" as "childProcess" in the child process ID movement line; the issue has been rectfied as of backup 136, and the issue's correction has been recorded partly in backup 137 and further in backup 138. However, whether the child process ID itself has been properly saved to the childProcessID variable in a usable state has not yet been tested as of backup 136.
;	* [OK] {146} Bug; {179} Repair Planned (see {179} sub-note below) (Formerly was {172} Repair Tentative (see {172} sub-note below)): Suspected in at latest backup 145 and confirmed in backup 146, a logic error exists that causes the program's direction information (and presumably speed information, alternatively) to default to the last data input into inputFile.txt. While the source code itself is technically working properly, the program, as of backup 145, always begins under the assumption that inputFile.txt is empty, causing the python to unexpectedly change direction from earlier play sessions. The unexpected behavior may disorient a player.
;		* {147} Further testing of the bug revealed that the python at least begins the program facing leftward, but makes no motion before the program changes the python's direction with inputFile.txt. The bug may not require direct repair; thus, Dr. Allen will be contacted about the bug. Until a response is received, the bug may or may not be fixed, and this program will likely be tested with inputFile.txt manually emptied before opening the program, if possible.
;		* {148} Additional testing revealed that the python does appear to move before a one second delay passes in the first movement completed when the input file's input character is 1. The other three speeds show no evident peculiarity, but the difference between the initial motion and the set input speeds may be too short to be discerned.
;			* {172} The seconds default of "-- seconds: dd     0,250000000 --" was thought to have been responsible for the timing oddity that occurred with a 1 in the input file, but strangely, setting the speed variable's value to a '1' default in SECTION .data averts the shorter timing. While leaving the seconds value at "-- seconds: dd     0,250000000 --" was considered for testing purposes, the value will instead be set to "-- seconds: dd     1,0 --" as of backup 173 (priorly backup 172 in backup 172) to follow Dr. Allen's permission of student selection of the python's starting conditions. The bugs may be corrected at another time if time permits. The original leftover input bug will also be in tentative repair, also rectified if time permits.
;				* {192} Possible correction: In backup 193, the seconds variable will have been moved to SECTION .bss as reserved data in attempt to streamline the speed default code in the program.
;		* {179} Possible Correction: Dr. Allen suggested writing an 'a' (west) instruction to the input file with the program itself as the program begins. The repair would avert an additional issue from the bug: if a quit command ('q') was the last command entered into the input file, if the program is rerun without first emptying the input file, the program would immediately close. The repair will be written in backup 181 (Formerly backup 180 in backup 179).
;			* {180} The code to correct the input file contents likely exists in the child function's writing to the input file, as suggested by Dr. Allen.
;			* {181} In the input file write code copied from the child process to before the fork instruction, inputBuffer was swapped with the direction variable, without brackets, in attempt to unify the default starting directionwith the input file's held instruction. The repair will be tested with backup 181.
;				* {183} Correction Succeeded: The program now properly defaults to the SECTION .data specified starting direction as of backup 181.
;	* [OK] {169} Bug; {172}: Repair Tentative (see {172} sub-note below): The python does not default to the direction hard-coded in SECTION .data even if the input file was blank when the program began. Instead, the python always defaults to west. While defaulting to west was intended for the python, the python's method of defaulting to west is incorrect.
;		* {170} The python, as of backup 169, likely defaults to west movement as a result of "left" direction code being the first directional code to appear in _adjustPython. Dr. Allen has been sent a message between backups 169 and 170 to ask whether to correct the bug, but attempts to correct the bug will likely occur before maze presence is implemented into this program.
;		* {170} A hint of how to correct the bug may rest in backup 169's speed control algorithm, as the python successfully defaulted to SECTION .data's hard-coded speeds.
;		* {172} Dr. Allen has returned a message permitting student selection in how the python begins. The message was sent in direct response to an inquiry about this sub-note's associated bug; thus, repair of this sub-note's linked bug will be tentative, performed should time allow the repair.
;		* {171} A possible cause of the oversight may exist in the "_change..." function call section of the parent function. While the code section uses cmpare instructions, no conditional jumps appear to use those comparisons' results within or adjaccent to the comparison area, an aspect recognized at backup 170 and recorded in backup 171, though the code was intended to utilize the comparison results with conditional results far earlier in the code's development. Conditional jump code will be added to the aforementioned comparison section in backup 175 (priorly backup 173 during backup 173, and perhaps earlier) to attempt to rectify the error.
;		* {172} Dr. Allen has returned a message permitting student selection in how the python begins. The initial direction bug for setting the default direction may be corrected if time permits, but repair of the bug is tentative as of backup 172.
;		* {190} As of backup 181, the python now does properly default to the direction default specified in SECTION .data.
;	* ! {358-359} ? Potential Bug?: A possible bug may exist before the parent process's call to _toASCII as a result of changing the use of the ax register before the _toAscii code runs; however, upon closer inspection, no bug may actually exist, as python-related code is still being moved into the ax register before _toAscii is called. The potential bug was identified in backup 357, and was also denoted with a comment beside the _toAscii call in the same backup. Further program development may reveal whether a bug is truly present.

;
; * Miscellaneous Notes:
;	* A bug list section exists in Program Notes as of backup 56.

; Christian Winds
; CSC 322 Fall 2018
; Program 7: Happy Python
; This program runs a game until the player wins or collides with a wall.
; Friday, December 14, 2018

; A macro for clearing the screen
%macro ClearTheScreen 0
        pusha
        mov     eax,4
        mov     ebx,1
        mov     ecx,cls
        mov     edx,4
        int     80h
        popa
%endmacro

; A macro for printing strings
%macro PrintString 2
        pusha
        mov     eax,4
        mov     ebx,1
        mov     ecx,%1
        mov     edx,[%2]
        int     80h
        popa
%endmacro

; A macro for setting the cursor's position
%macro SetCursorPosition 2
        push    eax
        mov     ah,%1
        mov     al,%2
        call    _setCursor
        pop     eax
%endmacro

; A macro for ending the child process
%macro EndChildProcess 1
	mov     eax,37
        mov     ebx,[%1]
        mov     ecx,9  ; kill signal
        int     80h
%endmacro

; A macro for ending the program
%macro NormalTermination 0
        mov     eax,1
        mov     ebx,0
        int     80h
%endmacro

; Create a struct to handle the python's body characters
STRUC pStruct
        .esc    RESB 2  ; space for <esc>[
        .row:   RESB 2  ; two digit number (characters)
        .semi   RESB 1  ; space for ;
        .col:   RESB 2  ; two digit number (characters)
        .H      RESB 1  ; space for the H
        .char:  RESB 1  ; space for THE character
        .size:
ENDSTRUC

SECTION .data
pythonBody:	db	'@> '; Holds the python's body
pythonLen:	dd	$-pythonBody; Holds the python's length
direction:	dd	'a' ; Maintains the python's direction

dotsEaten: dd	0

fileName:       db      './inputFile.txt',0
fileDescriptor: dd      0
scorePrintout:	db	'00'
scorePrintoutSize:	dd $-scorePrintout

; Clear Screen control characters
cls:    db      1bh, '[2J'

; Set cursor position control characters for the _setCursor function
pos:    db      1bh, '['
row:    db      '00'
        db      ';'
col:    db      '00'
        db      'H'

; Hold the program's maze
screen: db      "********************************************************************************",0ah
        db      "*.           .             *              .            *           .          .*",0ah
        db      "*      *************       *        *************      *       *********       *",0ah
        db      "*            .             *              .            *           .           *",0ah
        db      "*                          *                           *                       *",0ah
        db      "*                          *                           *                       *",0ah
        db      "*                                                                              *",0ah
        db      "*           **************************        ***********************          *",0ah
        db      "*                                * ........      *                             *",0ah
        db      "*                                * .   ***********                             *",0ah
        db      "*                          *     * ...........   *     *                       *",0ah
        db      "*                .         *     **********  .   *     *        .              *",0ah
        db      "*                          *     * ...........   *     *                       *",0ah
        db      "*                          *     *      **********     *                       *",0ah
        db      "*                          *                           *                       *",0ah
        db      "*                                                                              *",0ah
        db      "*           ***   ***   ***   ***   ***   ***   ***   ***   ***   ***          *",0ah
        db      "*                                                                              *",0ah
        db      "*            *     *     *     *     *  .  *     *     *     *     *           *",0ah
        db      "*               *     *     *     *  *******  *     *     *     *              *",0ah
        db      "*            *  .  *     *     *     * 000 *     *     *     *  .  *           *",0ah
        db      "*               *     *  .  *     *  *******  *     *  .  *     *              *",0ah
        db      "*            *     *     *     *     *  .  *     *     *     *     *           *",0ah
        db      "*.              *     *     *     *     *     *     *     *     *             .*",0ah
        db      "********************************************************************************",0ah
screenSize:     dd $-screen ; Holds the number of characters in the maze

lossScreen: db      "********************************************************************************",0ah
            db      "*                                                                              *",0ah
            db      "*                                                                              *",0ah
            db      "*                                                                              *",0ah
            db      "*                                                                              *",0ah
            db      "*                                                                              *",0ah
            db      "*                                                                              *",0ah
            db      "*                                                                              *",0ah
            db      "*                                                                              *",0ah
            db      "*                                                                              *",0ah
            db      "*                                                                              *",0ah
            db      "*                                                                              *",0ah
            db      "*                                Try Again...                                  *",0ah
            db      "*                                                                              *",0ah
            db      "*                                                                              *",0ah
            db      "*                                                                              *",0ah
            db      "*                                                                              *",0ah
            db      "*                                                                              *",0ah
            db      "*                                                                              *",0ah
            db      "*                                                                              *",0ah
            db      "*                                                                              *",0ah
            db      "*                                                                              *",0ah
            db      "*                                                                              *",0ah
            db      "*                                                                              *",0ah
            db      "********************************************************************************",0ah
lossScreenSize:	 dd $-lossScreen ; Holds the number of characters in the loss screen

winScreen: db      "********************************************************************************",0ah
           db      "*                                                                              *",0ah
           db      "*                                                                              *",0ah
           db      "*                                                                              *",0ah
           db      "*                                                                              *",0ah
           db      "*                                                                              *",0ah
           db      "*                                                                              *",0ah
           db      "*                                                                              *",0ah
           db      "*                                                                              *",0ah
           db      "*                                                                              *",0ah
           db      "*                                                                              *",0ah
           db      "*                                                                              *",0ah
           db      "*                               Congratulations!                               *",0ah
           db      "*                                                                              *",0ah
           db      "*                                                                              *",0ah
           db      "*                                                                              *",0ah
           db      "*                                                                              *",0ah
           db      "*                                                                              *",0ah
           db      "*                                                                              *",0ah
           db      "*                                                                              *",0ah
           db      "*                                                                              *",0ah
           db      "*                                                                              *",0ah
           db      "*                                                                              *",0ah
           db      "*                                                                              *",0ah
           db      "********************************************************************************",0ah
winScreenSize:   dd $-winScreen ; Holds the number of characters in the win screen


; Set a delay time for movement
seconds: dd     1,0  ;;;  seconds, nanoseconds

; Move the cursor below the maze
moveCursor:     ISTRUC pStruct
                AT pStruct.esc,  db 1bh,'['
                AT pStruct.row,  db '26'
                AT pStruct.semi, db ';'
                AT pStruct.col,  db '00'
                AT pStruct.H,    db 'H'
                AT pStruct.char, db ' '
                IEND


SECTION .bss
python:        RESB pStruct.size*(pythonLen-pythonBody)
childProcessID:	RESD 1

pythonHeadAsciiRow:	RESW 1 ; {346} This code line began to be added from backup 346 for use with storing the python's ASCII head row coordinate.
pythonHeadAsciiColumn:	RESW 1 ; {346} This code line began to be added from backup 346 for use with storing the python's ASCII head column coordinate.
heldAsciiValue:		RESW 1 ; Used to temporarily store ASCII number data from pythonHeadAsciiRow and  pythonHeadAsciiColumn
toIntResult:		RESW 1 ; Used to hold the integer conversion result of _toInt
pythonHeadIntRow:	RESW 1 ; Used to hold the integer version of the python's head's row coordinate
pythonHeadIntColumn:	RESW 1 ; Used to hold the integer version of the python's head's column coordinate
collidedTile:		RESB 1 ; * {448} Every character is one byte. Character data can be stored in a byte register and in a byte variable.

LEN     equ     1024
inputBuffer     RESB LEN

SECTION .text
global _main
_main:

; Prepare the input file for beginning input reading
        ;; Open a file for communication
        mov     eax,5
        mov     ebx,fileName
        mov     ecx,101h
        mov     edx,777h
        int     80h

        mov     [fileDescriptor],eax

        ;;; write  something to inputFile.txt
        mov     eax,4
        mov     ebx,[fileDescriptor]
        mov     ecx,direction
        mov     edx,1
        int     80h

        ;;;  close the file
        mov     eax,6
        mov     ebx,[fileDescriptor]
        int     80h

	; Clear the screen to prepare the maze's placement.
	ClearTheScreen

	; Print the maze
	SetCursorPosition 1, 1 
	PrintString screen, screenSize
	

        ;;;;   FORK 2 PROCS
        mov     eax,2
        int     80h

        ;;;;;;;;;;;;;;;;;;;;;;  Creates two processes, same code,
        ;;;;;;;;;;;;;;;;;;;;;;   but returns zero to new proc, and the procID of child to parent
        cmp     eax,0
        je      childProcess
	; Save the child process's process ID.
	mov [childProcessID], eax ; * (Temporarily disabled as of backup 130; re-enabled with "childProcessID" instead of "childProcess" in backup 136 at latest; {186} Confirmed as correct code as of backup 186)


parentProcess:
	;;;;;;;;; LOAD python from pythonBody
        	mov     ax,80-(pythonLen-pythonBody) ;;;; Column on screen for first char when right justified (Original code: "-- mov     ax,80-(pythonLen-pythonBody) --") ({164} Python Center Attempt A: "-- mov     ax,80-(pythonBody) --") ({164} Python Center Attempt B: "-- mov     ax,80-(pythonBody) --") ({165} "Python Center Attempts" attempted pprior to backup 165)
		shr	ax,1 ; Divides the maze width and python length difference by 2 ; * (Deactivated prior to backup 165, reactivated in backup 165)
	        mov     ebx,python               ;;;; pointer in python array of structs
	        mov     ecx,[pythonLen]             ;;;; loop count of characters in string
	        mov     edx,pythonBody            ;;;; pointer into the original python
; * [NOTE]  The content from parentProcess above loadTop should run only once.
	loadTop:
	        mov     BYTE [ebx],1bh ; * python ebx
	        mov     BYTE [ebx+1],'['
	        mov     WORD [ebx+2],"07"  ;;;; ROW might need to swap these ; This sets the python's starting row.
	        mov     BYTE [ebx+4],';'
	        push    eax                ;;;; Save this for next loop
	        call    _toAscii           ;;;  Pass in int in ax, returns two ascii digits in ax ; {357} ! Potential bug? The ax register's use was changed in the code that runs before this line.
	        mov     WORD [ebx+5],ax
	        pop     eax                ;;;; Restore the screen col number
	        mov     BYTE [ebx+7],'H'
	        push    ecx
	        mov     cl,[edx]           ;;;; Get next char from string
	        mov     [ebx+8],cl
	        pop     ecx
	        add     ebx,pStruct.size
	        inc     edx
	        inc     ax
	        loop loadTop

	; Demonstrate function calls which uses an array of structs
	        mov     ecx,80-(pythonLen-pythonBody)

	; Handle the movement of the python.
	top:	; Determine if the python has collided with any items
		call	_pythonConversionPreparation ; * {436} Renamed from _collisionCheck as of backup 436.
		push edx
		mov dx, [pythonHeadAsciiRow]
		call	_toInt
		mov dx, [toIntResult]
		mov [pythonHeadIntRow], dx
		mov dx, [pythonHeadAsciiColumn]
		call	_toInt
		mov dx, [toIntResult]
		mov [pythonHeadIntColumn], dx
		pop edx
		call	_collisionCheck
		; * {470} Write collision comparison data here.
		; Determine if the player lost the game.
		lossCheck:
		cmp BYTE [collidedTile], '*' ; * {533} As of backup 532, this code line has not yet been tested.
		jne dotEatCheck
		; Print the loss screen.
	        SetCursorPosition 1, 1
	        PrintString lossScreen, lossScreenSize
		jmp quit
		; Determine if the player ate a dot
		dotEatCheck:
		cmp BYTE [collidedTile], '.'
		jne noLossNorWin
		inc DWORD [dotsEaten] ; * {618} Fixed Error
		push eax
		mov eax, [dotsEaten] ; * {600} This may need brackets, likely around dotsEaten.
		; Print the score
		call _toAscii
		mov [scorePrintout], ax ; * {622} Fixed Error
		SetCursorPosition 21, 41 ; {610} As of backup 610, these coordinates have been untested.
		PrintString scorePrintout, scorePrintoutSize ; * {608} This code line may hold an error.
		pop eax
		call _eraseDot
		; Determine if the player won the game.
		winCheck:
		cmp DWORD [dotsEaten], 50 ; * {620} Fixed Error
		jne noLossNorWin
		; Print the win screen.
	        SetCursorPosition 1, 1
	        PrintString winScreen, winScreenSize
		jmp quit
		jne noLossNorWin

		noLossNorWin:
		call    _displayPython ; * Of original python display. Line 1

		; Move cursor below the maze
	        mov     eax,4
	        mov     ebx,1
	        mov     ecx,moveCursor
	        mov     edx,9
	        int     80h

		; Pause the python's movement.
	        call    _pause ; * Of original python display. Line 2

; * [Note]: Below: Parent process content from forkAndFile.asm.
        ;; Open a file for communication
        mov     eax,5
        mov     ebx,fileName
        mov     ecx,0  ; read only
        mov     edx,777h  ;;; guess at 777o
        int     80h

        mov     [fileDescriptor],eax

        ;;; read  something from inputFile.txt
        mov     eax,3
        mov     ebx,[fileDescriptor]
        mov     ecx,inputBuffer
        mov     edx,2
        int     80h

        ;;;  close the file
        mov     eax,6
        mov     ebx,[fileDescriptor]
        int     80h

        ; Process the keyboard input. * [Perform actions with the keyboard input. ({203} As of backup 203, the comment for keyboard input processing has been changed.)] (Original text: print message)
	push eax
	mov eax, [inputBuffer]
	inputQ:
	cmp eax, 'q' ; * {187} This code was activated in backup 187, formerly disabled.
	je quit ; * {187} This code label and the "-- cmp eax, 'q' --" comparison code were activated in backup 187.
	; Determine whether to change the python's speed
	input1:
	cmp eax, '1'
	jne input2
        mov DWORD [seconds], 1
        mov DWORD [seconds + 4], 0
	jmp endOfMotionChanges
	input2:
	cmp eax, '2'
	jne input3
        mov DWORD [seconds], 0
        mov DWORD [seconds + 4], 500000000
	jmp endOfMotionChanges
	input3:
	cmp eax, '3'
	jne input4
        mov DWORD [seconds], 0
        mov DWORD [seconds + 4], 333333333
	jmp endOfMotionChanges
	input4:
	cmp eax, '4'
	jne inputW
        mov DWORD [seconds], 0
        mov DWORD [seconds + 4], 250000000
	jmp endOfMotionChanges
	; Determine whether to change the python's direction
	inputW:
	cmp eax, 'w'
	jne inputA
	mov [direction], eax
	jmp endOfMotionChanges
	inputA:
	cmp eax, 'a'
        jne inputS
        mov [direction], eax
        jmp endOfMotionChanges
	inputS:
	cmp eax, 's'
        jne inputD
        mov [direction], eax
        jmp endOfMotionChanges
	inputD:
	cmp eax, 'd'
        jne endOfMotionChanges
        mov [direction], eax
        jmp endOfMotionChanges ; * {219} Remove this code line if no added code appears between this code line and the endOfMotionChanges label in a final program version.

; [Note]: Above: Parent process content from forkAndFile.asm

	endOfMotionChanges:

	        call    _adjustPython ; * Of original python display. Line 3
        	jmp    top ; * Of original python display. Line 4 (Edited to change "loop" to "jmp")

	; Move cursor below the maze ; * (This iteration was disabled in backup 140)
	;        mov     eax,4
	;       mov     ebx,1
	;        mov     ecx,moveCursor
	;        mov     edx,9
	;        int     80h

; Read input from the keyboard.
childProcess:
        ; read  keypress
        mov     eax,3 ;sys read
        mov     ebx,0   ;stdin
        mov     ecx,inputBuffer
        mov     edx,LEN
        int     80h


        ;; Open a file for communication
        mov     eax,5
        mov     ebx,fileName
        mov     ecx,101h
        mov     edx,777h
        int     80h

        mov     [fileDescriptor],eax

        ;;; write  something to  bob.txt
        mov     eax,4
        mov     ebx,[fileDescriptor]
        mov     ecx,inputBuffer
        mov     edx,1
        int     80h

        ;;;  close the file
        mov     eax,6
        mov     ebx,[fileDescriptor]
        int     80h

        jmp childProcess

quit:
	; End the child process.
	EndChildProcess childProcessID

	; Normal termination code
	NormalTermination

; A function for converting a two digit int to an ASCII string
_toAscii:
        push    ebx

        mov     bl,10
        div     bl      ;; puts ax/10 in al, remainder in ah
        add     ah,'0'
        add     al,'0'

        pop     ebx
        ret

; A function for converting a two digit, whole number ASCII string number to an int through parameter passing with the ax register. ; * {411} As a new plan as of backup 411, the value result will be passed from this function in another variable, toIntResult. ; * {428} Where should _toInt be called?
_toInt:
	push eax ; * {419} This code line was added in backup 419
	push ebx
	push ecx
	push edx
	mov ebx, heldAsciiValue; * {390} Code line added in backup 390 ; * {401} As of backup 400 or earlier, a heldAsciiValue variable must be created in SECTION .data or SECTION .bss, likely as a reserved byte data section of a certain size. ; {404} What data should heldAsciiValue be initialized with, or else should hold? ; {407} heldAsciiValue should likely begin as a reserved word data space, holding either ASCII row data or ASCII column data transferred from pythonHeadAsciiRow or pythonHeadAsciiColumn before this function begins.
	; Convert the ones ASCII digit from ASCII to an int
;	sub ax + 1, '0' ; * {367} Note: If ax's data is accessed by individual byte, will the data retrieved still be correct despite little endian use? Finding a seemingly random collision during testing may reveal an error in this function, in the original retrieval of the python head's data, or in each of the two mentioned code sections. ; {371} Reference code possibly usable for finding the ones and tens digits may have been found in structi.asm's _adjustMessage funtion, within and near the "carry:" label. ; {380} This code line has been disabled in backup 380.
	; * {381} The number of bytes reserved for both column ASCII data and row ASCII data in structi.asm is two bytes, matching a data word's length. Perhaps this data size could be used for a word register or word variable?
	sub BYTE [ebx + 1], '0' ; * {391, 394} Code line fully changed from "-- BYTE [heldAsciiValue + 1] --" in backup 394, with some edits between backups 391 and 394; {392} Comment asterisk added in backup 392
	; Move the converted ones value to the cl register. ; * {413} A byte's maximum value appears to be 256, so use of ah and al ({414} or other byte registers) to store values during _toInt may be safe. ; {416} Changes are being made to the byte register used in this code line as of backup 415 onward, first changed from al to cl in backup 415.
	xor ecx, ecx
	mov cl, BYTE [ebx + 1]

	; Convert the tens ASCII digit from ASCII to an int
;	sub ax, '0' ; * {368-369} An error may occur in tens digit access as a result of little endian use. If such an error occurs, would the error be rectified by swapping how the ones and tens digits' data are accessed, either swapping in ax alone, or perhaps in some other manner? ; {380} This code line has been disabled in backup 380.

	sub BYTE [ebx], '0' ; * {391, 394} Code line fully changed from "-- BYTE [heldAsciiValue] --" in backup 394, with some edits between backups 391 and 394; {392} Comment asterisk added in backup 392 ; {397} Correction of the ### notation to 394 for the backup record was performed in backup 396.
	; Move the converted tens value to the ah register.
	mov ah, BYTE [ebx]
	; Multiply the converted tens value by ten. ; * {400} As of backup 400, multiplation code is necessary.
	mov al, 10
	mul ah ; * {417} The multiplication result is stored in ax. ; {424} This line was corrected to only use one argument in backup 423

	; Create a sum of the converted tens and ones integer values.
	add ax, cx

	mov [toIntResult], ax
	
	pop edx
	pop ecx
	pop ebx
	pop eax  ; * {419} This code line was added in backup 419
	ret

; A function for moving the python
_adjustPython:
        pusha

        mov     ecx,[pythonLen]
        dec     ecx
        mov     ebx,python+((pythonLen-pythonBody)-1)*pStruct.size

_apTop: mov     dx,[ebx - pStruct.size + pStruct.row]   ;; get row above
        mov     [ebx + pStruct.row],dx                  ;; copy to this row

        mov     dx,[ebx - pStruct.size + pStruct.col]   ;; get col above
        mov     [ebx + pStruct.col],dx                  ;; copy to this col

        sub     ebx,pStruct.size
        loop    _apTop

; Determine which direction the python should move
	mov eax, [direction]
	cmp eax, 'w'
	je up
	cmp eax, 'a'
	je left
	cmp eax, 's'
	je down
	cmp eax, 'd'
	je right

; Move the python head left
left:
;;;;;;  Adjust first character to move one space to the left
        cmp     BYTE [ebx + pStruct.col + 1],'0'
        je      decreaseColCarry
        dec     BYTE [ebx + pStruct.col + 1]            ;; move first char to left
        jmp     adjustEnd
; Move the python head right
right:
;;;;;;  Adjust first character to move one space to the right
        cmp     BYTE [ebx + pStruct.col + 1],'9'
        je      increaseColCarry
        inc     BYTE [ebx + pStruct.col + 1]            ;; move first char to right	
	jmp adjustEnd
; Move the python head upward
up:
;;;;;;  Adjust first character to move one space upward
        cmp     BYTE [ebx + pStruct.row + 1],'0'
        je      decreaseRowCarry
        dec     BYTE [ebx + pStruct.row + 1]            ;; move first char upward
        jmp     adjustEnd
; Move the python head downward
down:
;;;;;;  Adjust first character to move one space downward
        cmp     BYTE [ebx + pStruct.row + 1],'9'
        je      increaseRowCarry
        inc     BYTE [ebx + pStruct.row + 1]            ;; move first char downward
        jmp adjustEnd

; Reduce the column coordinate to the next value
decreaseColCarry:
        dec     BYTE [ebx + pStruct.col]
        mov     BYTE [ebx + pStruct.col + 1],'9'
	jmp adjustEnd
; Increase the column coordinate to the next value
increaseColCarry:
        inc     BYTE [ebx + pStruct.col]
        mov     BYTE [ebx + pStruct.col + 1],'0'
        jmp adjustEnd
; Reduce the row coordinate to the next value
decreaseRowCarry:
        dec     BYTE [ebx + pStruct.row]
        mov     BYTE [ebx + pStruct.row + 1],'9'
        jmp adjustEnd
; Increase the row coordinate to the next value
increaseRowCarry:
        inc     BYTE [ebx + pStruct.row]
        mov     BYTE [ebx + pStruct.row + 1],'0'
        jmp adjustEnd

adjustEnd:
        popa
        ret

; A function for printing python's array structs
_displayPython:
        pusha
        mov     ebx,python
        mov     ecx,[pythonLen]

_dmTop: push    ecx
        push    ebx
        mov     eax,4  ; system print
        mov     ecx,ebx ; points to string to print
        mov     ebx,1   ; standard out
        mov     edx,9   ; num chars to print
        int     80h

        pop     ebx
        add     ebx,pStruct.size
        pop     ecx
        loop    _dmTop
        popa
        ret

_pythonConversionPreparation: ; * {436} Renamed from _conversionCheck as of backup 436
	pusha
	; Row-related data access from structi.asm. ; * ({315-316} Comment changed from python tail row access as of backups 315 to 316.)
;        mov     ecx,[pythonLen] ; * {352} This code line was disabled in backup 352.
;        dec     ecx ; * {352} This code line was disabled in backup 352.
        mov     ebx,python ; * {329} The label "message" in this line was swapped with the label "python" as of backup 328 or earlier. ; {332} In backup 332, this code was changed from backup 331's "-- mov     ebx,python+((pythonLen-pythonBody)-1)*pStruct.size --" to "-- mov     ebx,python --".

;_amTop: mov     dx,[ebx - pStruct.size + pStruct.row]   ;; get row above ; * {314} Commented out as of backup 314.
;        mov     [ebx + pStruct.row],dx                  ;; copy to this row ; * {319} This line suggests row access is active. ; {350} This code line was disabled in backup 350.
	; Access the python's head's row data ; * {321} This code section is to be changed to python head access in a final program version. {323} This comment line was corrected from "column" to "row" in backup 323. ; {336} A change was made in the comment from "tail" to "head's" in backup 336.
	mov	dx, [ebx + pStruct.row]
	; Store the python's head's row data
	mov	[pythonHeadAsciiRow], dx
	; Column-related data access from structi.asm. ; * ({315} Comment changed from python tail column access in backup 315.)
;        mov     dx,[ebx - pStruct.size + pStruct.col]   ;; get col above ; * {318} Disabled in backup 318.
;        mov     [ebx + pStruct.col],dx                  ;; copy to this col ; * {319} This line suggests column access is active. ; {351} This code line was disabled in backup 351.
	; Access the python's head's column data ; {324} This code section is to be changed to python head access in a final program version. Additionally, this comment's "column" mention has been corrected from "row" as of backup 324. ; {339} This comment has been edited to change "tail" to "head's" in backup 339.
	mov	dx, [ebx + pStruct.col]
	; Store the python head's column data
	mov	[pythonHeadAsciiColumn], dx

;        sub     ebx,pStruct.size ; * {319} This code line has been deactivated as of backup 319; the line is likely uneeded for this program's intended actions.

	popa
	ret

; A function to determine the content of the tile the python collided
_collisionCheck: ; * {524} This function does not yet fully operate as of backup 523, but the code appears near assembly ability, and the program logic appears at least near correct. Dr. Allen's assistance has been requested for moving this function toward complete operation.
	pusha
	; mov bl, [pythonHeadIntRow] ; * {484} This code attempt has been disabled for archival as of backup 484.
;	mov bh, [pythonHeadIntColumn] ; * {484} This code attempt has been disabled for archival as of backup 484.
;	mov al, [screen + bl * 81 + bh]; * {456} Array style access of the variable screen, using offset of (row * 81) + column ; {471} An error was detected here, likely related to variable use. ; * {484} This code attempt has been disabled for archival as of backup 484.
;	mov al, [screen]; {486} Backup 486 attempt ; {488} Assembly attempt successful in backup 486, success recorded in program log in backup 487 ; * {493} Disabled in backup 493 to allow for additional code testing
	; * {494} Backup 494 coding attempt, derived from asciiArt.asm (Program 6 Part 1 File) ; * {505} Backup 503 of this code assembles successfully. Backup 503 has been labeled as successfully assembling code. ; * {507} Backup 506 of this code also successfully assembles, and will be labeled as successfully assembling code in file title.
	xor eax, eax
	xor ebx, ebx
	; Calculate the offset to use for the screen variable.
	add bl, [pythonHeadIntRow]
	mov al, 81
	mul bl

	add ax, [pythonHeadIntColumn]

	add eax, screen

	; * {509} Try accessing the first byte of eax to retrieve data.
	
	mov cl, BYTE [eax] ; * {513-514} The code line "-- mov [collidedTile], BYTE [eax] --" from backup 512 fails to assemble ({514} The words "to assemble" were added in backup 514.) ; * {515} The code line "-- mov collidedTile, BYTE [eax] --" from backup 515 fails to assemble. ; * {521} The code "-- mov collidedTile, BYTE eax --" from backup 520 or earlier fails to assemble.
	mov [collidedTile], cl
	popa
	ret

; A function to remove a dot from internal maze data.
_eraseDot:
	pusha
	xor eax, eax
        xor ebx, ebx
        ; Calculate the offset to use for the screen variable.
        add bl, [pythonHeadIntRow]
        mov al, 81
        mul bl

        add ax, [pythonHeadIntColumn]

        add eax, screen

        ; * {509} Try accessing the first byte of eax to retrieve data.
	; Print a space over the eaten dot.
        mov BYTE [eax], ' ' ; * {586} Correct this code if necessary.; {588} This code may not need correction.
	popa
	ret

; A function to briefly sleep
_pause:
        pusha
        mov     eax,162
        mov     ebx,seconds
        mov     ecx,0
        int     80h
        popa
        ret

;. _setcursor expects AH = row, AL = col
_setCursor:
        pusha
;;; save original to get col later
        push    eax
;;;;;; process row
        shr     ax,8    ;; shift row to right
        mov     bl,10
        div     bl      ;; puts ax/10 in al, remainder in ah
        add     ah,'0'
        add     al,'0'
        mov     BYTE [row],al 
        mov     BYTE [row+1],ah
;;;; process col
        pop     eax     ;; restore original parms
        and     ax,0FFh ;; erase row, leave col
        mov     bl,10
        div     bl      ;; puts ax/10 in al, remainder in ah
        add     ah,'0'
        add     al,'0'
        mov     BYTE [col],al
        mov     BYTE [col+1],ah

        ;;;;; now print the set cursor codes
        mov     eax,4
        mov     ebx,1
        mov     ecx,pos
        mov     edx,8
        int     80h

        popa
        ret

