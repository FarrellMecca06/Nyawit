/**
 * =================================================================================
 * NYAWIT - TAB: SOUND
 * =================================================================================
 * Full audio + subtitle engine, built around the real recorded voiceover and
 * sound-effect files. Uses the Minim library (Sketch > Import Library > Add
 * Library... > search "Minim" if it isn't already installed).
 *
 * WHAT THIS TAB DOES, PER FRAME:
 *   1. Figures out which of the 22 scenes (10 in Part 1 + 11 in Part 2 + the
 *      Ending) is currently on screen, using the exact same currentScene /
 *      currentScene2 variables scene.pde already maintains.
 *   2. The moment the scene changes: starts that scene's voiceover clip,
 *      switches the two background layers (ambience/SFX + music) to that
 *      scene's assigned file(s), and fires any one-shot stingers (whoosh,
 *      riser, land-title thud, etc).
 *   3. Every frame: smoothly fades the outgoing scene's ambience/music down
 *      to silence while fading the new scene's bed up (a real crossfade, not
 *      a hard cut), and ducks both layers under the narration while the
 *      voiceover is playing so the words stay clear, un-ducking again once
 *      it finishes.
 *   4. Randomly times distinct thunder cracks (not literally every lightning
 *      flash - that would spam) during the two thunderstorm scenes.
 *   5. Draws a burned-in subtitle box, synced to each scene's REAL voiceover
 *      length (not the padded on-screen scene length), with a soft fade in
 *      and out.
 *
 * DATA FOLDER: every filename referenced below must exist inside this
 * sketch's "data" folder (Minim/Processing load audio relative to data/).
 * The 22 voiceover clips + 11 effect clips supplied are used as-is.
 * =================================================================================
 */

import ddf.minim.*;
import java.util.HashMap;

// ---------------------------------------------------------------------------------
// TUNABLE MIX CONSTANTS
// ---------------------------------------------------------------------------------
float VOICE_GAIN_DB = 0;     // overall narration gain; nudge this if your mic level is quiet/hot
float DUCK_DB        = 8;    // how much ambience drops while narration is speaking
float MUSIC_DUCK_DB   = 14;   // music ducks harder (it now sits much louder at rest, see buildSceneCues())
float FADE_SMOOTHING = 0.045; // per-frame lerp factor for all crossfades/ducking (bigger = snappier)

// ---------------------------------------------------------------------------------
// CORE MINIM STATE
// ---------------------------------------------------------------------------------
Minim minim;
HashMap<String, AudioPlayer> audioBank = new HashMap<String, AudioPlayer>();
AudioPlayer voPlayer;
int lastAudioIdx = -1;
int sceneEnterTime = 0;

// Two independently crossfading beds: A = ambience/nature SFX, B = music.
AmbienceLayer layerA = new AmbienceLayer();
AmbienceLayer layerB = new AmbienceLayer();

// Small round-robin pool so overlapping thunder strikes don't cut each other off.
AudioPlayer[] thunderPool = new AudioPlayer[2];
int thunderNext = 0;
int nextThunderTime = -1;

PFont subtitleFont;
SceneCue[] cues;

