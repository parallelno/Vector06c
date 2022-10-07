Ay_Emul v2.9 beta 32

Ay_Emul v2.7 official fixes and Ay_Emul v2.8 and v2.9 progress
--------------------------------------------------------------

v2.7 Fix 1 + BASS initial support:

20 April 2003

- SaveAs... and Search for tunes in files for ASC0 files had lost last byte,
  fixed now

15 June 2003

- Short titles can be wrongly displayed after some playlist operations on main
  window (fixed)
- Channels amplification was not selected during autoselecting chip type from
  playlist entry (fixed)
- Visualisation stops if Next or Prev buttons are pressed during pause (fixed)
- Added BASS.DLL v1.8 file types support (MP3, MOD and so on)
- Fixed some time diplaying problems in reverse count mode

v2.7 Fix 2:

28 June 2003

- BASS.DLL v1.8a supported (FFT4096)
- Playlist popup menu appearance error fixed ("system menu" key error)

1 July 2003

- Preamp moved to AY Emulation tabsheet of Mixer window
- Volume control controls global volume of system mixer now

27 July 2003

- VTX's Year member zero value is interpreted as 'no year information'
- VTX header editor allows to enter empty Year value

v2.7 Fix 3:

19 August 2003

- PT3 player: note correction after adding ornament is made as in Pro Tracker
  v3.6x (less than minimum come to minimum and greater than maximim come to
  maximum)

v2.7 Fix 4:

21 August 2003

- Added registering BASS file types in system (associating with Ay_Emul)
- Added volume control response if volume changed by other mixer programs

27 August 2003

- BASS's sound device and BASS.DLL both are freed after reaching end of playlist
  now

28 August 2003

- Added initial support of AudioCDs

v2.8 Beta:

22 October 2003

- Added filter for quality downsampling. It improves soundchip emulation of some
  AY musician's tricks like "Envelope + Ultrasound", etc, and also improves
  beeper sound emulation (Savage.ay, etc)
- Settings are saved in registry in new format
- All settings are saved automatically now, corresponding button is removed
- Default language is English now
- Tools and Mixer windows both are redesigned
- Fixed error of 2.7+ version only: some AY-files was not played correctly due
  wrong initialization of emulated Z80 RAM (see Mickey.ay from Ironfist's
  collection)

23 October 2003

- Skins directory is saved now
- BASS and system volume parameters are saved now too
- AY and YM indicators on main window show right information not only during
  playing now

25 October 2003

- Added 'Uninstall' button to complete removing Ay_Emul data from your system

v2.8 Beta 2:

26 October 2003

- Fixed some errors of previous release

1 November 2003

- BASS v2.0 is supported
- Time seeking after end of AY file started playing of next playlist item even
  if Loop button is on; fixed now
- Fixed some problems with redrawing time in "song length" time displaying mode
- Colors of playing item highlighting slightly changed
- Fixed error of redisplaying shorter titles on main window after editing
  playlist entry

2 November 2003

- Added two new icons by Exocet/JFF^Spaceballs^Industry
- Fixed error of time positioning in FXM (ZXAYAMAD) files
- Added PlayListLoop button to loop playing of all playlist items
- Added PlayListPlayingOrder button to select one of playlist items play modes:
  forward, backward, random orders and play only one item mode
- Playing order can be set by this new button only now

v2.8 Beta 3:

3 November 2003

- WaveOut code slightly changed to avoide deadlocks with bad soundcards drivers

4 November 2003

- Tracker modules loader and time length calculator is improved to avoid
  deadlocks with badly ripped or wrongly detected modules
- SQT detector is improved a little

6 November 2003

- Found STC file with not same patterns lengths (see SAT2.STC), so, STC file
  duration calculation is a little changed now

8 November 2003

- All hotkeys in main window can now works without Alt and Ctrl (1, 2, T, E, P,
  G)

14 November 2003

- Fixed error in filter (thanks to Key-Jee for bug-report and test module)

15 November 2003

- Fixed error of infinite looping playlist if all items has errors (i.e. not
  playable)
- Delete/clear playing item from playlist during vertical scrolling titles on
  main window works rightly now

18 November 2003

- Added several ways of sorting playlist items

19 November 2003

- AY emulation parameters setting is synchronized with playing thread now (for
  more safety AY emulation adjusting during playing)

v2.8 Beta 4:

22 November 2003

- After moving playlist item playing order was not recalculated (fixed)
- BASS.DLL fix: right playing tracker modules with 'jump' command at the middle
  of last position (thanks to Ian Luck for immediate fixing; see music from
  Aladdin game converted from AMF to S3M)

24 November 2003

- Main window's hotkeys work in playlist now

28 November 2003

- Added new icon from Roman Morozov
- Esc can be used to close playlist now
- Fixed errors of previous release

2 January 2004

- Fixed portamento to first note of pattern in PT2 player (see
  DejaVU#06_14-Epilogue.pt2 by Nik-O)

24 January 2004

- Fix: opening files and playlists with precalculated time length from command
  line updates total time label in playlist now

17 February 2004

- Fix: opening files and playlists with precalculated time length after
  drug'n'droping updates total time label in playlist now

v2.8 Beta 5:

20 February 2004

- Spaces between substrings in Track Descriptor was removed (specially for
  Key-Jee)

8 March 2004

- Fixed EPSG2PSG converter if both PSG's has same name (temp file was not
  renamed)

12 August 2004

- Fixed stupid bug: error message and no running if no CD-drives in system
  (thanks to Slava Kalinin for bug-report), soon will be fixed in v3.0 too
- Play positioning is slightly fixed: no unexpected delays when pressing left
  and right arrows keys to rewind
