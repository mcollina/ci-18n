
describe "Player", ->
  player = null
  song = null

  beforeEach ->
    player = new Player()
    song = new Song()

  it "should be able to play a Song", ->
    player.play(song)
    expect(player.currentlyPlayingSong).toEqual(song)
    
    expect(player).toBePlaying(song);

