beforeEach ->
  this.addMatchers {
    toBePlaying: (expectedSong) ->
      player = this.actual
      player.currentlyPlayingSong == expectedSong && player.isPlaying
    }
