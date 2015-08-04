property thumbSize : 480

on getImages(f)
  tell application "Finder" to return (files of folder f) as alias list
end getImages

on run argv
  set keynotePresentation to item 1 of argv
  set tmpKeynotePresentation to item 2 of argv

  set keynotePresentation to (POSIX file keynotePresentation) as alias
  set tmpkeynotePresentation to (POSIX file keynotePresentation) as alias

  tell application "Keynote"
    activate
    open tmpkeynotePresentation

    if playing is true then stop the front document
    set documentName to the name of the front document
    if documentName ends with ".key" then set documentName to text 1 thru -5 of documentName

    tell application "Finder"
      set keynoteContainer to (container of keynotePresentation) as alias
      if not (exists folder documentName of folder keynoteContainer)
        make new folder at keynoteContainer with properties {name:documentName}
      end if
      set the targetFolder to folder documentName of folder keynoteContainer
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
  return POSIX path of keynoteContainer
end run
