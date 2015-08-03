set v to ("Volumes" as POSIX file) as alias
tell application "Finder" to set f to (make new folder) as text -- create a temp folder to export images
tell application "Keynote"
  tell front document
    export to (file f) as slide images with properties {image format:JPEG, compression factor:95}
    set {h, w, tName} to {height, width, name of it}
  end tell
  set jpegs to my getImages(f)
  activate
  set newDoc to make new document with properties {width:w, height:h}
  tell newDoc
    set mSlide to last master slide -- blank
    repeat with thisJPEG in jpegs
      set s to make new slide with properties {base slide:mSlide}
      tell s to make new image with properties {file:thisJPEG}
    end repeat
    delete slide 1
    close saving no
  end tell
end tell
tell application "Finder" to delete folder f -- delete the temp folder

on getImages(f)
  tell application "Finder" to return (files of folder f) as alias list
end getImages
