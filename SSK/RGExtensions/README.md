
SSK RGExtensions
============
SSKCorona RGExtensions extends the funtionality of these core Lua/Corona libraries: io, math, string, table, and transition.


Basic Usage
-------------------------

##### Copy ssk folder into your project
Download this library and copy the ssk folder into your project's root directory.

##### Require the code
```lua
require "ssk.RGExtensions"
```

IO Extensions
-------------------------
```lua
io.exists( fileName [ , base  ] ) - Returns true or false
io.readFile( fileName [ , base ] ) - Returns string containing file contents.
io.writeFile( dataToWrite, fileName [ , base ] ) - Writes contents of 'dataToWrite' string/number to file.
io.appendFile( dataToWrite, fileName[ , base ] ) - Appends contents of 'dataToWrite' string/number to file.  Creates file if not present.
io.readFileTable( fileName[ , base ] ) - Returns table where each entry represents a single line (NL separated) in the file.

Note: 'base' defaults to system.DocumentsDirectory.
```

Math Extensions
-------------------------
```lua
math.pointInRect = function( pointX, pointY, left, top, width, height ) - Return 'true' if <pointX, pointY> is in the rectangle specified by left, top, width, height.
math.calculateWrapPoint( objectToWrap, wrapRectangle ) - Calculate the point objectToWrap should be placed to wrap from one edge of a rectantle to the opposite side, using the center of the rectange to decide the wrap vector.
math.fastfib(n) - Calculate fibbonaci out to nth place (with caching for speedup)
math.PascalsTriangle_row(t)  - Calculate fibbonaci out to nth place (with caching for speedup)
math.PascalsTriangle(n) - Calculate Pascal's triangle to 'n' rows and return as a sequence
math.PascalsTriangle_lastRow(n) - - Calculate Pascal's triangle to 'n' rows and return last row only.
math.haversine_dist( lat1, lng1, lat2, lng2, R ) - Calculate the distance from one (GPS) decimal lat-long position to another.
```

String Extensions
-------------------------
```lua
string:split( tok ) - Splits token (tok) separated string into integer indexed table.

string:getWord( index ) - Gets indexed word from string, where words are separated by a single space (' ').
string:getWordCount( ) - Counts words in a string, where words are separated by a single space (' ').
string:getWords( index, endindex ) - Gets indexed words from string, starting at index and ending at endindex or end of line if not specified.  
string:setWord( index , replace ) - Replaces indexed word in string with replace, where words are separated by a single space (' ').

string:getField( index ) - Gets indexed field from string, where fields are separated by a single TAB ('\t').
string:getFieldCount( ) - Counts fields in a string, where fields are separated by a single TAB ('\t').
string:getFields( index [, endIndex ] ) - Gets indexed fields from string, starting at index and ending at endindex or end of line if not specified.  
string:setField( index , replace ) - Replaces indexed field in string with replace, where fields are separated by a single TAB ('\t').

string:getRecord( index ) - Gets indexed record from string, where records are separated by a single NEWLINE ('\n').
string:getRecordCount( ) - Counts records in a string, where records are separated by a single NEWLINE ('\n').
string:getRecords( index [, endIndex ] ) - Gets indexed records from string, starting at index and ending at endindex or end of line if not specified.  
string:setRecord( index , replace ) - Replaces indexed record in string with replace, where records are separated by a single NEWLINE ('\n').

string:spaces2underbars( ) - Replaces all instances of spaces with underbars.
string:underbars2spaces( ) - Replaces all instances of underbars with spaces.

string:printf( ... ) - Replicates C-language printf().

string:lpad( len, char ) - Places padding on left side of a string, such that the new string is at least len characters long.
string:rpad( len, char ) - Places padding on right side of a string, such that the new string is at least len characters long.
```

Table Extensions
-------------------------
```lua
table.save( theTable, fileName [, base ] ) - Saves table to file (Uses JSON library as intermediary)
table.load( fileName [, base ] ) - Loads table from file (Uses JSON library as intermediary)

table.dump( theTable [, padding ] ) - Dumps indexes and values inside single-level table (for debug)
table.dump2( theTable [, padding ] ) - Dumps indexes and values inside single-level table (for debug) (Alphabetized output.)
table.print_r( theTable ) - Dumps indexes and values inside multi-level table (for debug)

table.shuffle( t ) - Randomizes the order of a numerically indexed (non-sparse) table. Alternative to randomizeTable().
table.combineUnique( ... ) - Combines n tables into a single table containing only unique members from each source table.
table.combineUnique_i( ... ) - Combines n tables into a single table containing only unique members from each source table.

table.shallowCopy( src [ , dst ]) - Copies single-level tables; handles non-integer indexes; does not copy metatable
table.deepCopy( src [ , dst ]) - Copies multi-level tables; handles non-integer indexes; does not copy metatable
table.deepStripCopy( src [ , dst ]) - Copies multi-level tables, but strips out metatable(s) and ...
```

Transition Extensions
-------------------------
```lua
transition.fromtocolor(obj, colorFrom, colorTo, time, delay, ease) - Transition color of any display object (including text objects) from one color to another using standard transition easings.
```


Short and Sweet License 
--------------------------
1. You MAY use anything you find in SSKCorona to:
  * make applications for free or for profit ($).
  * make games for free or for profit ($).  
  
2. You MAY NOT:
  * sell or distribute SSKCorona or the sampler as your own work
  * sell or distribute SSKCorona as part of a book, starter kit, etc.

3. It would be nice if everyone who uses SSK were to give me credit, but I understand that may not always be possible.  So, if you can please give a shout out like: "Made with SSKCorona, by Roaming Gamer, LLC.", super, if not, darn...  Also, if you want to link back to my site that would be awesome too:   http://www.roaminggamer.com/




