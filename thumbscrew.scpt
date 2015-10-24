-- thumbscrew.scpt
-- usage: thumbscript.scpt <path_to_git_root_dir> <path_to_keynotePresentation>
--
-- Will create scaled thumbnails of length `thumbSize` in the directory
-- <path_to_presentation>
property thumbSize : 480

on getImages(f)
  tell application "Finder" to return (files of folder f) as alias list
end getImages

on run argv
  set savePath to item 1 of argv
  set keynoteName to item 2 of argv
  set thumbnailDir to keynoteName
  if thumbnailDir ends with ".key" then set thumbnailDir to text 1 thru -5 of thumbnailDir

  set keynoteFile to (POSIX file keynoteName) as alias
  set keynoteFullName to savePath & "/" & keynoteName
  set documentPath to posix file (POSIX path of (do shell script "dirname " & quoted form of keynoteFullName)) as alias

  tell application "Finder"
    if not (exists folder thumbnailDir of folder documentPath)
      make new folder at folder documentPath with properties {name:thumbnailDir}
    end if
    set the targetFolder to folder thumbnailDir of folder documentPath
    set the targetFolderHFSPath to targetFolder as string
  end tell

  tell application "Keynote" to run
  tell application "Keynote"
    open keynoteFile

    if playing is true then stop the front document

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

--    close front document without saving
  end tell
end run