// ---------------------------------------------------------------------------------
// SETUP
// ---------------------------------------------------------------------------------
void setupSound() {
  buildSceneCues(); // subtitle text/timing needed even when EXPORT_MODE skips audio below
  subtitleFont = createFont("Arial", 24); // must exist in EXPORT_MODE too - subtitles still render

  if (EXPORT_MODE) return; // frame export doesn't need real audio playback; see export.pde

  minim = new Minim(this);

  String[] voFiles = {
    "1. Sunrise.mp3", "2. Midday.mp3", "3. Dusk.mp3", "4. Night.mp3", "5. Morning Rise.mp3",
    "6. Clouds & Lightining.mp3", "7. Drizzle.mp3", "8. Storm.mp3", "9. Post storm.mp3", "10. Clear day.mp3",
    "A. Arrival of Palm.mp3", "B. The mask slips.mp3", "C. The land title.mp3", "D. Eviction.mp3", "E. The long walk.mp3",
    "F. Monoculture.mp3", "G. The heat.mp3", "H. Storm.mp3", "I. Flood.mp3", "J. The aftermath.mp3", "K. The long back.mp3",
    "Ending.mp3"
  };
  String[] fxFiles = {
    "Dawn bird .mp3",
    "dragon-studio-gentle-rain-07-437321.mp3",
    "freesound_community-birds-19624.mp3",
    "freesound_community-footsteps-dirt-gravel-6823.mp3",
    "goldensoundlabs-dancing-on-moonbeams-cheerful-opening-510264.mp3",
    "liecio-woosh-building-109596.mp3",
    "soft kalimba.mp3",
    "soundreality-rain-sound-550289.mp3",
    "soundreality-riser-the-plane-391179.mp3",
    "storegraphic-soft-wind-leaves-316393.mp3"
  };

  for (String f : voFiles) audioBank.put(f, minim.loadFile(f));
  for (String f : fxFiles) audioBank.put(f, minim.loadFile(f));

  // Thunder gets its own two dedicated instances so strikes can overlap.
  thunderPool[0] = minim.loadFile("universfield-thunder-strike-124463.mp3");
  thunderPool[1] = minim.loadFile("universfield-thunder-strike-124463.mp3");

}

// ---------------------------------------------------------------------------------
// PER-SCENE DATA TABLE
// ---------------------------------------------------------------------------------
// voDurMs is the REAL measured length of the recorded voiceover (used for
// subtitle timing and ducking) - it is intentionally shorter than the
// on-screen scene duration in scene.pde, which adds a short pad after it.
// ambFile/musicFile may be "" to mean "silence on this layer for this scene".
// ambBase/musicBase are the resting volume (dB) for that layer while no one
// is talking; DUCK_DB is subtracted automatically whenever the voiceover is
// playing. Values were chosen after measuring each file's own loudness
// (ffmpeg volumedetect) so nothing clips when boosted and nothing gets lost
// under the narration.
class SceneCue {
  String voFile; int voDurMs; float voGainAdj; String subtitle;
  String ambFile; float ambBase; String musicFile; float musicBase;
  SceneCue(String voFile, int voDurMs, float voGainAdj, String subtitle,
           String ambFile, float ambBase, String musicFile, float musicBase) {
    this.voFile = voFile; this.voDurMs = voDurMs; this.voGainAdj = voGainAdj; this.subtitle = subtitle;
    this.ambFile = ambFile; this.ambBase = ambBase; this.musicFile = musicFile; this.musicBase = musicBase;
  }
}

