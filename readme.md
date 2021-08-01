# Apple IIGS GS/OS Utility Library

This is a library of code I build back in the late 80's, early 90's when I was build my application EZBackup (for which I'll make the code available on GitHub when it's ready).

The "EZ" comes from the name of the company I operated under at the time, EZ-Soft.

This library builds on a lot of functionality provided by Apple in the Toolkit in an attempt to make some things a lot easier to do.

It was all written in ORCA Pascal with some ORCA/M assembler to support where needed.  It was originally developed with an older version of ORCA Pascal, however this code now compiles and seems to work with ORCA Pascal 2.0 as provided on the OPUS II collection available via: [OPUS II at Juiced.GS](https://juiced.gs/vendor/byteworks/)

## Line Endings
The text and source files in this repository originally used CR line endings, as usual for Apple II text files, but they have been converted to use LF line endings because that is the format expected by Git. If you wish to move them to a real or emulated Apple II and build them there, you will need to convert them back to CR line endings.

If you wish, you can configure Git to perform line ending conversions as files are checked in and out of the Git repository. With this configuration, the files in your local working copy will contain CR line endings suitable for use on an Apple II. To set this up, perform the following steps in your local copy of the Git repository (these should be done when your working copy has no uncommitted changes):

1. Add the following lines at the end of the `.git/config` file:
```
[filter "crtext"]
	clean = LC_CTYPE=C tr \\\\r \\\\n
	smudge = LC_CTYPE=C tr \\\\n \\\\r
```

2. Add the following line to the `.git/info/attributes` file, creating it if necessary:
```
* filter=crtext
```

3. Run the following commands to convert the existing files in your working copy:
```
rm .git/index
git checkout HEAD -- .
```

Alternatively, you can keep the LF line endings in your working copy of the Git repository, but convert them when you copy the files to an Apple II. There are various tools to do this.  One option is `udl`, which is [available][udl] both as a IIGS shell utility and as C code that can be built and used on modern systems.

Another option, if you are using the [GSPlus emulator](https://apple2.gs/plus/) is to host your local repository in a directory that is visible on both your host computer, and the emulator via the excellent [Host FST](https://github.com/ksherlock/host-fst).

[udl]: http://ftp.gno.org/pub/apple2/gs.specific/gno/file.convert/udl.114.shk

## File Types
In addition to converting the line endings, you will also have to set the files to the appropriate file types before building on a IIGS.

So, once you have the files from the repository on your IIGS (or emulator), within the ORCA/M shell, execute the following commands:

    filetype makefile src
    filetype clean src 6

## Dependencies
EZLib, being an ORCA/Pascal library of code depends of course on the Tool.Interface provided with ORCA/Pascal.  Additionally, as EZLib was being tuned and updated on GitHub, some minor changes to the Tool.Interface code were needed in ORCA/Pascal.

To this end, a pull request was created and subsequently merged into the [ORCA/Pascal](https://github.com/byteworksinc/ORCA-Pascal) repository on GitHub.

Before you try to build and use EZLib, it is recommended that you take the latest Tool.Interface code from GitHub, and rebuild it using the supplied "Build" script.

## Building
To build the library, you will need the ORCA/M environment present, and you will need the "MK" tool, also available [here on GitHub](https://github.com/pkclsoft/MK).

With the ezlib repo downloaded and in place, and the MK tool built and installed, building the library is as simple as:

    mk

If all goes well, the library will be built and created as obj/ezlib, and three test applications will be created; ctest, testctl, and testtrans.

## Installing
Once the library is built, if you want to use it, the easiest thing to do is copy it and the compiled interface files to the ORCA 13/  prefix where all of the other libraries are.  To do this just use the included script:

    updatelib

Now, when you're working on your own application using ezlib, make sure that libPrefix is set to 13/ezlibdefs when you want your code to see the interface files.

e.g.

    Unit MyUnit;

    interface

    Uses Common, QuickDrawII, GSOS, ControlMgr, WindowMgr, MenuMgr;

    {$ libprefix '13/ezlibdefs' }
    USES EZConst, EZMisc, EZControls;

## Library Content Summary
### EZALERTS.UNIT
#### EZMessageBox
This function creates a small dialog box on the screen that is created just large enough to contain a string of characters supplied in the Msg parameter.  This dialog is centered on the screen. The function returns the grafport pointer to the application, so that it may dispose of the dialog when it is ready. This is a useful way of displaying those 'Please wait...' type messages.

#### ProdosError
Produces an alert window that displays a message describing an error, along with the hexadecimal representation of the GS/OS error code.  This function ALWAYS returns TRUE.

### EZCMDLINE.UNIT
#### getWord
Will extract and return the Word in the input line beginning at the character pointed to by 'start'.

#### switchPresent
Returns a boolean value indicating whether the specified switch is present in the command line.

#### deleteWord
Delete's the Word begiining at the character specified by 'start' from the input line.

#### deleteSwitch
Deletes the specified switch from the command line.

#### getSwitchValue
For a switch that also has a parameter, this procedure will return the value of the parameter, and will then delete the switch and it's parameter from the command line.

#### UserAborted
Does a shell call to determine whether the user has pressed command-period, and returns true if so.

### EZCONST.UNIT
This unit contains a number of constants for GS/OS that have not been supplied by APW or ByteWorks.  They are used a lot by the other units.

### EZCONTROLS.UNIT
This unit contains a suite of calls that relate to extended controls. They have been written such that an application need not worry about control specifics such as bits in flags that need to be set.  In order to make an applications code read better, and to reduce the amount of work needed to manipulate the extended controls, several routines within this unit supply mechanisms that allow the application to divorce itself almost completely from things such as control handles.

### EZCRYPT.UNIT
This unit contains a number of routines used for encrypting a range of memory, and decrypting the same.                                         
                                                                         
This unit provides a rudimentary mechanism for encrypting a set of bytes using a specified keyword.  It was originally developed as part of a license key mechanism for EZBackup (hence the EZCreateSerialNumber and EZSerialNumberOk methods.

### EZDATES.UNIT
This unit contains a number of routines for converting the various Apple date formats from one to another.

A lot of this was written prior to me knowing about the ConvSeconds toolkit call.

That said, whilst debugging the MK tool, I've updated the code a bit to use ConvSeconds internally, and also to provide a way to represent the time in seconds since Jan 1, 1970 so that it fits in an ORCA Pascal signed longing.
                                     
### EZDEBUG.UNIT
This unit contains a number of definitions for use with GSBug.  

That said, I really don't know how these are used, or how they work anymore.

### EZDISK.UNIT
#### ValidatePathName
This function takes a GS/OS pathname as input, and  is through the ExpandPath call in order to determine it's validity, and to  convert all separators to the colon, in order to be more friendly to other  file systems. It returns the completed string in OutPath, and will convert  the string to uppercase if the Upper parameter is set to TRUE. 

***NOTE***. If the input pathname is not a FULL pathname, then a separator is placed at it's start to turn it into a FULL pathname. In other words  DON'T use this routine if you want a partial pathname to be returned  as it WON'T. 

#### MountVolume
As the name suggests, this function places a dialog on the screen, asking the user to mount the specified volume. It may  be supplied a full pathname, or simply a volume name, as it first calls ValidatePathName to force the separators to be colons, and then strips off  all but the volume name before requesting the user to mount it.

This function returns FALSE if the volume was mounted successfully, or  TRUE if the user elected to cancel the operation.
NOTE. This function also returns TRUE if it had trouble when validating the input pathname.

#### EZExistFile
This function may be used to determine whether the specified file exists in the current system. It returns TRUE if the file is found, and FALSE if not.

#### EZLoadFTypeFiles
This function will load the two file type information files (found in the icons directory on the boot volume) into memory, allocating space for them. It returns a a pointer which must be passed back to the other like routines, so that they may locate the two file type information lists. 

#### EZDisposeFTypeFiles
The pointer to the two file type information files is passed into this procedure, so that it may dispose of  the memory they occupy. 

#### EZFileType
This function will take the supplied parameters, and will scan  the memory based file type information lists for a matching entry. When one is found, the function returns a pointer to a  pascal string containing a description of the file.

#### EZGetDeviceList
This function will search the device list, for any that  match the specified mask and device type, and that are online, placing any matches in a List Manager structure, the address of which is passed in the first parameter.

#### EZGetVolumeList
This function will search the device list, for any that  match the specified mask and device type, and that are online, placing any matches in a List Manager structure, the address of which is passed in the first parameter.

#### EZGetDeviceTypeList
This function will search the device list, for any that match the specified mask and device type, and that are online, placing any matches in a List Manager structure, the address of which is passed in the first parameter.

#### EZDeviceIcon
This function takes as an input, the ID number of any GSOS  device, and will return an icon number for use with the EZ  file/device type icons.

#### EZTranslateName
Will take a filename as input, and the file system ID of a destination file system. The routine will then attempt  to convert the input filename into a format compatible with the specified file system, allowing the user to edit  the filename, or to tell the application to skip the file  A true/false result is also returned indicating whether  the user elected to skip the file or not. 

#### EZGetFileSystem
This routine will retrieve the file system ID of the specified volume. Note that the application may supply a full pathname as the volume name, as the routine strips of everything except the volume name itself.

#### EZCopyFile
This function will copy the source file to the destination  file.If the destination file already exists, then it is deleted without prompting. If any error occurs, then the copy  process is aborted, and an alert is displayed. The return  value indicates whether the copy process completed properly. 

### EZLINEEDIT.UNIT
This unit contains all calls specific to lineEdit extended controls.  They are set up so that it is not necessary to have the handle of the control, rather all is needed is the item number of the control.  These routines do all the rest.

#### setlineEditText
This procedure will insert the specified text into an extended lineEdit control.

#### getlineEditText
This procedure obtains the current value of an extended lineEdit control.

### EZLIST.UNIT
This unit contains a suite of calls that relate to Lists in particular which allow the easy manipulation of the list controls provided by the Control Manager. (Actually, there is only one)

#### EZDrawMember
This routine is supplied for those programmers wanting to display file type icons in a list of file names.  To use it simply pass its address into the list manager routines in the drawMember parameter.

NOTE that the actual implementation of this is located in the EZAsm.asm file.

### EZMENU.UNIT

#### newMenuItemTemplate
This function will allocate memory in which to place one of the new menu item templates, and will set it up based upon the input parameters. 

#### newMenuTemplate
Similar to newMenuItemTemplate, except that it create a menu template, rather than a menu item template.

#### EZNewDirectoryMenu
This function takes the input pathname, and produces a menu template with no title that is intended for use as a popup menu. Each item of the menu contains a directory name, with the first item containing the first directory name, and so on.

Note that each menu item will be 32 characters in length, thus allowing for network supplied names. 

#### EZUpdateDirectoryMenu
This function takes the input pathname, and produces a menu template with no title that is intended for use as a popup menu. Each item of the menu contains a directory name, with the first item containing the first directory name, and so on. 

Note that each menu item will be 32 characters in length, thus allowing for network supplied names.

This routine differs from EZNewDirectoryMenu in that it takes a pointer to an already existing menu as a parameter and does not create it from scratch. It simply overwrites the current menu items.

#### EZGetMenuPath
This procedure will take the item ID of a popup menu control and determine its currently selected value. It will then create a GSOS input string comprising the full pathname of the directory that has been selected.

#### EZDisposePopUp
This procedure will dispose from the heap, any memory that was allocated when the specified popup menu was last updated. This is done automatically when updating the contents of the popup, but should be done manually by the application when it is finished with the popup altogether. 

### EZMISC.UNIT
This unit contains all of the constants and types used by both the other EZ Library units, and any applications that in turn use the library.

Also supplied within, are several small routines that can make life a little easier for the programmer.

#### Hex
A procedure to convert a long integer to a hexadecimal pascal string,with the number of digits specified by Digits.

#### RIndex
A function similar to POS, except that it searches the string in areverse manner, and only searches for an occurence of one character. 

#### EZNew
A function similar to the pascal function "new" which will allocatea block of memory containing the specified number of bytes. It returns a pointer to the allocated memory block, or Nil if the block of memory was unavailable. This routine has been supplied, since the "new" function does not seem to work within an NDA. 

### EZSTRING.UNIT
#### Upper
Will convert the input character to upper case. 

#### UpperStr
Will convert the input string to upper case.

#### Lower
Will convert the input character to lower case. 
 
#### LowerStr
Will convert the input string to lower case.

#### EZFixStringToRect
Will take a pascal string, check it's length in pixels and adjust it until it will fit within the specified rectangle. If the routine has to truncate the string, then the boolean parameter specifies from which end of the string to truncate, and to add three periods. 

#### EZListCompare
This is a system support routine for use in the SortList tool call. The only difference between this and the default routine, is that this routine will ignore case in the comparison. 

### EZTOOLS.UNIT

#### EZStartDesk
Similar to the StartDesk routine in ORCA/Pascal, except that it loads almost every tool in existance and requires the application to supply the master SCB, rather than a resolution value. Thisis so that the application is able to set some of the other bits that havebeen defined with version 3.1 of quickdraw. The other major difference, is that the application is required to mainatin a pointer that is returned from the function, so that it may pass it to EZEndDesk when shutting down. 

#### EZEndDesk
Will shut down all of the tools started by EZStartDesk. Thisprocedure must be supplied with the startstop record pointer that was returned from EZStartDesk.

#### EZStartDesk
Similar to the StartGraph routine in ORCA/Pascal, except that it loads quickdraw auxilliary and the event manager as well. The application must supply the master SCB, rather than a resolution valueso that the application is able to set some of the other bits that have been defined with version 3.1 of quickdraw. The other major difference,is that the application is required to mainatin a pointer that is returnedfrom the function, so that it may pass it to EZEndGraph when shutting down. 

#### EZEndGraph
Will shut down all of the tools started by EZStartGraph. This procedure must be supplied with the startstop record pointer that was returned from EZStartGraph. 

### EZWINDOWS.UNIT
#### startupEZDialog & startupEZWindow
These function will create a window on the screen that looks like a dialog. This is for the purpose of creating a window full of extended controls, that cannot normally be created in anormal dialog. 

#### EZUpdateWindow
This procedure is an assembly routine that obtains the address of the specified windows content drawing procedureso that it may be called, to effect the update of the specified window. normal dialog. 

#### EZForceRefresh
This procedure scans through the current list of window sand forces the contents of each one to be re-drawn. This may be used to force windows to be updated when there is no need to call TaskMaster.

