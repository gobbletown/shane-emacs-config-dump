;;; vuiet-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "vuiet" "vuiet.el" (0 0 0 0))
;;; Generated autoloads from vuiet.el

(autoload 'vuiet-artist-info "vuiet" "\
Display info about ARTIST in a new buffer.

p   play all the artist songs, sequentially.
s   select and display info for a similar artist with ivy.
l   visit the artist's lastfm page.

\(fn &optional ARTIST)" t nil)

(autoload 'vuiet-artist-info-search "vuiet" "\
Search ARTIST and display info about the selected item.
Similar to `vuiet-artist-info', but search for ARTIST on last.fm
first and then display the info about it.

\(fn ARTIST)" t nil)

(autoload 'vuiet-tag-info "vuiet" "\
Display info about TAG in a new buffer.

\(fn TAG)" t nil)

(autoload 'vuiet-play "vuiet" "\
Play everyting in the SONGS list, randomly or sequentially.
SONGS is a list of type ((artist1 song1) (artist2 song2) ...).

\(fn SONGS &key (RANDOM nil))" nil nil)

(autoload 'vuiet-play-artist "vuiet" "\
Play the ARTIST top tracks, RANDOM or sequentially.

\(fn &optional ARTIST)" t nil)

(autoload 'vuiet-play-playing-artist "vuiet" "\
Play the currently playing artist's top tracks." t nil)

(autoload 'vuiet-play-album "vuiet" "\
Play the whole ALBUM of the given ARTIST.
If called interactively, the album can be picked interactively
from the ARTIST's top albums, where ARTIST is given in the
minibuffer.

\(fn &optional ARTIST ALBUM)" t nil)

(autoload 'vuiet-play-artist-similar "vuiet" "\
Play tracks from artists similar to ARTISTS.
ARTISTS is a list of strings of the form '(artist1 artist2 etc.)
If called interactively, multiple artists can be provided in the
minibuffer if they are sepparated by commas.

\(fn &optional ARTISTS)" t nil)

(autoload 'vuiet-play-tag-similar "vuiet" "\
Play tracks from artists similar to TAGS.
TAGS is a list of strings of the form '(tag1 tag2 etc.)
If called interactively, multiple tags can be provided in the
minibuffer if they are sepparated by commas.

\(fn TAGS)" t nil)

(autoload 'vuiet-play-track "vuiet" "\
Play the song NAME from the given ARTIST.
If called interactively, let the user select and play one of the
ARTIST's top songs, where ARTIST is given in the minibuffer.

\(fn &optional ARTIST NAME)" t nil)

(autoload 'vuiet-play-track-search "vuiet" "\
Search TRACK and play the selected item.
Similar to `vuiet-play-track', but search for TRACK on last.fm
first and then let the user select one of the results.

\(fn TRACK)" t nil)

(autoload 'vuiet-play-track-by-lyrics "vuiet" "\
Search a track by LYRICS and play it.

\(fn LYRICS)" t nil)

(autoload 'vuiet-play-loved-track "vuiet" "\
Select a track from the user loved tracks and play it.
The user loved tracks list is the one associated with the
username given in the setup of the lastfm.el package." t nil)

(autoload 'vuiet-play-loved-tracks "vuiet" "\
Play all the tracks from the user loved tracks.
If RANDOM is t, play the tracks at random, indefinitely.
The user loved tracks list is the one associated with the
username given in the setup of the lastfm.el package.

\(fn RANDOM)" t nil)

(autoload 'vuiet-play-artist-loved-tracks "vuiet" "\
Play all the ARTIST tracks found in the user loved tracks.
Similar to `vuiet-play-loved-tracks', but play only the tracks
from the given ARTIST.

\(fn &optional ARTIST RANDOM)" t nil)

(autoload 'vuiet-play-recent-track "vuiet" "\
Play one of the recent listened tracks." t nil)

(autoload 'vuiet-play-loved-tracks-similar "vuiet" "\
Play tracks based on artists similar to loved tracks artists.
Play tracks from random artists similar to a random artist from
the list of user loved tracks." t nil)

(register-definition-prefixes "vuiet" '("vuiet-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; vuiet-autoloads.el ends here