void buildSceneCues() {
  cues = new SceneCue[22];
  int i = 0;

  // ---- PART 1: THE LIVING FOREST ----
  cues[i++] = new SceneCue("1. Sunrise.mp3", 8660, 0.0,
    "Deep in the forest, morning begins. The trees wake together, roots woven as one.",
    "Dawn bird .mp3", 12, "soft kalimba.mp3", 2);
  cues[i++] = new SceneCue("2. Midday.mp3", 8680, -0.2,
    "Sunlight fills the canopy. Every tree shares the light, the shade, the life.",
    "freesound_community-birds-19624.mp3", 4, "soft kalimba.mp3", 0);
  cues[i++] = new SceneCue("3. Dusk.mp3", 7680, 0.1,
    "A gentle breeze drifts through the leaves. The forest breathes in peace.",
    "storegraphic-soft-wind-leaves-316393.mp3", -10, "soft kalimba.mp3", 1);
  cues[i++] = new SceneCue("4. Night.mp3", 8380, 0.7,
    "Under the stars, the forest rests — safe, together, at peace.",
    "storegraphic-soft-wind-leaves-316393.mp3", -16, "", -60);
  cues[i++] = new SceneCue("5. Morning Rise.mp3", 9320, -0.1,
    "Morning returns. The sun climbs high and pauses — a quiet moment before everything changes.",
    "freesound_community-birds-19624.mp3", 3, "soft kalimba.mp3", 4);
  cues[i++] = new SceneCue("6. Clouds & Lightining.mp3", 7810, -0.1,
    "The sky darkens. Storm clouds gather. Lightning cracks through the air.",
    "storegraphic-soft-wind-leaves-316393.mp3", -8, "", -60);
  cues[i++] = new SceneCue("7. Drizzle.mp3", 7910, 0.3,
    "Rain begins to fall. The trees brace themselves, roots gripping tight.",
    "dragon-studio-gentle-rain-07-437321.mp3", -6, "", -60);
  cues[i++] = new SceneCue("8. Storm.mp3", 7510, 1.1,
    "The storm rages — but the forest holds firm, together.",
    "soundreality-rain-sound-550289.mp3", -6, "", -60);
  cues[i++] = new SceneCue("9. Post storm.mp3", 8510, -0.4,
    "As the storm passes, the forest drinks it in — turning flood into new life.",
    "dragon-studio-gentle-rain-07-437321.mp3", -16, "soft kalimba.mp3", 0);
  cues[i++] = new SceneCue("10. Clear day.mp3", 8660, 0.0,
    "The sun returns. The forest stands taller — stronger for weathering it together.",
    "freesound_community-birds-19624.mp3", 5, "soft kalimba.mp3", 5);

  // ---- PART 2: THE PALM OIL STORY ----
  cues[i++] = new SceneCue("A. Arrival of Palm.mp3", 8320, 0.0,
    "A stranger arrives — an oil palm, all smiles and promises of prosperity.",
    "storegraphic-soft-wind-leaves-316393.mp3", -14, "goldensoundlabs-dancing-on-moonbeams-cheerful-opening-510264.mp3", -1);
  cues[i++] = new SceneCue("B. The mask slips.mp3", 7830, 3.1,
    "But the smile is a mask. In an instant, it turns cold.",
    "", -60, "", -60);
  cues[i++] = new SceneCue("C. The land title.mp3", 8600, 0.1,
    "A document unfolds — a land title. The palm claims the forest's home.",
    "storegraphic-soft-wind-leaves-316393.mp3", -18, "", -60);
  cues[i++] = new SceneCue("D. Eviction.mp3", 8380, 0.1,
    "With no home left, the native trees walk away — leaving everything behind.",
    "freesound_community-footsteps-dirt-gravel-6823.mp3", 4, "", -60);
  cues[i++] = new SceneCue("E. The long walk.mp3", 8810, -0.7,
    "Exhausted and displaced, they press on — searching for somewhere new to belong.",
    "freesound_community-footsteps-dirt-gravel-6823.mp3", 2, "", -60);
  cues[i++] = new SceneCue("F. Monoculture.mp3", 10450, -0.5,
    "In their place: endless rows of identical palms. No shade. No shelter. Only silence.",
    "storegraphic-soft-wind-leaves-316393.mp3", -22, "", -60);
  cues[i++] = new SceneCue("G. The heat.mp3", 7530, -0.5,
    "Without the forest's canopy, the land bakes under a relentless sun.",
    "storegraphic-soft-wind-leaves-316393.mp3", -20, "", -60);
  cues[i++] = new SceneCue("H. Storm.mp3", 8730, -0.2,
    "The sky darkens again. But here, there's no canopy — the rain strikes bare earth.",
    "soundreality-rain-sound-550289.mp3", -5, "", -60);
  cues[i++] = new SceneCue("I. Flood.mp3", 8550, -0.2,
    "With no roots to hold it, the ground gives way. A flash flood tears through.",
    "soundreality-rain-sound-550289.mp3", -4, "", -60);
  cues[i++] = new SceneCue("J. The aftermath.mp3", 8600, 0.0,
    "When the water recedes, only ruin remains — cracked earth, fallen trees.",
    "storegraphic-soft-wind-leaves-316393.mp3", -24, "", -60);
  cues[i++] = new SceneCue("K. The long back.mp3", 8620, -0.3,
    "A few surviving palms return to the forest — heads bowed, seeking forgiveness.",
    "freesound_community-footsteps-dirt-gravel-6823.mp3", 0, "soft kalimba.mp3", 1);

  // ---- ENDING (loops forever; voiceover plays once, ambience/music keep looping) ----
  cues[i++] = new SceneCue("Ending.mp3", 11800, -0.6,
    "This time, they're welcomed. Roots intertwine once more — proof that together, everyone thrives.",
    "freesound_community-birds-19624.mp3", 5, "soft kalimba.mp3", 6);
}

