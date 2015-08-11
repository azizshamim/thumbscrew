-- thumbscrew.scpt
-- usage: thumbscript.scpt <path_to_root_dir> <path_to_keynotePresentation>
--
-- Will create scaled thumbnails of length `thumbSize` in the directory
-- <path_to_root_dir>/<thumbnailDir>/<presentation>
property thumbSize : 480
property thumbnailDir: "keynotes"

on getImages(f)
  tell application "Finder" to return (files of folder f) as alias list
end getImages

on run argv
  set gitRoot to item 1 of argv
  set tmpFile to item 2 of argv
  set documentName to item 2 of argv
  if documentName ends with ".key" then set documentName to text 1 thru -5 of documentName

  set gitRoot to posix file (POSIX path of (gitRoot as text) & "/" & thumbnailDir) as alias
  set tmpFile to (POSIX file tmpFile) as alias

  tell application "Keynote"
    activate
    open tmpFile

    if playing is true then stop the front document

    tell application "Finder"
      if not (exists folder documentName of folder gitRoot)
        make new folder at gitRoot with properties {name:documentName}
      end if
      set the targetFolder to folder documentName of folder gitRoot
      set the targetFolderHFSPath to targetFolder as string
    end tell

    export front document as slide images to file targetFolderHFSPath with properties {image format: JPEG}
    set jpegs to my getImages(targetFolderHFSPath)
    repeat with thisJPEG in jpegs
      try
        tell application "Image Events"
          launch
          set this_image to open thisJPEG
          scale this_image to size thumbSize
          save this_image with icon
          close this_image
        end tell
        on error error_message
          display dialog error_message
      end try
    end repeat

    close front document without saving
  end tell
end run