- Added additional syncronization into WaveOut thread
- Visualisation is improved: envelope sound visualized better (different levels
  for different envelope types including "soft" envelopes
- Two extra chars can be added to song name during finding or loading STC-files.
  They are got from extra ModuleSize field of STC-header (for example, Agent-X
  used this ability)

v2.8 Beta 6:

18 September 2004

- PT3 module finder is improved to more stable detect of PT3 modules with modern
  structure (Pro Tracker 3.6x and VT II 1.0)

27 October 2004

- Non-Delphi ScrollBar in playlist window (no need to mask corresponding Delphi
  error)
- You can drug'n'drop folders now (to main and playlist windows)

v2.8 Beta 7:

7 November 2004

- Added sorting by file type into playlist

14 November 2004

- Balance was set to middle by volume control (fixed)

29 December 2004

- Visualisation thread was moved to main one, so, there are no some problems
  in WinXP now. If you was using v3.0 as more stable version, you can back to
  v2.8 now

31 December 2004

- Masked some problems with buggy WM_ENDSESSION handler in Delphi 7 VCL
- Added WindowsXP controls
- Fixed bug with saving states of "Get from list" checkers in Mixer window


1 January 2005

- Added saving playlist visibility before closing application
- The latest BASS.DLL v2.1 is supported
- Removed timelength recalculation when interrupt frequency is changed temporary

v2.8 Beta 8:

6 January 2005

- Fixed FLS-player: ornament must be disabled during selecting envelope

7 January 2005

- Fixed FLS- and FTC-players: checking note range was [0..85] (correct is
  [0..95])

14 January 2005

- Fixed errors of working with system mixer (crytical error, Ay_Emul 2.8 beta 7
  did not work on some computers at all)
- Old bug is fixed: error in PT2-files timelength calculation (not used Tempo
  setting in channel C, see "*ELEPHANT*  BY JAAN_PHT 160896" module as example)
- Added 'Find playlist items' dialog into playlist window (call by F7)

15 January 2005

- Ay_Emul 2.8 beta 7 does not work rightly with command line parameter "/vhide"
  at first startup. Fixed.

v2.8 Beta 9:

6 February 2005

- PT2 note table removed (because of same as PT3 note table #1)

12 February 2005

- PT2 note range checking changed to PT3 standard (original PT2-player has no
  range checking anyway)

10 May 2005

- WMA support added (via BASSWMA.DLL v2.1 by Ian Luck). WMA playback requires
  the Windows Media Format modules to be installed. They come installed with
  Windows Media player, so will already be on most users' systems, but they can
  also be installed separately (WMFDIST.EXE is available at the un4seen.com)

12 May 2005

- WAV converter now uses PreAmp and Quality settings from mixer (thanks to
  T.A.D. 2005 for bug-report)
- Added Ay_Emul v3.0 behaviour during moving "main" and "about" windows

13 May 2005

- Shows number of items in playlist window (specially for Alone Coder)

15 May 2005

- Integrity checking is added into modules finder (specially for T.A.D. 2005)
- Fixed error in PT2.4PF finder (thanks to T.A.D. 2005 for WILD_SEY.tzx test
  file)
- Playlist loop button is used now in "play only current item" mode (specially
  for T.A.D. 2005)
- Fixed error: after drug'n'dropping files to active window, keyboard shortcuts
  not work until mouse click (thanks to T.A.D. 2005 for bug-report)
- Fixed error: waveout buffer access violation (thanks to T.A.D. 2005 for
  bug-report)

16 May 2005

- Added playlist color setup (specially for MadCat!)
- Corrected time length calculator for GTR v1.1 modules (see HYMN.gtr)

v2.8 Beta 10:

18 May 2005

- Fixed error: one position length PT3-files was not detected by module finder
  (thanks to Newart)

21 May 2005

- Fixed error of Beta 9: FLS structure analizer error
- Added 'Select CD(s)' dialog to load whole CD content. Function checks all CD's
  tracks and loads only audiotracks (even if its not available in standard file
  browser). Hold 'Ctrl' during clicking 'Open' or 'Add items' buttons (or use
  'Ctrl+L' and 'Ctrl+Insert')

13 June 2005

- YM2 samples are supported now (thanks to Arnaud Carre for sources and to
  Key-Jee for comments)

16 June 2005

- Command line analizer can expand filenames relatively to current directory
  path (specially for SMT), so, you don't need to specify full path now
- Added new command line key "/add" to add files from command line to the end of
  current playlist (specially for TAD and SMT). The key works only if Ay_Emul
  was started before

v2.8 Beta 11:

20 August 2005

- Fixed error in GTR loader and saver (thanks to TAD for CC#4 intro GTR-music)

10 September 2005

- Added PSM (compiled Pro Sound Maker modules) support

11 September 2005

- Show playing item number in playlist down right corner (specially for TAD)
- Integrity checker in modules finder is improved
- SQT finder is improved
- Tray icon reaction changed to single left click

15 September 2005

- Added TRD catalog analizer (works after loading TRD in playlist, specially for
  SMT)

16 September 2005

- Added SCL and Hobeta headers analizers (work after loading it in playlist,
  thanks to SMT for idea)
- Added deafult filename in "Save as.." dialog (specially for TAD), autoselects
  among original file name (from disk image file), song title or source file
  name

17 September 2005

- After loading TRD, SCL or Hobeta into playlist, AY_Emul extracts author and
  title strings from corresponding playing routine of ASC and STP modules
- 'Save as...' from playlist inserts title string to STP and ASC modules (if it
  was extracted from playing routine during loading into playlist)

18 September 2005

- Added PSC v1.00-1.03 support
- AY-files without file extension '.AY' was not detected (fixed)
- ESC key is used to close 'About' window now (specially for TAD)

20 September 2005

- Added YM5- and YM6-files integrity checker before loading to avoid problems
  during playing (thanks to Nikolay Amosov for test file
  JASON_BROOKE_OUTRUN_GAME_TUN2.YM)
- Added YM5- and YM6-files sample number range checker (thanks to Nikolay Amosov
  for test file MODU_ATTACK.YM)

24 September 2005

- Added new command line key "/adp" to add files from command line to the end of
  current playlist and start playing first ot them (specially for TAD)
- AY frequency range is up to 3.5 MHz now (specially for Vyacheslav Strunov and
  others)

v2.8 Beta 12:

8 October 2005

- ZXS-files registration removed from 'Tools' box

26 October 2005

- From one of last versions STP finder didn't work fine with initialized
  STP-modules (fixed)
- STP_InitId (header byte +9) after "Save As..." was equal to 0 for wrongly
  "uninitialized" STP-modules (fixed now). All modules are playable in Ay_Emul,
  but original ZX Spectrum STP player does not initialize them correctly and
  fails. All STP-modules ripped in Tools dialog has correct STP_InitId value
  anyway

4 November 2005

- Added Pro Tracker 3.x Utility modules support (with converting to snandard
  PT3)
- Only previous version error: after saving ASC0 files from playlist '.asc'
  extension was not appended (fixed)
- Changed 'Save As...' autofilename behavior (specially for TAD). Now, if
  original filename was not found, it uses source filename with appended
  hexadecimal index (playlist position number)

9 November 2005

- Shadow file inside of created YM6-file has '.ym' extension now (specially for
  T.A.D. 2005)

v2.8 Beta 13:

22 November 2005

- PT2 and PT3 searcher recalculates NumberOfPositions value before playing or
  saving (already was realized in Tools' PT2/3 searcher). Thanks to TAD for test
  module Square Head title.sna5.pt2

8 February 2006

- Added MIDI-files full support: MID and RMI files type 0, 1 and 2 (2 is
  accepted but not tested), notes visualization, seek bar, loop, text extractor
  and so on. Ay_Emul does not emulate MIDI devices (MIDI device installed on
  system is required). Thanks to Tom Grandgent for TMIDI source code
- FXM finder was removed (all existing FXMs extracted already, so no need to
  keep unstable FXM-files finder in Ay_Emul)
- Error of two previous versions was fixed: during saving playlists or
  converting modules Ay_Emul did not ask for overwrite permission

9 February 2006

- Upgrade BASS and BASSWMA support to v2.2
- Added 'Hanning window' option into 'BASS.DLL v2.2' tab of Mixer window
  (uncheck to decrease CPU usage)
- Loop button works now with all files playing by BASS

v2.8 Beta 14:

12 February 2006

- Added XMIDI-files support (including right looping). Thanks to Cless for The
  System Shock Random Generator source code
- MIDI playing engine is more stable now (fixed some bugs, added more smarter
  TAG-extractor, loading XMI and type 2 MID-files tracks into playlist as
  different entries)

13 February 2006

- Added amplitude visualization for MIDI-music

14 February 2006

- Redesigned file registration tab in Tools dialog
- Fixed some errors in code working with system registry

15 February 2006

- New format of AYL-playlist files: "FormatSpec" tag is a tune/sequence number
  for AY, AYM, XMI and MID (Type 2) files. Previous versions used "Offset" for
  an AY-files (still supported for compatibility)
- New command line feature: you can specify tune number for files containing
  more than one music. To add and play all music in file do as usually:

			Ay_Emul FileName1.ay FileName2.xmi

  To load and play only selected tunes of file use addition ":N" (N is tune
  number: 0 is 1st, 1 is 2nd and so on):

    Ay_Emul FileName1.ay:2 "Name2 With Spaces.xmi:0" "Its valid too.aym":3

- FormatSpec is placed on "List's item adjusting" dialog and marked as
  "Specific". For AY-files "Offset" must be either 0 or valid offset to desired
  song
- Added 'Seek to first "Note On" MIDI-event' option to skip silence at start of
  MIDI-files: if silence is greater than 0.5 of second, seek bar thumb "jumps"
  to 20 ms before first note start playing

16 February 2006

- Improved 'Autosaving last folder' option: saves paths of "fixed" drives only
  (i.e. hard disks and so on)

v2.8:

18 February 2006

- Previous version error fix: PSG/EPSG-files loader error
- Removed ZX-files seeking prescan, all required calculations before starting
  seeking now

v2.9 Beta 1:

3 April 2006

- Fixed some errors in mixer window interface
- Linear interpolation is used after filtering now (instead of average level).
  This method is better for "hi" frequencies emulation (close to SampleRate/2)
- Main window volume control is slightly more "non-linear" now

4 April 2006

- PT3-player bug is fixed (amplitude vibrato was not reseted during
  initialization)

20 August 2006

- New FIR-filter control: number of points is automatically calculated now. In
  case of too many points its number is truncated and averager is added instead
  of linear interpolation. User can only enable/disable filter in 'for quality'
  mode, current resampler mode are shown in bottom of 'Optimization' group of
  of 'Mixer' window.

21 August 2006

- At start-up MIDI and WaveOut devices are set by its name (not by number) now.
  Useful for systems with not fixed number of devices.

27 August 2006

- In 'Save As...' file name addition '_0' is removed if saving from *.sna,
  *.trd, etc for first playlist item (specially for TAD).
- Fixed previous version error: if several files was opening at on time in
  explorer, Ay_Emul started and stopped playing first of them (thanks to TAD for
  bug-report).
- You can call any ZX-modules editor now from 'Playlist' window, just specify
  path in 'Tools' dialog (for example 'C:\VT\VT.exe'). Thanks to Karbofos for
  idea.
- Fixed error in 'Reregister' function of 'Tools' dialog: non-Ay_Emul
  associations are not "killed" now (thank to TAD for bug-report).

2 September 2006

- All ZX trackers players initialization are fixed: all variables are set to
  zero before playing.
- Added default sample #1 for PT2-files (not used on ZX, but can be useful).

18 September 2006

- Bugfix: since Ay_Emul supports MIDI-files 'open file' dialog filter doesn't
  work right (last masks like *.trd, *.sna, etc are lost), this was Microsoft
  bug. Now using experimental code to access to open dialog's list box.

19 September 2006

- Optimization for perfomance was removed.
- 'Escape' button now can be used for minimizing Ay_Emul.

24 September 2006

- Open directory dialog is changed to shell's standard folder browser (thanks to
  TAD and other, who point me to limitations of old dialog).

v2.9 Beta 2:

28 September 2006

- Added tracker info during converting from PSM to VTX.
- Fixed some problems with folder browser.

06 January 2007

- Fixed Z80 emulation: OUT (C),0 command added.

29 April 2007

- Added 1.xx and 2.xx commands interpetation for PT 3.7+ modules.

1 May 2007

- One more standard STC string ID is added to STC title analizer.

7 May 2007

- AY emulation is redesigned to play Turbo Sound (2xAY) music.
- Any of two tracker modules (except FXM) can be played simultaneously now via
  special file format, which can be generated from Windows/DOS command line:

    copy/b Module1.pt3+Module2.sqt+ID ModuleTS.pt3

  where ID is 16 bytes length identifier file of next structure:
    +0 Str4 'PT3!' (PT3 type marker)
    +4 Word Module1FileSize
    +6 Str4 'SQT!' (SQT type marker)
    +A Word Module2FileSize
    +C Str4 '02TS' (TS marker)
- New playlist version is designed to store info about TS modules.

8 May 2007

- Added support of PT 3.7+ modules saved in TS mode.
- Experemental code for standard open dialog is removed (see change at 18
  September 2006) because not works in Win9x/Me/Vista. So, old problems come
  back (last masks in 'All Supported Types' filter are ignored). Will trying
  to write own Open Dialog.

9 May 2007

- All playlist operations like 'Convert to WAV...' work with all selected items
  now (specially for ASiC).

v2.9 Beta 3:

11 August 2007

- Fixed error of beta 2: wrong playing after forward seeking in AY-files (thanks
  to TAD for bug-report).
- Track descriptor default string "Silent now..." changed to "no song
  playing..." (thanks to Equinox).

12 August 2007

- Added BASS.DLL and BASSWMA.DLL v2.3 support.
- Added FFT8192 for BASS spectre visualisation.

15 August 2007

- Numpad 5 key can be used as Play/Pause button now (specially for TAD).
- Fixed error: wrong looping of YM2-files (see WINGS7.YM, thanks to TAD for bug-
  report).
- Specially for TAD playlist pop-up menu is remixed.
- Playlist improvement: use Space key to toggle current playlist item selection
  and Ctrl with cursor keys to move invisible cursor without selection changing.

v2.9 Beta 4:

20 June 2008

- Added UTF8ToANSI converter to OGG-tags extractor to fix non english strings
  displaying.
- 'All Files' is a default mask in OpenDialog now.

21 June 2008

- Added BASS.DLL and BASSWMA.DLL v2.4 support.
- Added FFT256 for BASS spectre visualisation.
- Playlist item is redrawn now if source file is not found during "save as...".
- Messages from other Ay_Emul instances is ignored now if exucuted any of modal
  dialogs (for safe playlist operations completion). Speccially for Newart.

22 June 2008

- Added APE and FLAC audio streams support via BASS_APE.DLL and BASSFLAC.DLL.

v2.9 Beta 5:

25 June 2008

- Added CUE sheet support for BASS streamed files.

27 June 2008

- Added OGG-tagged CUE-sheets in FLAC and OGG streams.

13 July 2008

- Long file names from Open File Dialog are converted to short if contain
  non-ANSI characters.
- Long file names from Open Folder Dialog are converted to short if contain
  non-ANSI characters.
- Long file names in Drag'n'Drop operations are converted to short if contain
  non-ANSI characters.
- Long file names in Command Line are converted to short if contain non-ANSI
  characters.

v2.9 beta 6 (experimental):

Legend: D2L - Delphi To Lazarus (conversion bug-fix or new feature)

1 November 2008

- D2L: Source is autoconverted from Delphi project to Lazarus one
- Added WV (WavePack) files support via basswv.dll
- D2L: No sound build for Linux (only AY related formats are supported)
- D2L: Version 1.6 of AYL playlist files to point UTF8 encoding
- D2L: Controls are Unicode now if running in Windows XP or Linux

v2.9 beta 7 (experimental):

2 November 2008

- D2L: Added AnsiToUTF8 for strings extractor in TRD/SCL image loader
- D2L: Added UTF8ToAnsi in ASC/STP 'SaveAs' for strings extracted from TRD/SCL

4 November 2008

- D2L: Added AnsiToUTF8 for AYS-skin v2.0 strings
- D2L: Shows exceptions of Free Pascal now
- Correct startup with default skin if user skin can not be loaded
- D2L: Corrected VTX/YM6 header editor
- D2L: Added UTF8ToAnsi for VTX/YM6 converter
- D2L: Unpacked YM-files loader bug fixed
- D2L: For ZX-formats only latin chars was allowed in filename (fixed)

5 November 2008

- D2L: Added support for Unicode file names during saving modules and playlist,
  converting to WAV/VTX/YM6/ZXAY and opening in external module editor
- D2L: ANSI or short filenames are saved in M3U now
- D2L TODO: AYSTATUS.TXT user defined filename can be only ANSI (as in Delphi)
- D2L TODO: 'Searching for tunes in files' work folder name can be only ANSI (as
  in Delphi)
- D2L: Russian messages in 'Searching for tunes in files' converted to UTF-8

8 November 2008

- Audio streams TAG-extractor is totally rewriten, the most tags and encodings
  are supported now (ID3v1, ID3v2, OGG, APEv1, APEv2, WMA, UTF-8, UTF-16)

9 November 2008

- Fixed error in MIDI text CRLF line splitter
- MOD messages, instrument and sample names are extracted to Comment of playlist
  item now
- D2L: application button could become hidden on system taskbar in mimize to
  tray mode, fixed

10 November 2008

- D2L: could not load M3U's with non-latin chars in filename (fixed)

12 November 2008

- D2L: converting to WAV/ZXAY/PSG/VTX/YM6 could not be aborted, fixed in
  Win32-version for the moment
- D2L: searching for tunes during opening unknown type files shown progress
  window non modally, fixed in Win32-version

13 November 2008

- BASS' FLAC, APE and WV DLLs wasn't unloaded after stopping playing, fixed

14 November 2008

- D2L: Russian description of associated file type was stored in UTF-8 in
  registry (fixed)
- D2L: MIDI, WAVE and MIXER devices names are converted to UTF-8 to correct
  show non-latin chars
- Fixed old error of manual selecting volume control

15 November 2008

- In "Always on Tray" mode mouse clicking on tray icon allows to minimize
  Ay_Emul (specially for TAD) or bring it to front if main window is overlapped
  by other non Ay_Emul windows

16 November 2008

- D2L: Strange bug in Windows 98 is "fixed": Tools window crashes Ay_Emul
  immediately after appearing. I really don't know, what's the problem (maybe
  LCL bug), but after some code rearranging all work now

22 November 2008

- D2L: Yet another Lazarus bug is found in Windows 98 mode: after starting/
  stopping playing manual sample rate entering field is corrupted with wrong
  values. I've replaced disabling/enabling SampleRate group with disabling/
  enabling its controls and all work now
- D2L: fixed finder and sorter of playlist in Windows 98 mode
- D2L: fixed AY Emulator Start menu link removing and link icon changing

v2.9 beta 8:

30 November 2008

- D2L: Couldn't load AYL-files with non-latin chars in filename. Fixed.

25 January 2009

- D2L: could not load M3U's items with non-latin chars in path (fixed)

27 January 2009

- Fixed error for multi-monitor systems: if main display is righter or lower
  Ay_Emul main window could be moved to 2nd display, but could not be moved
  back (thank to kay27 for bug-report and beta-testing).

2 February 2009

- D2L: if closing on OS shutdown or user logoff, current playlist and settings
  was not saved. Fixed.

8 February 2009

- Removed scroll repaint optimization: next string is recalculated and
  repainted each time before showing (thanks to TAD for describing error cases).

v2.9 beta 9:

18 February 2009

- D2L: LCL was fixed, so, simple recompiling removes next errors: Save and Open
  dialogs are both really modal now; restoring in right Z-order now (if several
  windows was minimized).
- D2L: Fixed hiding taskbar button algorithm, including no flicking during bring
  to front.

10 February 2010

- Bugfix: CUE with several audio-filenames inside was doublicated in playlist.
- Strings in CUE starting with ';' is ignored now.
- Added autodetection of UTF8, UTF16LE and UTF16BE for CUE text files.
- CUESHEET is extracted from APE tags of WV-files now

21 February 2010

- Added autodetection of UTF8, UTF16LE and UTF16BE for M3U text files.
- Added 'http://' and 'ftp://' shoutcast streaming (internet radio).

5 March 2010

- Added XMPlay's PLS playlist file reader.

v2.9 beta 10:

21 August 2010

- Recompiled in last Lazarus version to fix some old LCL errors.

26 August 2010

- Bug-fix: if About dialog is placed on second display with negative coordinates
  OK and Help buttons both do not respond to mouse clicks

31 August 2010

- Volume control behaviour is slightly closer to system main volume control now

v2.9 beta 11:

6 November 2010

- Added "Remove DC bias" option for BASS FFT visualization.
- Added AC3 (multichannel audio) files support (RIFF containers are not
  supported yet).

9 June 2011

- Fixed errors in loader of CUE with several file-links inside (last track of
  each file was zero time length).
- Added support for merged CUE-files
- Added support for "REM DATE" tag in CUE-files

v2.9 beta 12:

Legend: Lin - Linux version progress

28 Junuary 2012
- Added 'Deduplicate' option into Playlist window to remove duplicated items
  from playlist

29 March 2014
- Added DDE server to execute files directly from Windows shell

11 September 2015
- Added "Add" and "Add'n'Play" command for Windows shell
- Added FFT16384 for BASS spectre visualisation.

12-14 September 2015
- Lin: Added several libbass*.so libraries support into Linux version
- Lin: AY formats are playing via BASS library on Linux
- Lin: The most interface and sound features are working in Linux version now
- Lin: Some tools, converters, etc can work, but not tested due time limit
- Lin: Not work yet: options saving, MIDI-files and CD playing
- Lin: Some unexpected GTK2 behaviour is not masked yet (like minimizing some
  windows, minimizing/restoring application from tray icon).
- Lin: Little different region functions behaviour cause bad border problem on
  main window, is not solved yet.
- Lin: Non-unicode string converter is not adjustable yet (only CP1251 supported
  for now).

v2.9 beta 13:
5 October 2015
- D2L: one more little step for avoiding using WinAPI: WaveOut thread
  synchronisation is FPC-based now

6 February 2016
- Lin: Controls of some windows are rearranged to better be shown in Linux
  version

7 February 2016
- Lin: options is saved now into Ay_Emul.cfg file (into user config folder,
  usually ~/.config)
- Same in Windows version (into user appdata local folder), so, options are not
  saved to system registry now
- You can move Ay_Emul.cfg into folder with Ay_Emul (both for options reading
  and saving)
- Same rule for default playlist Ay_Emul.ayl now

8-9 February 2016
- HLP projects are converted to CHM cause of no normal HLP-viewer in Linux

10 February 2016
- Lin: some minimizing/restoring problems in GTK2-widgetset is masked via extra
  code (todo: task in Lazarus bugtracker)

v2.9 beta 14:
12-13 February 2016
- Lin: several todos and bugs are fixed (uninstall, ayfinder, long strings in
  playlist, etc).

14-15 February 2016
- BASS spectre visualization slightly changed to better viewing high frequency
  range

16 February 2016
- New choose folder dialog (now you can switch same options as in Windows
  version in Linux one)

17 February 2016
- All WinAPI file-handling code is replaced by SysUtils analogs (therefore its
  same in Windows and Linux version now)

21 February 2016
- Precalculated in Windows 7 region is used now for all OS versions (including
  Linux) to avoid differencies in CreateRoundRectRgn for main window border

22 February 2016
- Lin: when playing AY/AYM CPC music, chip frequency is switching to CPC's
  1000000 Hz, but not showing in mixer current chip frequency field (fixed)
- Lin: fixed error of dropping folders on main window or playlist one. TODO:
  point of dropping files in playlist is not calculated properly yet
- Wrong reaction to missing bass libraries during calculating playlist time
  length (fixed)

23 February 2016
- No Time and Radio Station Name requests now when adding URLs from playlist
  files (to speed up start of playing)

v2.9 beta 15:
8 March 2016
- Revised code around pointers (too mach errors and warnings after moving from
  Delphi to Lazarus), in result was fixed some bugs in finder

9 March 2016
- Added updating tray icon hint and aystatus.txt after recieving BASS stream
  meta data tags (for internet radio, etc)
- Meta tags decoder is rebuilt for better decoding broken tags in some internet
  radio streams (HTML entities, mixing UTF16 and UTF8 in one tag and so on, see
  http://radio.sunradio.ru:80/children64 or
  http://stream0.radiostyle.ru:8000/neslaboe for example)

12 March 2016
- BASS 2.4.12 changes are implemented (FFT 32768 option is added)

13 March 2016
- Masked GTK error (can minimize any application windows, but no way to restore
  it in single task button mode) for Playlist and Mixer windows

14 March 2016
- Eraseup code for easy migrating to Lazarus 1.6 + FPC 3.0.0 (Win9x is still
  supported in theory)

15 March 2016
- Exceptions messages during adding files to playlist is collected and shown
  once after end of task
- Applied some tricks to load "damaged" YM-files with "xx-lh5-xx" marker like
  'YM Archive v5\Whittacker.David\Xenon 2\Xenon2.ym'; files like
  'YM Archive v5\DeMan.Joris (Scavenger)\Synergy Demo\Rapido3d_all.ym' and
  'YM Archive v5\DeMan.Joris (Scavenger)\Synergy Demo\Rapido3d_part1.ym'
  need to fix (truncated by header length)

16 March 2016
- Fixed TS-loader (continue loading as usual module if TS-identificator
  slightly different or has non-valid fields), need to fix 2nd module size
  in X-agon_of_Phantasy-Breath-of-air-6chan-MOD.sqt
- File analizer (finder) is switched off now during dropping folders and files
  on main or playlist window

v2.9 beta 16:
25 March 2016
- D2L: Used FPC resources instead of Lazarus resources
- Resources moved from RC-file to project properties
- Lin: WaveOutAPI.pas is not used in Linux version, and bug was masked here:
  AY visualisation buffer length was not set (in SetBuffer for waveOut) and
  visualisation was slightly earlier of sounding. Fixed.

28 March 2016
- If between Ay_Emul launching desktop size was changed and 'Save windows
  position' option is checked, some Ay_Emul windows can be 'shown' outside
  of desktop bounds. Fixed.
- BASS visualisation's AmpMin/AmpMax is in range [0.0001..0.02] now
- BASS connection parameters are added to Mixer->BASS 2.4 page (for Internet
  radio, etc): User-Agent and proxy settings
- Added #EXTM3U tags loading from M3U-files (only for BASS types)

3 April 2016
- Trying detect UTF-8 for M3U-files without BOM now
- File name with path is shown in playlist now if string formatter produces
  empty string
- Previouse tune title was continue showing when empty meta tag is received
  during playing Internet radio in some cases (fixed)

5 April 2016
- Default code page selector added to Tools window (used for text and strings
  of non-Unicode encoding or if Unicode encoding is not autodetected)
- COMMENT and GENRE tags from CUE-sheet added to comment of playlist item now

6 April 2016
- D2L: tools (TL) button on main window was unpushed even if Tools window was
  shown (in Windows version only) due differencies between LCL and VCL (fixed)
- Added support for loading M3U8-playlists (M3U in UTF-8 encoding)

7 April 2016
- Tested in Windows 95 OSR 2 and in Windows 98 SE. Results: Windows 95 is not
  supported, Windows 98 is still supported. Next beta will be based on new
  FPC and Lazarus, which officially does not support Win9x anymore, so keep
  v2.9 beta 16 if you want to launch Ay_Emul in Ansi-based Windows (98/ME/etc)

v2.9 beta 17:
4 May 2016
- Starting migrating to Lazarus 1.6.0 + FPC 3.0.0 (Windows version ansi only
  code is changed to wide analogs, etc)

5 May 2016
- Wrong handling error if editor is not found during "Open in editor" (fixed)

7 May 2016
- Removed checking and other Ansi-branches code for old Ansi-based OSes (in
  Windows version), only Wide (Unicode) branches are kept
- From this point Win9x support is totally discontinued. LCL Ansi-branches code
  will be cleaned up in Lazarus 1.7.0 as expecting

10 May 2016
- Added codepage setting for "Track Descriptor"
- Removed FIDO-specific chars replacement (#205 and #240) from "Track
  Descriptor"

11 May 2016
- New option in "Open files from folder" dialog for playlist files: include,
  exclude and only playlists

13 May 2016
- Mouse wheel scroll down causes playlist redrawing even if was no scrolling
  (fixed)
- Fixed TS-loader errors (wrong code if second module type is differ from
  filename extension; text fields for second module was loading from first one)
- For TS-files: second module text fields are decoded due selected code page
  now (for the moment result can be seen in saved AYL-playlist file only)

15 May 2016
- Masked LCL error (page size of playlist's scroll bar is visually shorter in
  Linux version)

v2.9 beta 18:
27 August 2016
- Could stop playing if to seek backward from position near end of current
  track (fixed)

28 August - 18 September 2016
- Lin: Digital Sound engine and System Mixer has been rewritten for using ALSA
  library, so libbass.so is not used by AY emulation engine now and can be
  removed if you are using Ay_Emul only for chip music formats

29 September 2016
- Lin: passing command line parameters to first instance of Ay_Emul now (like
  in Windows version)
- Command line keys must be started with '-' prefix instead of '/' in Linux
  version (in Windows version can be used both variants)

9 October 2016
- "Add'n'play" shell command behaviour was slightly changed: if group of files
  is added, Ay_Emul is starting playing only first of them instead of trying to
  start playing of all of them (i.e. was playing last of them)

15 October 2016
- Application registration was corrected due last Microsoft recommendations for
  file types association: corresponding information is changed only after
  pressing Register or Unregister button of Tools window, previous default
  handler for file extension is not backuped and not restored (just copied to
  "Open With..." list)
- Due this change your selection of file types in Tools window can not have
  desired effect after series of Register/Unregister pressing (if user was not
  selecting other application manually, all that file types is coming back
  after pressing Register even if you do not select it again before)
- Second new feature after registering: you can type Ay_Emul in command line or
  in Explorer's Run/Search without path to launch AY Emulator

18 October 2016
- Added shell handler to recreate tray icon after Windows Explorer reloading
  due it's crashing

30 October 2016
- Added converting from user defined codepage to UTF8 during parsing headers in
  TRD, SCL and Hobeta formats (to avoid non-ASCII symbols be converted to '?')

31 October 2016
- Skins can be loaded from command line without prefixed key '/p' or '-p' now
- Skins can be loaded by pressing Open button of main window or Add button of
  playlist window (even if they was mixed with usual music files): added
  "Skins" file type mask to the corresponding dialog
- Bug: if Loop button on main window switched to unpushed state during playing
  Internet radio, "Play Next" message is sent (fixed)
- Can lock till end of playing current MIDI-file in some cases like fast Next
  button pressing (fixed)

1 November 2016
- File analizer (finder) can be aborted now for all added files (not only
  current; additional info and button added to corresponding progress dialog)
- Due this change finder is switched on back during dropping folders and files
  on main or playlist window

5 November 2016
- Exocet's small icon is fixed  (removed unused layer and truncated size to
  16x16)

6 November 2016
- Location of default Ay_Emul.ayl playlist was in undefined state if some files
  was pointed in command line (or via shell DDE), so it was saved to config
  folder instead of expected place (fixed)
- Lin: old (MSDOS) filenames in up case was hidden under corresponding Open
  File Dialog filters, so added additional "up-cased" file masks to view them

7 November 2016
- D2L: fixed error in converter to ZXAY (fixed writing to buffer dword values)
- Fixed error in converter to ZXAY (wrong source file checking for AYM, error
  in progress bar for AY and AYM)
- If converting EPSG to PSG with same name, file type is changed, but is not
  redrawn on playlist (fixed)
- Lin: added supported file type registration via mime-types. No set as default
  player for selected types for the moment. Pressing "Register" in Tools window
  saves info about mime-types, icons and application desktop commands (in the
  current user home settings folder). "Unregister" for remove it back. Under
  root user you can check "For all users" to save it in "/usr" directory.
  Anyway you can manually find, edit or copy the files from your home folder

v2.9 beta 19:
20 November 2016
- File analyzer (finder) can detect TS-modules during adding files now (usefull
  if opening disk or tape image with TS-music inside), previously TS module was
  added as two usual standalone modules
- Lin: into Open Dialog added additional "up-cased" file masks for extra types
  like TRD, SCL, etc

21 November 2016
- If file name in disk image has a standard extension (like file.pt3), "Open in
  editor" task has added one more extension (like file.pt3.pt3), fixed

23 November 2016
- On tray mouse click could wrong detect what to do in Windows version:
  minimizing or bring to front if main window is overlapped by "stay-on-top"
  window, fixed

29 November 2016
- Time font is smaller now for big duration music (1 hour and bigger, like
  internet radio)
- Bug of previous beta: after editing playlist item its type is changed (fixed)

v2.9 beta 20:
6 December 2016
- BASS formats loading and playing logic is slightly changed: previously Ay_Emul
  did not using built-in BASS plugin support (load and call corresponding dll
  directly), now all BASS' dlls are loaded as plugins, so BASS can self analize
  which one to use
- Added Opus, AAC, ALAC and DSD BASS plug-ins. Note: if you have corresponding
  codec in system, BASS can play format without additional plug-in (for example,
  AAC, WMA can be preinstalled in some Windows versions or codec-packs)

20 December 2016
- Inline assembler is replaced by pure Object Pascal, including Z80 emulation
- Some errors has been fixed in Z80 emulation during analizing ASM routines
- Free Pascal compiler produces not so good code like Delphi, so it was hard
  decision to remove inline assembler from project, but its need at least for
  future 64-bit version of Ay_Emul

21 December 2016
- 64-bit version for Windows has been made

23 December 2016
- Bug of beta 18: if loading AYL-playlist with PSG music previously saved from
  Ay_Emul, it's type is changed to EPSG (fixed)
- Saving AYL logic is slightly changed: for multiformat file name extensions
  (like .AY or .PSG) parameter "Type=" is written always

27 December 2016
- 64-bit version for Linux has been made

v2.9 beta 21:
7 August 2017
- There are too much cutted ASC and ASC v0 modules in Goblin's Crack Intro
  Archive, so I've decided to add .AS0 file extension (as in that archive),
  and turn off autodetection for files with .ASC and .AS0 extensions (anyway
  it was turned on several betas ago due error)

13 August 2017
- File analyzer (finder) can detect TS-modules since beta 19, but incorrectly
  set next search position if TS is not found (fixed)

16 August 2017
- File analyzer (during adding files to playlist) extracts ASC and STP tags
  from player code block in source file of any type now (previously it extracts
  it only from TRD/SCL/Hobeta and only if player was at begin of corresponding
  catalog item)

17 August 2017
- Files with extension .STP must be not initialized (Ay_Emul "uninitializes" it
  before saving with extension .STP). But seems Goblin uses totally bad ripper
  (for ASC and STP as minimum) and there are too much initialized STP modules
  in Goblin's Crack Intro Archive, so I've decided to add ability of loading of
  such modules. Anyway, in Goblin's archive title from player code of STP is
  inserted incorrectly.
- Total: corrupted modules from Goblin's Cractro Archive (ASC, AS0 and STP with
  titles) are played in Ay_Emul now, but you need rerip it to get right ones
  (just run SCL in ZX Spectrum emulator, save SNA, load it in Ay_Emul and save
  all found modules)
- File analyzer in Tools window is improved: if found tag in player of ASC0, ASC
  and STP module, finder saves two variants of module - without tag (as usually)
  and with tag (added "-tag" to file name to mark it)

v2.9 beta 22:
1 September 2017
- One more "surprise" in Goblin's Cractro Archive - one truncated Super Sonic
  STC module, to rerip it Ay_Emul STC-ripper is slightly modified (it can
  detect Super Sonic modules now, previously I was ripping it manually)
- Added '(C) KLAV "S_SONIC"' to standard STC titles list to skip during loading
  tags (like 'SONG BY ST COMPILE', etc)

4 September 2017
- Firestater reported about very old bug: in some cases (for example, after
  drug'n'dropping to playlist window) new playlist's items are not redrawn
  till window resizing or scrollbar clicking. Fixed.

7 September 2017
- In some cases main window is unaccessable to move by mouse, so own code in
  AdjustFormOnDesktop function is replaced with standard LCL's MakeFullyVisible
- In some collections TS-modules come with .TS file extension, so it was adding
  to Ay_Emul too
- In playlist window for TS-modules filetype is shown now as "PT3x2",
  "PT3+SQT", etc

8 September 2017
- For PT 3.7 TS-modules marker "PT3TS" is shown in playlist window now
  (FormatSpec=0 in AYL)

v2.9 beta 23:
2 October 2017
- FormatSpec=-1 in AYL (default value) is always saved for non-TS PT3 since beta
  22. Fixed.
- Added info about one more ASC player into file analyzer's tag extractor
- File analyzer can extract now tag "SOUND TRACKER COMPILATION OF " from ST 3.xx
  player block during adding files to playlist or during searching for tunes in
  file
- "SOUND TRACKER COMPILATION OF " can be inserted to STC during saving from
  playlist or by tunes finder (same idea like in STP and ASC: some pointers are
  incremented to get place for string inside of song data block). Modified STC
  module is playable by standard players. Modification prevents of losting new
  string during reripping, copying, etc, therefore better than just appending
  to the end of file
- Some tricks are implemented to merge song titles in STC if needed (if STC
  contains two different tags in traditional place and in "SOUND TRACKER
  COMPILATION OF ")

7 October 2017
- Added uncompiled Sound Tracker 1 modules player (shadow compilation to STC is
  performed)
- Added ST1 file extension as id of uncompiled Sound Tracker 1 modules
- "Save As..." for ST1 saves STC (can use as compiler)

v2.9 beta 24:
26 October 2017
- Using current sample rate instead of initial one for BASS spectre
  visualisation

27 October 2017
- Added info about one more ASC player into file analyzer's tag extractor

2 of December 2017
- Added SNDH (Atari ST and Atari STe universal native music format) support.
  SNDH contains original player code for MC68000 processor and music data. Some
  Atari ST/STe hardware is emulated: MFP timers, DMA-Sound, some TOS traps, etc.
  More information about SNDH playing engine can be found in documentation of
  my Micro ST project (http://bulba.untergrund.net/ayplayer_e.htm). SNDH support
  is realised speccially for key-jee (sorry for huge delay, Atari ST emulation
  was a very hard task for me)

3 of December 2017
- Added options for DMA-Sound level and MC68000 frequency in the Mixer window

4 of December 2017
- Added warning labels if mixing can overflow (in Mixer window)
- Added Mixer Amplifier Helper to set all emulated sound devices output levels
  to maximum without overflow (look button in Mixer window)

5 of December 2017
- Added ST/STe, Force YM Mono and Force Mono switches to adjust Atari emulation
  (SNDH player)
- Back to own code in AdjustFormOnDesktop (Firestarter had reported about error
  with several monitors since using standard MakeFullyVisible, so, just
  modified own code)
- Added font selection for Playlist window (specially for Firestarter)
- Fixed error in settings loader (could set random data if setting was not found
  in CFG file)

6 of December 2017
- No information about point of dropping files in Lazarus' OnDropFiles (like
  WinAPI's DragQueryPoint) and Ay_Emul uses alternative way to retrive it.
  Firestarter had reported that Ay_Emul is often mistaking and dropping files
  at random position of playlist. So, drop point detection is switched off,
  dropping files are always added to the end of playlist now
- If author or title string is empty in first module of TS-pair, using second
  module to display info now

v2.9 beta 25:
20 January 2018
- If SNDH-file has contain several tunes, Ay_Emul used Specific playlist
  property to store tune number value, but it was not saved in AYL-file (fixed)

5 February 2018
- Interface is ready to translate to any language, just copy Ay_Emul.po to
  Ay_Emul.*.po in languages subfolder (* is your language id like pl, zh_CN,
  etc) and translate it. You can send me your translations to be included in
  next release of Ay_Emul
- Ay_Emul.ru.po is made for Russian interface, Ay_Emul.po for English (you can
  override it with your own Ay_Emul.en.po)
- lclstrconsts.*.po was copied from Lazarus' LCL sources (to translate LCL
  messages like 'file not found', etc), but they are using only if 
  corresponding Ay_Emul.*.po are present
- Command line l switch is used to point language now, f.e. for English type
  Ay_Emul -len

7 February 2018
- StSound's YM-files are added via detection (header analizing) since several
  versions ago, fixed to load directly
- You can point tune number in command line for SNDH-files now (like for XMI,
  MIDI, AY and AYM): "Ay_Emul file.sndh:0" to play 1st tune,
  "Ay_Emul file.sndh:1" for second one, etc

11 February 2018
- ST1 structure checker is improved to fix broken files like in AAA's archive
  ishodnik.zip\SONG2.SCL\LYRA6.S (you can load and save it in Sound Tracker to
  "fix" it or replace via hex-editor in position list pattern number 9 to 1 to
  really fix it)
- Detector of "Opening/adding file" can detect non-compiled Sound Tracker
  modules now, so you can load or drop TRD/SCL/TAP and ST1 will be extracted
  (could save as STC from playlist, if you need)

12 February 2018
- Modules finder is improoved to search ST1 modules. The tool has saved both ST1
  and STC (uncompiled and compiled) if ST1 is found, so you can use it as ST1
  ripper or as ST compiler

v2.9 beta 26:
22 February 2018
- PSG- and EPSG-files are added via detection (header analizing) since several
  versions ago, fixed to load directly, and also fixed error of beta 25 only
  (PSG and EPSG was not loaded at all with error message)

23 February 2018
- Added several rules to ST1 detector to decrease number of false detections

v2.9 beta 27:
26 October 2019
- Fixed Z80's OUTI, OUTD, OTIR, OTDR emulation (bug due error in
  z80-documented.pdf): B decremented before outing now (thanks to goodboy for
  HeroQuestCPC.ay)
- Added 3-bit mask for CPC's PIO ports F4xx/F6xx & %0000101100000000 (Amstrad
  CPC emulation)
- Rewrote CPC AY output logic for right work with non-standard players (like
  HeroQuestCPC.ay, thanks to goodboy for it)

16 of April 2021
- Fixed manual mixer selection (worked as autodetect)

v2.9 beta 28:
22 February 2022
- Added ZX Sound Tracker Pro uncompiled format support (file extension STF). Can
  be found in various music collection on TR-DOS disk images (with extension .F
  and start address 25000). Just copy from image and change extension to STF.
  Used same method as with Sound Tracker uncompiled: shadow compilation to STP.
- You can use Save as... for STF to compile and save it as STP. If you have
  uncompiled Sound Tracker Pro music collection, you can listen to directly or
  save as STP to get better result than original compilers (built-in in ZX Sound
  Tracker Pro editor): I'd fixed several errors and peformed some optimization
  to get smaller size.

23 February 2022
- Ay_Emul detector was improved to detect ZX Sound Tracker Pro uncompiled modules
  now. You can open or drug'n'drop TRD or SCL image to extract STF, for example.
- Search for tunes in files (Tools window) can be used to search STF (result is
  saved in both uncompiled STF and compiled STP variants.
- Removed MS Sans Serif font from main window (using default for Lazarus' LCL
  now) to fix some national characters viewing.

v2.9 beta 29:
2 March 2022
- Bug fix: player frequency for SNDH without corresponding TAG was set to some
  previously played song value. Added default player frequency 50 Hz to SNDH
  loader now (all SNDHs without player frequency TAG must played as TC50 due
  SNDH v2.1 specification published at sndh.atari.org).

4 March 2022
- Bug fix: Atari ST code page table's character ',' was coded as '0'.

5 March 2022
- SNDH TAGs analyzer was totally rewrote to comply specification requirements
  (sndhv21.txt): removed the most tricks to load bad or damaged SNDH-headers, so
  use good SNDH-files sources now (sndh.atari.org, for example) or rebuild bad
  ones.

6 March 2022
- AY-files of ST11-subtype are supported for now (can be found in AY-music
  archives for Patrik Rak's DeliAY from Amiga). ST11 is the Sound Tracker 1.1
  uncompiled module (aka ST1 in Ay_Emul).

7 March 2022
- Bug fix: some dynamic content labels re-"translated" with default values after
  switching current language (even to same option).
- Removed some strings no need to translate from language files (like AY-3-8910,
  1773400, etc).
- Bug fix of beta 28: all forms translated again each time when open file dialog
  is called.

v2.9 beta 30:
10 March 2022
- Bug fix: STF compiler error due wrong info in KSA's stprhelp.txt about unused
  digits 3-7 in orn/env position. Really them used in editor and in native
  compiler to set ornament 0 (see YIR.F aka BACA&IMP:YOLKA in RAVE, they set 3
  everywhere).

v2.9 beta 31:
13 May 2022
- ST3 (Sound Tracker 3) compiled modules has been supported. This is special
  format for compiling usual ST1 (non compiled Sound Tracker 1.xx). Ay_Emul
  converts ST3 to STC shadowly before playing, so you can right-click in
  playlist and save selected ST3 as STC without losting any format nuances.
- Patterns and samples numeration starts from 0 in ST3 (in original Sound
  Tracker 1.xx - from 1), so generated corresponding STC is unusual for various
  decompilers (except Vortex Tracker II, of course), but are played correctly
  by any STC-players.

14 May 2022
- "KSA SOFTWARE COMPILATION OF " tag from ST3 is inserted to STC if it's saved
  from playlist. So STC can contain either "SOUND TRACKER COMPILATION OF " or
  "KSA SOFTWARE COMPILATION OF " tag now.
- And again: not all decompilers can evolute or correctly ignore the tag
  (Vortex Tracker II ignore it for the moment), but taged STC are played
  correctly by any STC-players (full compatibility).

15 May 2022
- ST3 modules can be detected during opening files like TRD or SNA. Player body
  tag is extracted and uninitializing (loading address substruting from
  samples and ornaments pointers) is performed too.
- Module finder (in Tools window) is improved to search ST3 modules. For each
  found module both ST3 (with and without tags) and STC (with and without tags)
  are saved, so you can use it to convert ST3 back to STC to play with native
  STC-player.

v2.9 beta 32:
15 June 2022
- AS0 finder improved to detect ASM 0.xx with inserted tag.

22 June 2022
- Native ZX Spectrum FTC-player does not write R13 (envelope type) if same
  value was where already, so Ay_Emul's FTC-player fixed to be identical to
  native one.
- Fast Tracker 1.07 new feature has been supported: for modules with version
  1.07 and higher can be two new note tables pointed in header - Classic (Sound
  Tracker) and 1.75MHz (FTC unique). For previuos FTC 1.00-1.06 old note table
  is used (from Pro Tracker 1-3 aka modified Sound Tracker note table).
- Fast Tracker 1.08 new feature has been supported: full envelope+tone retrig
  special command (listen RE-TRIGG.ftc from FT 1.08 beta 1 package). Seems,
  command is simplified in native FTC 1.08 beta 1 player: if retrig set in
  several channels, used only one from last channel, and Ay_Emul's FTC-player
  do same as native one.
