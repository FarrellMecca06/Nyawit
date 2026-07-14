/**
 * =================================================================================
 * NYAWIT - TAB: EXPORT
 * =================================================================================
 * One-flag video export. Flip EXPORT_MODE to true, hit Run, and the sketch
 * will save every frame as a numbered PNG into the "export_frames" folder
 * (inside this sketch's data-sibling directory) at a fixed 30fps, then close
 * itself automatically when it reaches the end of the story + a few extra
 * seconds of the looping happy ending.
 *
 * WHY A VIRTUAL CLOCK: normally every scene's timing is driven by millis(),
 * real wall-clock time. Saving a PNG every frame is slow (disk I/O), so the
 * sketch cannot keep up with real time while exporting - if timing stayed
 * tied to millis(), the exported frames would drift out of sync with the
 * separately-rendered audio the longer the export ran. nowMs() (used
 * everywhere millis() used to be called, in scene.pde and characters.pde)
 * fixes this: in export mode it returns frameCount * 1000 / EXPORT_FPS
 * instead of the real clock, so frame N always represents exactly the same
 * moment in the story no matter how slow or fast the actual export runs.
 * That guarantees the exported frames line up exactly with the
 * separately-rendered audio mix.
 *
 * Everything else (audio playback via Minim, live on-screen preview) is
 * skipped in export mode since it is not needed for the image sequence -
 * see the EXPORT_MODE check near the top of setupSound() in sound.pde.
 * =================================================================================
 */

boolean EXPORT_MODE = false;      // <-- flip this to true to export frames, then Run
int EXPORT_FPS = 30;
int EXPORT_TOTAL_MS = 208000;     // full story (3:06) + Ending voiceover (11.8s) + ~10s of the looping happy ending
String EXPORT_FOLDER = "export_frames";

int nowMs() {
  return EXPORT_MODE ? round(frameCount * 1000.0 / EXPORT_FPS) : millis();
}

void handleExport() {
  if (!EXPORT_MODE) return;

  saveFrame(EXPORT_FOLDER + "/frame-######.png");

  if (frameCount % 60 == 0) {
    println("Exporting... " + nowMs() + " / " + EXPORT_TOTAL_MS + " ms (" + frameCount + " frames)");
  }

  if (nowMs() >= EXPORT_TOTAL_MS) {
    println("Export complete: " + frameCount + " frames written to " + EXPORT_FOLDER + "/");
    exit();
  }
}