// ---------------------------------------------------------------------------------
// MAIN PER-FRAME ENTRY POINT (called once from draw() in scene.pde)
// ---------------------------------------------------------------------------------
void updateAudioAndSubtitles(int t) {
  int idx;
  if (t < PART1_DURATION) {
    idx = constrain(currentScene - 1, 0, 9);
  } else {
    idx = constrain(10 + (currentScene2 - 4), 10, 21);
  }

  SceneCue c = cues[idx];

  if (idx != lastAudioIdx) {
    lastAudioIdx = idx;
    sceneEnterTime = t;

    // --- start this scene's narration ---
    if (voPlayer != null) voPlayer.pause();
    voPlayer = audioBank.get(c.voFile);
    if (voPlayer != null) {
      voPlayer.rewind();
      voPlayer.setGain(VOICE_GAIN_DB + c.voGainAdj);
      voPlayer.play();
    }

    // --- switch the two background beds (crossfade handled in update()) ---
    layerA.setTarget(c.ambFile);
    layerB.setTarget(c.musicFile);

    // --- one-shot stingers tied to specific scenes ---
    triggerOneShots(idx, t);
  }

  boolean voPlaying = (voPlayer != null && voPlayer.isPlaying());
  float ambDuck = voPlaying ? DUCK_DB : 0;
  float musicDuck = voPlaying ? MUSIC_DUCK_DB : 0;
  layerA.currentTarget = (c.ambFile.length() > 0) ? (c.ambBase - ambDuck) : -60;
  layerB.currentTarget = (c.musicFile.length() > 0) ? (c.musicBase - musicDuck) : -60;
  layerA.update(FADE_SMOOTHING);
  layerB.update(FADE_SMOOTHING);

  updateThunder(idx, t);

  drawSubtitleOverlay(c, t - sceneEnterTime);
}

// ---------------------------------------------------------------------------------
// CROSSFADING BACKGROUND LAYER
// ---------------------------------------------------------------------------------
// Holds up to two AudioPlayers at once: "current" (fading up to its target)
// and "previous" (the last scene's bed, fading down to silence). Every frame
// currentApplied/previousApplied creep toward their targets via lerp(), which
// gives a smooth, professional-sounding crossfade + ducking instead of a
// hard cut - the same mechanism handles both scene transitions and narration
// ducking, since both are just "move the gain toward a target smoothly".
class AmbienceLayer {
  AudioPlayer current;
  AudioPlayer previous;
  float currentApplied = -60;
  float previousApplied = -60;
  float currentTarget = -60;
  String currentFile = "";

  void setTarget(String file) {
    if (file == null) file = "";
    if (file.equals(currentFile)) return; // same file already playing -> let it continue, no restart
    if (previous != null) previous.pause();
    previous = current;
    previousApplied = currentApplied;
    currentFile = file;
    if (file.length() > 0) {
      current = audioBank.get(file);
      if (current != null) { current.rewind(); current.loop(); }
      currentApplied = -60; // fades up from silence via update()
    } else {
      current = null;
      currentApplied = -60;
    }
  }

  void update(float smoothing) {
    currentApplied = lerp(currentApplied, currentTarget, smoothing);
    if (current != null) current.setGain(constrain(currentApplied, -60, 16));
    if (previous != null) {
      previousApplied = lerp(previousApplied, -60, smoothing);
      if (previousApplied <= -58) {
        previous.pause();
        previous = null;
      } else {
        previous.setGain(constrain(previousApplied, -60, 16));
      }
    }
  }
}

