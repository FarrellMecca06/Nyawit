/**
 * =================================================================================
 * NYAWIT - TAB: POLISH
 * =================================================================================
 * Lightweight, purely-additive visual polish layered on top of every scene:
 * a soft vignette, a gentle per-act color grade, faint film-grain sparkle,
 * and a brief opening title card. Nothing here touches scene logic, timing,
 * character/environment drawing, or audio - it only draws a few translucent
 * shapes AFTER a scene has already been rendered, so it is safe to tune or
 * remove independently of everything else.
 * =================================================================================
 */

PImage vignetteImg;
PFont titleFont;
PFont titleSubFont;

void setupPolish() {
  buildVignette();
  titleFont = createFont("Arial Bold", 54);
  titleSubFont = createFont("Arial", 20);
}

void drawCinematicPolish(int t) {
  drawColorGrade(t);
  drawVignette();
  drawFilmGrain();
  drawOpeningTitle(t);
}

// ---------------------------------------------------------------------------------
// PER-ACT COLOR GRADE
// ---------------------------------------------------------------------------------
// A very low-alpha tinted wash over the whole frame - a mood cue, not a
// filter that changes how anything reads. Warm through the living forest,
// cooler/drained through the storm-flood-aftermath stretch of the palm oil
// story, warm and bright again once harmony is restored at the very end.
void drawColorGrade(int t) {
  color grade; float a;
  if (t < PART1_DURATION) {
    grade = color(255, 200, 140); a = 10;
  } else {
    int idx = constrain(10 + (currentScene2 - 4), 10, 21);
    if (idx >= 17 && idx <= 19) { grade = color(120, 140, 160); a = 16; }      // H,I,J: storm / flood / aftermath
    else if (idx == 15 || idx == 16) { grade = color(255, 210, 120); a = 14; } // F,G: scorching monoculture heat
    else if (idx == 21) { grade = color(255, 225, 170); a = 12; }             // Ending: warm and bright
    else { grade = color(255, 220, 180); a = 8; }
  }
  noStroke();
  fill(grade, a);
  rect(0, 0, width, height);
}

// ---------------------------------------------------------------------------------
// VIGNETTE
// ---------------------------------------------------------------------------------
// Built once as a real per-pixel radial gradient (center fully clear, edges
// corners softly darkened) so it draws every frame as a single cheap image()
// blit instead of being recomputed.
void buildVignette() {
  vignetteImg = createImage(width, height, ARGB);
  vignetteImg.loadPixels();
  float cx = width / 2.0, cy = height / 2.0;
  float maxD = dist(0, 0, cx, cy);
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      float d = dist(x, y, cx, cy) / maxD; // ~0 at center -> ~1 at corners
      float a = constrain(map(d, 0.55, 1.05, 0, 130), 0, 130);
      vignetteImg.pixels[y * width + x] = color(0, a);
    }
  }
  vignetteImg.updatePixels();
}

void drawVignette() {
  if (vignetteImg == null) buildVignette();
  image(vignetteImg, 0, 0);
}

// ---------------------------------------------------------------------------------
// FILM GRAIN
// ---------------------------------------------------------------------------------
// A handful of faint, randomly placed specks redrawn every frame - a cheap,
// classic way to take the flatness off a purely vector-drawn scene without
// costing a full-screen noise recompute.
void drawFilmGrain() {
  noStroke();
  for (int g = 0; g < 55; g++) {
    float gx = random(width);
    float gy = random(height);
    float b = random(1) > 0.5 ? 255 : 0;
    fill(b, random(6, 14));
    rect(gx, gy, 1.4, 1.4);
  }
}

// ---------------------------------------------------------------------------------
// OPENING TITLE CARD
// ---------------------------------------------------------------------------------
// Small, upper-third wordmark that fades in/out over the first ~2.6s of the
// whole piece. Kept away from the bottom-of-screen subtitle box on purpose
// so the two never compete for attention.
void drawOpeningTitle(int t) {
  float dur = 2600;
  if (t > dur) return;

  float a;
  if (t < 400) a = map(t, 0, 400, 0, 255);
  else if (t > dur - 700) a = map(t, dur - 700, dur, 255, 0);
  else a = 255;
  a = constrain(a, 0, 255);
  if (a <= 1) return;

  pushStyle();
  textAlign(CENTER, CENTER);
  float cy = height * 0.16;

  textFont(titleFont);
  fill(0, a * 0.35);
  text("NYAWIT", width * 0.5 + 2, cy + 2); // soft drop shadow
  fill(255, a);
  text("NYAWIT", width * 0.5, cy);

  stroke(255, a * 0.8);
  strokeWeight(2);
  line(width * 0.5 - 90, cy + 34, width * 0.5 + 90, cy + 34);
  noStroke();

  textFont(titleSubFont);
  fill(255, a * 0.85);
  text("a story of forest and palm", width * 0.5, cy + 56);
  popStyle();
}