// ---------------------------------------------------------------------------------
// ONE-SHOT STINGERS + THUNDER
// ---------------------------------------------------------------------------------
void triggerOneShots(int idx, int t) {
  // idx: 11 = B. The Mask Slips, 17 = H. Storm Over the Plantation, 18 = I. Flash Flood
  if (idx == 11 || idx == 17) playOneShot("liecio-woosh-building-109596.mp3", -2);
  if (idx == 18) playOneShot("soundreality-riser-the-plane-391179.mp3", -4);

  // idx: 5 = Scene 6 Clouds & Lightning, 7 = Scene 8 Storm, 17 = H Storm Over Plantation
  if (idx == 5 || idx == 7 || idx == 17) {
    nextThunderTime = t + int(random(400, 1400)); // first distant strike shortly after scene starts
  } else {
    nextThunderTime = -1;
  }
}

void playOneShot(String file, float gainDb) {
  AudioPlayer p = audioBank.get(file);
  if (p != null) {
    p.rewind();
    p.setGain(gainDb);
    p.play();
  }
}

void updateThunder(int idx, int t) {
  boolean stormy = (idx == 5 || idx == 7 || idx == 17);
  if (!stormy || nextThunderTime < 0) return;
  if (t >= nextThunderTime) {
    AudioPlayer p = thunderPool[thunderNext];
    thunderNext = (thunderNext + 1) % thunderPool.length;
    if (p != null) {
      int maxStart = max(1, p.length() - 2500);
      p.cue(int(random(0, maxStart)));
      p.setGain(random(-6, -2));
      p.play();
    }
    nextThunderTime = t + int(random(2200, 4200)); // occasional distinct cracks, not spammed every frame
  }
}

// ---------------------------------------------------------------------------------
// SUBTITLES
// ---------------------------------------------------------------------------------
void drawSubtitleOverlay(SceneCue c, int localElapsedMs) {
  float fadeIn = 300, fadeOut = 400;
  float endT = c.voDurMs; // caption tracks the REAL voiceover length, not the padded scene length
  float alpha;
  if (localElapsedMs < fadeIn) {
    alpha = map(localElapsedMs, 0, fadeIn, 0, 255);
  } else if (localElapsedMs > endT - fadeOut) {
    alpha = map(localElapsedMs, endT - fadeOut, endT, 255, 0);
  } else {
    alpha = 255;
  }
  if (localElapsedMs > endT) alpha = 0;
  alpha = constrain(alpha, 0, 255);
  if (alpha <= 1) return;

  textFont(subtitleFont);
  textSize(24);
  textAlign(CENTER, CENTER);
  float maxW = width * 0.82;
  ArrayList<String> lines = wrapSubtitle(c.subtitle, maxW);
  float lineH = 30;
  float boxH = lines.size() * lineH + 22;
  float boxY = height - boxH - 26;

  pushStyle();
  rectMode(CORNER);
  noStroke();
  fill(0, alpha * 0.62);
  rect(width * 0.5 - maxW / 2 - 18, boxY, maxW + 36, boxH, 10);
  fill(255, alpha);
  for (int li = 0; li < lines.size(); li++) {
    text(lines.get(li), width * 0.5, boxY + 11 + li * lineH + lineH / 2);
  }
  popStyle();
}

ArrayList<String> wrapSubtitle(String s, float maxW) {
  ArrayList<String> out = new ArrayList<String>();
  String[] words = split(s, ' ');
  String line = "";
  for (String w : words) {
    String test = (line.length() == 0) ? w : line + " " + w;
    if (textWidth(test) > maxW && line.length() > 0) {
      out.add(line);
      line = w;
    } else {
      line = test;
    }
  }
  if (line.length() > 0) out.add(line);
  return out;
}

// ---------------------------------------------------------------------------------
// CLEANUP
// ---------------------------------------------------------------------------------
void stop() {
  for (AudioPlayer p : audioBank.values()) if (p != null) p.close();
  for (AudioPlayer p : thunderPool) if (p != null) p.close();
  if (minim != null) minim.stop();
  super.stop();
}
