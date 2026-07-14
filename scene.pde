/**
 * =================================================================================
 * NYAWIT - TAB: SCENE
 * =================================================================================
 * Tab ini adalah "pengatur" utama animasi: berisi setup()/draw() global,
 * orkestrasi Bagian 1 <-> Bagian 2, seluruh variabel waktu/scene, serta
 * setup()/draw() untuk tiap scene (Part1, Part2, scene 4-13, Ending), yang
 * di dalamnya memanggil fungsi-fungsi dari tab environment.pde dan
 * meng-update/menggambar objek-objek dari tab characters.pde.
 *
 * File ini adalah bagian dari sketch "nyawit" yang dipecah menjadi 4 tab:
 * characters.pde, environment.pde, sound.pde, scene.pde
 * Tidak ada isi/logika yang diubah dari file aslinya (nyawit.pde) - hanya
 * dipindahkan apa adanya ke tab ini.
 *
 * CARA PAKAI DI PROCESSING:
 * Letakkan KEEMPAT file (characters.pde, environment.pde, sound.pde, scene.pde)
 * di dalam SATU folder. Karena Processing mengharuskan nama file tab utama
 * sama dengan nama foldernya, beri nama folder tersebut "scene" (atau ganti
 * nama scene.pde -> nama_folder.pde). File-file lain boleh bernama apa saja
 * dan akan otomatis muncul sebagai tab tambahan saat sketch dibuka.
 * =================================================================================
 */

/**
 * =================================================================================
 * ANIMASI GABUNGAN "NYAWIT" - PROJECT LENGKAP (2 BAGIAN, PLAY OTOMATIS)
 * =================================================================================
 * File ini menggabungkan dua animasi terpisah (gabungan.pde + gabungan2.pde)
 * menjadi SATU sketch Processing yang berjalan berurutan secara otomatis,
 * tanpa perlu menekan tombol apa pun.
 *
 * BAGIAN 1 - Siklus Cuaca Sehari (dari file "gabungan.pde", Scene 1-10):
 *   [DIPERLAMBAT ~40% + ditambah jeda matahari di puncak sebelum Scene 6]
 *   1. Terbit (0-7s)               6. Mendung & Petir (37-44s)
 *   2. Siang (7-14s)               7. Gerimis (44-51s)
 *   3. Senja (14-21s)              8. Badai (51-58s)
 *   4. Malam (21-28s)              9. Pasca-Badai / Penyerapan Air (58-65s)
 *   5. Pagi, matahari naik lalu    10. Kembali Siang Cerah (65-72s, lalu lanjut Bagian 2)
 *      berhenti sejenak di puncak
 *      (28-37s, jeda 2s di puncak)
 *
 * BAGIAN 2 - Kisah Kedatangan Sawit hingga Pasca Bencana (dari "gabungan2.pde", Scene 4-15):
 *   Scene 4  : Kedatangan Keluarga Sawit (Penyambutan Ramah)
 *   Scene 5  : Perubahan Sikap Sawit & Keterkejutan Hutan
 *   Scene 6  : Close-Up Sertifikat Lahan
 *   Scene 7  : (lanjutan alur cerita sawit)
 *   Scene 8  : (lanjutan alur cerita sawit - migrasi/penggusuran hutan)
 *   Scene 9A : Dominasi Monokultur di Bawah Terik Matahari Biasa
 *   Scene 9B : Dominasi Monokultur & Panas Menyengat
 *   Scene 10 : Perubahan Cuaca Ekstrem (Mendung, Petir, Banjir Tinggi)
 *   Scene 11 : Arus Deras, Tanah Longsor & Sawit Hanyut
 *   Scene 12 : Pasca Bencana - Air Mengering, Tanah Pecah, Sawit Mati & Selamat
 *   Scene 13 : Sawit yang Selamat Kembali ke Hutan & Meminta Maaf (arah menunduk
 *              hormat sudah diperbaiki agar mengarah ke hutan, bukan menjauhinya)
 *   Scene 14 : (BARU) Penutup - Seluruh Pohon & Sawit Hidup Berdampingan, Bahagia,
 *              Melompat Kegirangan di Bawah Matahari Cerah, Dikelilingi Bunga Kecil
 *
 * CATATAN TEKNIS PENGGABUNGAN (tidak ada logika/visual dari kode LAMA yang diubah,
 * hanya penyesuaian teknis wajib agar dua sketch bisa hidup dalam satu file
 * Java/Processing, ditambah kode BARU untuk transisi, Scene 13, dan Scene Penutup):
 *   1. Processing hanya boleh punya SATU fungsi setup() dan SATU fungsi draw().
 *      Maka setup()/draw() milik Bagian 1 diganti nama menjadi setupPart1()/drawPart1(),
 *      dan setup()/draw() milik Bagian 2 diganti nama menjadi setupPart2()/drawPart2().
 *      Isi di dalamnya PERSIS SAMA seperti file asli.
 *   2. Kedua file sama-sama punya variabel global "currentScene". Karena tidak boleh
 *      ada dua variabel global dengan nama sama, variabel "currentScene" milik Bagian 2
 *      diganti nama menjadi "currentScene2" di semua pemakaiannya. Variabel "currentScene"
 *      milik Bagian 1 dibiarkan apa adanya.
 *   3. size(1280, 720) dan smooth() masing-masing hanya dipanggil SEKALI di setup()
 *      gabungan ini (dipanggil dua kali akan menyebabkan error di Processing).
 *   4. Ditambahkan kode "orkestrasi" di bawah ini (PART1_DURATION, TRANSITION_DURATION,
 *      part2Initialized) untuk mengatur kapan Bagian 1 berhenti dan Bagian 2 mulai,
 *      LENGKAP DENGAN EFEK FADE HITAM supaya perpindahan Bagian 1 -> Bagian 2 tidak
 *      terasa tiba-tiba/patah. Juga memastikan penghitung waktu Bagian 2 (sceneStartTime)
 *      mulai dari 0 tepat saat Bagian 2 dimulai, supaya Scene 4 tidak "terlompat".
 *      PART1_DURATION disesuaikan menjadi 72000ms mengikuti perlambatan Bagian 1.
 *   5. Batas maksimum scene di Bagian 2 diperluas dari 14 menjadi 15 (targetMaxScene),
 *      untuk menampung Scene Penutup (BARU) yang menampilkan seluruh pohon & sawit
 *      hidup berdampingan dengan bahagia. Karena scene ini scene TERAKHIR, ia tidak
 *      pernah fade-out lagi sehingga animasi bahagia ini terus berulang selamanya.
 * =================================================================================
 */


// ---------------------------------------------------------------------------------
// ORKESTRASI PENGGABUNGAN: kapan Bagian 1 selesai, Bagian 2 mulai, & transisi fade
// ---------------------------------------------------------------------------------
// Bagian 1 tuntas di Scene 10 pada detik ke-45 (tSiangCerah), lalu dibiarkan
// "diam" 5 detik ekstra di Scene 10 (siang cerah) sebagai jeda napas cerita,
// sebelum otomatis lanjut ke Bagian 2 (Scene 4: kedatangan keluarga sawit).
int PART1_DURATION = 87300;       // total durasi Bagian 1 sebelum pindah ke Bagian 2 (dalam ms)
                                   // NOTE: retimed to match real recorded voiceover lengths (see sound.pde)
int TRANSITION_DURATION = 1000;   // durasi fade hitam antara Bagian 1 & Bagian 2 (1 detik fade-out + 1 detik fade-in)
boolean part2Initialized = false; // penanda agar sceneStartTime Bagian 2 direset tepat saat Bagian 2 dimulai

void setup() {
  size(1280, 720);
  smooth(4);
  if (EXPORT_MODE) frameRate(1000); // uncapped: virtual clock keeps timing correct regardless of real speed
  setupPart1();
  setupPart2();
  setupSound();
  setupPolish();
}

void draw() {
  int t = nowMs();

  if (t < PART1_DURATION) {
    // ----- BAGIAN 1 sedang berjalan -----
    drawPart1();

    // Fade perlahan ke hitam menjelang akhir Bagian 1, supaya tidak terasa mendadak
    if (t > PART1_DURATION - TRANSITION_DURATION) {
      float fadeOutAlpha = map(t, PART1_DURATION - TRANSITION_DURATION, PART1_DURATION, 0, 255);
      noStroke();
      fill(0, fadeOutAlpha);
      rect(0, 0, width, height);
    }
  } else {
    // ----- Saatnya pindah ke / melanjutkan BAGIAN 2 -----
    if (!part2Initialized) {
      sceneStartTime = t; // reset agar Scene 4 Bagian 2 mulai dari awal, bukan langsung lompat scene
      part2Initialized = true;
    }
    drawPart2();

    // Fade dari hitam kembali normal di awal Bagian 2, melengkapi efek fade-out di atas
    if (t < PART1_DURATION + TRANSITION_DURATION) {
      float fadeInAlpha = map(t, PART1_DURATION, PART1_DURATION + TRANSITION_DURATION, 255, 0);
      noStroke();
      fill(0, fadeInAlpha);
      rect(0, 0, width, height);
    }
  }

  // Lightweight cinematic polish (vignette, per-act color grade, grain,
  // opening title card) - purely additive, see polish.pde. Drawn before
  // subtitles so the caption box + text stay crisp on top of it.
  drawCinematicPolish(t);

  // Voiceover playback, ambience/music crossfades, ducking, and burned-in
  // subtitles are all driven from here (see sound.pde). Runs every frame,
  // on top of everything else so captions stay visible through fades.
  updateAudioAndSubtitles(t);

  // Frame export (see export.pde) - does nothing unless EXPORT_MODE is on.
  handleExport();
}


// ===================================================================================
// BAGIAN 1 — diambil dari file "gabungan.pde" (Scene 1-10: siklus cuaca sehari)
// ===================================================================================

/**
 * Project Animasi "Nyawit" - LENGKAP 10 SCENE UTUH
 * Alur Waktu: 
 * 1. Terbit (0-5s) -> 2. Siang (5-10s) -> 3. Senja (10-15s) -> 4. Malam (15-20s) ->
 * 5. Pagi (20-25s) -> 6. Mendung & Petir (25-30s) -> 7. Gerimis (30-35s) -> 8. Badai (35-40s) ->
 * 9. Pasca-Badai / Penyerapan Air (40-45s) -> 10. Kembali Siang Cerah (45s+)
 */

int currentScene = 1; 

// Pengaturan Durasi (dalam milidetik)
// CATATAN: Bagian 1 diperlambat (setiap babak diperpanjang ~40%, dari 5000ms
// menjadi 7000ms) supaya alurnya lebih santai. Selain itu, sebelum masuk ke
// Scene 6 (Mendung & Petir), ditambahkan jeda khusus "tPagiRise -> tPagi" agar
// matahari benar-benar naik sampai titik puncak (zenith) lalu berhenti sejenak
// (diam di puncak selama tPeakPause ms) sebelum langit berubah mendung.
// RETIMED (was fixed 7000/9000ms blocks) so each weather-scene's on-screen
// duration matches its real recorded voiceover length + a ~400ms tail pad.
// See sound.pde -> buildSceneCues() for the source-of-truth VO durations.
int tTerbit      = 9100;                   // Scene 1 Sunrise      (VO 8.66s)
int tSiang       = tTerbit + 9100;         // Scene 2 Midday       (VO 8.68s) -> 18200
int tSenja       = tSiang + 8100;          // Scene 3 Dusk         (VO 7.68s) -> 26300
int tMalam       = tSenja + 8800;          // Scene 4 Night        (VO 8.38s) -> 35100
int tPagiRise    = tMalam + 7800;          // matahari selesai naik dan tepat berada di titik puncak -> 42900
int tPeakPause   = 2000;                   // durasi jeda matahari diam di puncak sebelum mendung
int tPagi        = tPagiRise + tPeakPause; // akhir Scene 5 Morning Rise (VO 9.32s) -> 44900
int tMendung     = tPagi + 8200;           // Scene 6 Clouds & Lightning (VO 7.81s) -> 53100
int tGerimis     = tMendung + 8300;        // Scene 7 Drizzle      (VO 7.91s) -> 61400
int tBadaiSelesai = tGerimis + 7900;       // Scene 8 Storm        (VO 7.51s) -> 69300
int tSiangCerah  = tBadaiSelesai + 8900;   // Scene 9 Post-Storm   (VO 8.51s) -> 78200, Menuju Scene 10

ArrayList<NativeTree> forestTrees = new ArrayList<NativeTree>();
OldBanyan wiseBanyan;
ArrayList<WindLeaf> breezeParticles = new ArrayList<WindLeaf>();
ArrayList<RainDrop> rainParticles = new ArrayList<RainDrop>();

// Variabel Khusus Scene 9 (Pasca-Badai)
ArrayList<WaterParticle> absorbParticles = new ArrayList<WaterParticle>();
ArrayList<Puddle> waterPuddles = new ArrayList<Puddle>();

// Variabel Bintang
float[] starX = new float[120];
float[] starY = new float[120];
float[] starSize = new float[120];

float groundLevel = 520; 

void setupPart1() {
  wiseBanyan = new OldBanyan(width * 0.75, groundLevel, 1.35);
  
  int totalTrees = 8;
  for (int i = 0; i < totalTrees; i++) {
    float x = map(i, 0, totalTrees - 1, width * 0.1, width * 0.65) + random(-30, 30);
    float scale = random(0.8, 1.2);
    color leafBaseColor = color(random(35, 55), random(120, 165), random(50, 75));
    forestTrees.add(new NativeTree(x, groundLevel, scale, leafBaseColor));
  }
  
  for (int i = 0; i < 25; i++) breezeParticles.add(new WindLeaf());
  for (int i = 0; i < 180; i++) rainParticles.add(new RainDrop());
  
  for (int i = 0; i < starX.length; i++) {
    starX[i] = random(width);
    starY[i] = random(groundLevel - 50);
    starSize[i] = random(1, 3.5);
  }

  // Inisialisasi Genangan Air (Scene 9)
  waterPuddles.add(new Puddle(width * 0.15, groundLevel, 180));
  waterPuddles.add(new Puddle(width * 0.40, groundLevel, 250));
  waterPuddles.add(new Puddle(width * 0.60, groundLevel, 150));
  waterPuddles.add(new Puddle(width * 0.80, groundLevel, 220)); 
  
  // Inisialisasi Partikel Penyerapan Air (Scene 9)
  for (int i = 0; i < 60; i++) {
    absorbParticles.add(new WaterParticle());
  }
}

void drawPart1() {
  // LOGIKA WAKTU 10 BABAK
  int t = nowMs();
  if      (t < tTerbit)        currentScene = 1;
  else if (t < tSiang)         currentScene = 2;
  else if (t < tSenja)         currentScene = 3;
  else if (t < tMalam)         currentScene = 4;
  else if (t < tPagi)          currentScene = 5;
  else if (t < tMendung)       currentScene = 6;
  else if (t < tGerimis)       currentScene = 7;
  else if (t < tBadaiSelesai)  currentScene = 8;
  else if (t < tSiangCerah)    currentScene = 9;
  else                         currentScene = 10;

  // RENDER ATMOSFER (Langit, Matahari, Bukit)
  if (currentScene == 10) {
    drawAtmosphere(2, t); // Gunakan visual atmosfer siang (Scene 2)
    drawUndergroundBase(2);
  } else if (currentScene == 9) {
    drawAtmosphereScene3(); // Visual pasca-badai berkas cahaya raksasa
    drawClearingClouds();
    drawUndergroundBaseScene3();
    
    // Tampilkan genangan & partikel penyerapan air
    for (Puddle p : waterPuddles) {
      p.display();
    }
    for (WaterParticle p : absorbParticles) {
      p.update();
      p.display();
    }
  } else {
    drawAtmosphere(currentScene, t);
    if (currentScene == 4) drawStars(); 
    if (currentScene >= 6) drawStormClouds(currentScene); 
    if (currentScene == 6 && random(100) < 2.5) drawLightning(); 
    if (currentScene == 8 && random(100) < 1.0) drawLightning();
    drawUndergroundBase(currentScene);
  }

  // Daun beterbangan di cuaca cerah/normal (1, 2, 3, 5, dan 10)
  if (currentScene == 1 || currentScene == 2 || currentScene == 3 || currentScene == 5 || currentScene == 10) {
    for (WindLeaf leaf : breezeParticles) {
      leaf.update();
      leaf.display();
    }
  }

  // Render Pohon
  for (NativeTree tree : forestTrees) {
    tree.update();
    tree.display();
  }
  wiseBanyan.update();
  wiseBanyan.display();

  // Hujan di scene 7 dan 8
  if (currentScene == 7 || currentScene == 8) {
    int dropCount = (currentScene == 7) ? rainParticles.size() / 3 : rainParticles.size();
    for (int i = 0; i < dropCount; i++) {
      RainDrop drop = rainParticles.get(i);
      drop.update(currentScene);
      drop.display(currentScene);
    }
  }
}

// ===================================================================================
// BAGIAN 2 — diambil dari file "gabungan2.pde" (Scene 4-13: kisah kedatangan sawit
// hingga pasca bencana)
// ===================================================================================

// ==========================================
// PENGATURAN TRANSISI & WAKTU SCENE
// ==========================================
// RETIMED: sceneDuration used to be a fixed 10000ms for every Part 2 scene.
// Real recorded voiceovers vary per scene (7.5s-10.5s), so sceneDuration is now
// looked up per-scene from part2Durations[] (see getPart2Duration() below) and
// reassigned every frame in drawPart2(). Every other function that reads the
// global `sceneDuration` (progress calcs in environment.pde/characters.pde,
// the transition fade math right below) keeps working unmodified.
int sceneDuration = 10000;
int transitionDuration = 800;   // Durasi efek fade transisi (0.8 detik)
int currentScene2 = 4;           // Memulai dari Scene 4
int sceneStartTime = 0;         // Waktu mulai untuk scene saat ini
int sceneTime = 0;              // Waktu relatif yang berjalan di dalam satu scene

// Scene 4..14 (A..K) durations in ms = real VO length + ~400ms pad.
// Scene 15 (Ending) is not in this array: it loops forever and never
// force-advances, so its duration is irrelevant to the scene-advance logic.
int[] part2Durations = {
  8700,  // A. Arrival of the Palm Family (VO 8.32s)
  8200,  // B. The Mask Slips             (VO 7.83s)
  9000,  // C. The Land Title             (VO 8.60s)
  8800,  // D. The Eviction Begins        (VO 8.38s)
  9200,  // E. The Long Walk              (VO 8.81s)
  10900, // F. Monoculture Under the Sun  (VO 10.45s)
  7900,  // G. The Heat Intensifies       (VO 7.53s)
  9100,  // H. Storm Over the Plantation  (VO 8.73s)
  9000,  // I. Flash Flood & Landslide    (VO 8.55s)
  9000,  // J. The Aftermath              (VO 8.60s)
  9000   // K. The Long Way Back          (VO 8.62s)
};

int getPart2Duration(int scene2) {
  int idx = scene2 - 4;
  if (idx >= 0 && idx < part2Durations.length) return part2Durations[idx];
  return 999999999; // Scene 15 (Ending) or out of range: never force-advance
}

void setupPart2() {
  // Inisialisasi seluruh objek dari masing-masing scene
  setup4();
  setup5();
  setup6();
  setup7();
  setup8();
  setup9A();
  setup9B();
  setup10();
  setup11(); 
  setup12();
  setup13(); // SCENE BARU: sawit yang selamat kembali ke hutan & meminta maaf
  setupEnding(); // SCENE BARU (PENUTUP): seluruh pohon & sawit hidup berdampingan, bahagia
}

void drawPart2() {
  int t = nowMs();
  sceneTime = t - sceneStartTime;
  sceneDuration = getPart2Duration(currentScene2); // retimed: per-scene duration, see above

  // Batas scene tertinggi kini 15 (sebelumnya 14), karena ditambahkan Scene 15
  // (BARU) sebagai penutup: seluruh pohon & sawit hidup berdampingan dengan bahagia.
  int targetMaxScene = 15;

  // Logika perpindahan scene otomatis (kini sampai Scene 15)
  // Catatan: baris "if (currentScene2 < 12) ... lalu currentScene2==12 -> 13" pada versi
  // sebelumnya disederhanakan jadi satu kondisi saja, supaya Scene 13 & Scene 15 (baru)
  // ikut terangkai otomatis tanpa perlu blok tambahan lagi.
  if (sceneTime >= sceneDuration) {
    if (currentScene2 < targetMaxScene) {
      currentScene2++;
      sceneStartTime = t;
      sceneTime = 0;
      sceneDuration = getPart2Duration(currentScene2); // refresh for the scene we just entered
    }
  }
  
  // Merender Scene berdasarkan urutannya
  if (currentScene2 == 4) draw4();
  else if (currentScene2 == 5) draw5();
  else if (currentScene2 == 6) draw6();
  else if (currentScene2 == 7) draw7();
  else if (currentScene2 == 8) draw8();
  else if (currentScene2 == 9) draw9A();
  else if (currentScene2 == 10) draw9B();
  else if (currentScene2 == 11) draw10();
  else if (currentScene2 == 12) draw11();
  else if (currentScene2 == 13) draw12();
  else if (currentScene2 == 14) draw13(); // SCENE BARU: kembali ke hutan & meminta maaf
  else if (currentScene2 == 15) drawEnding(); // SCENE BARU (PENUTUP): bahagia & berdampingan
  
  // ==========================================
  // EFEK TRANSISI FADE IN & FADE OUT (MULUS)
  // ==========================================
  int alpha = 0;
  if (sceneTime < transitionDuration && currentScene2 > 4) {
    alpha = (int) map(sceneTime, 0, transitionDuration, 255, 0);
  } else if (sceneTime > sceneDuration - transitionDuration && currentScene2 < targetMaxScene) {
    alpha = (int) map(sceneTime, sceneDuration - transitionDuration, sceneDuration, 0, 255);
  }
  
  if (alpha > 0) {
    fill(0, alpha);
    noStroke();
    rect(0, 0, width, height);
  }
}

// =================================================================================
// SCENE 4: Kedatangan Keluarga Sawit (Penyambutan Ramah)
// =================================================================================
ArrayList<NativeTree4> forestTrees4 = new ArrayList<NativeTree4>();
ArrayList<PalmTree4> palmFamily4 = new ArrayList<PalmTree4>();
OldBanyan4 wiseBanyan4;
float groundLevel4 = 520;

void setup4() {
  wiseBanyan4 = new OldBanyan4(width * 0.25, groundLevel4, 1.3);
  int totalNative = 4;
  for (int i = 0; i < totalNative; i++) {
    float x = map(i, 0, totalNative - 1, width * 0.05, width * 0.45);
    if (abs(x - wiseBanyan4.x) < 80) x += 100;
    float scale = random(0.85, 1.1);
    color leafBaseColor = color(random(40, 60), random(140, 180), random(60, 90));
    forestTrees4.add(new NativeTree4(x, groundLevel4, scale, leafBaseColor));
  }
  int totalPalms = 3;
  for (int i = 0; i < totalPalms; i++) {
    float x = map(i, 0, totalPalms - 1, width * 0.65, width * 0.95);
    float scale = random(0.9, 1.05);
    palmFamily4.add(new PalmTree4(x, groundLevel4 + 15, scale));
  }
}

void draw4() {
  drawAtmosphere4();     
  drawUndergroundBase4(); 
  for (NativeTree4 tree : forestTrees4) tree.display();
  wiseBanyan4.display();
  for (PalmTree4 palm : palmFamily4) palm.display();
}

// =================================================================================
// SCENE 5: Perubahan Sikap Sawit & Keterkejutan Hutan
// =================================================================================
ArrayList<NativeTree5> forestTrees5 = new ArrayList<NativeTree5>();
ArrayList<PalmTree5> palmFamily5 = new ArrayList<PalmTree5>();
OldBanyan5 wiseBanyan5;
float groundLevel5 = 520;

void setup5() {
  wiseBanyan5 = new OldBanyan5(width * 0.25, groundLevel5, 1.3);
  int totalNative = 4;
  for (int i = 0; i < totalNative; i++) {
    float x = map(i, 0, totalNative - 1, width * 0.05, width * 0.45);
    if (abs(x - wiseBanyan5.x) < 80) x += 100; 
    float scale = random(0.85, 1.1);
    color leafBaseColor = color(random(40, 60), random(140, 180), random(60, 90));
    forestTrees5.add(new NativeTree5(x, groundLevel5, scale, leafBaseColor));
  }
  int totalPalms = 3;
  for (int i = 0; i < totalPalms; i++) {
    float x = map(i, 0, totalPalms - 1, width * 0.65, width * 0.95);
    float scale = random(0.9, 1.05);
    boolean holdsDeed = (i == 0); 
    palmFamily5.add(new PalmTree5(x, groundLevel5 + 15, scale, holdsDeed));
  }
}

void draw5() {
  drawAtmosphere5();      
  drawUndergroundBase5(); 
  for (NativeTree5 tree : forestTrees5) tree.display();
  wiseBanyan5.display();
  for (PalmTree5 palm : palmFamily5) palm.display();
}

// =================================================================================
// SCENE 6: Close-Up Sertifikat Lahan
// =================================================================================
ArrayList<PalmTree6> palmFamily6 = new ArrayList<PalmTree6>();
float groundLevel6 = 520;
float docX6, docY6, docW6, docH6;

void setup6() {
  docW6 = 440; docH6 = 580; docX6 = width / 2; docY6 = height / 2 - 20;
  int totalPalms = 3;
  for (int i = 0; i < totalPalms; i++) {
    float x = map(i, 0, totalPalms - 1, width * 0.65, width * 0.95);
    float scale = random(0.9, 1.05);
    palmFamily6.add(new PalmTree6(x, groundLevel6 + 15, scale));
  }
}

void draw6() {
  drawAtmosphere6();     
  drawUndergroundBase6();
  for (PalmTree6 palm : palmFamily6) palm.display();
  fill(0, 40); noStroke(); rect(0, 0, width, height);
  drawCloseUpCertificate6(docX6, docY6, docW6, docH6);
}

// =================================================================================
// SCENE 7: Pengusiran & Migrasi Pohon Asli
// =================================================================================
ArrayList<MigratingTree7> nativeRefugees7 = new ArrayList<MigratingTree7>();
ArrayList<StaticPalm7> oppressingPalms7 = new ArrayList<StaticPalm7>();
MigratingBanyan7 wiseBanyanLeader7;

void setup7() {
  wiseBanyanLeader7 = new MigratingBanyan7(width * 0.2, 360, 1.2, 0.0); 
  int totalRefugees = 4;
  for (int i = 0; i < totalRefugees; i++) {
    float x = map(i, 0, totalRefugees - 1, width * 0.35, width * 0.65);
    float yTarget = map(x, 0, width, 300, 520); 
    float scale = random(0.85, 1.05);
    color leafBaseColor = color(random(50, 70), random(120, 150), random(50, 75));
    nativeRefugees7.add(new MigratingTree7(x, yTarget, scale, leafBaseColor, i * 500));
  }
  int totalPalms = 2;
  for (int i = 0; i < totalPalms; i++) { float x = width * 0.82 + (i * 90); float y = 535; oppressingPalms7.add(new StaticPalm7(x, y, 1.0)); }
}

void draw7() {
  drawMountainAtmosphere7(); 
  drawSlopedGround7();       
  for (StaticPalm7 palm : oppressingPalms7) palm.display();
  for (MigratingTree7 tree : nativeRefugees7) tree.updateAndDisplay();
  wiseBanyanLeader7.updateAndDisplay();
}

// =================================================================================
// SCENE 8: Kelanjutan Perjalanan Migrasi Pohon Asli
// =================================================================================
ArrayList<ContinuousMigratingTree8> nativeRefugees8 = new ArrayList<ContinuousMigratingTree8>();
ContinuousMigratingBanyan8 wiseBanyanLeader8;

void setup8() {
  wiseBanyanLeader8 = new ContinuousMigratingBanyan8(width * 0.1, 1.2, 0.0);
  int totalRefugees = 8;
  for (int i = 0; i < totalRefugees; i++) {
    float x = map(i, 0, totalRefugees - 1, width * 0.22, width * 1.05);
    float scale = random(0.8, 1.05);
    color leafBaseColor = color(random(45, 65), random(115, 140), random(45, 70)); 
    nativeRefugees8.add(new ContinuousMigratingTree8(x, scale, leafBaseColor, i * 400));
  }
}

void draw8() {
  drawMountainAtmosphere8(); 
  drawSteepSlopedGround8();  
  for (ContinuousMigratingTree8 tree : nativeRefugees8) tree.updateAndDisplay();
  wiseBanyanLeader8.updateAndDisplay();
}

// =================================================================================
// SCENE 9 (A): Dominasi Monokultur di Bawah Terik Matahari Biasa
// =================================================================================
ArrayList<MonoculturePalm9A> plantation9A = new ArrayList<MonoculturePalm9A>();
float groundLevel9A = 500;

void setup9A() {
  int totalPalms = 8;
  for (int i = 0; i < totalPalms; i++) {
    float x = map(i, 0, totalPalms - 1, width * 0.05, width * 0.95);
    float y = groundLevel9A + 15 + random(-5, 5); 
    float scale = random(0.85, 1.0);
    boolean expressionPuas = (i % 2 == 0); 
    plantation9A.add(new MonoculturePalm9A(x, y, scale, expressionPuas));
  }
}

void draw9A() {
  drawBrightScorchingAtmosphere9A(); 
  drawFlatGround9A();                
  for (MonoculturePalm9A palm : plantation9A) palm.display();
  drawSunGlareOverlay9A(); 
}

// =================================================================================
// SCENE 9 (B): Dominasi Monokultur & Panas Menyengat
// =================================================================================
ArrayList<MonoculturePalm9B> plantation9B = new ArrayList<MonoculturePalm9B>();
float groundLevel9B = 500;

void setup9B() {
  int totalPalms = 7;
  for (int i = 0; i < totalPalms; i++) {
    float x = map(i, 0, totalPalms - 1, width * 0.05, width * 0.95);
    float y = groundLevel9B + 15 + random(-5, 5); 
    float scale = random(0.85, 1.0);
    plantation9B.add(new MonoculturePalm9B(x, y, scale));
  }
}

void draw9B() {
  drawScorchingAtmosphere9B(); 
  drawFlatGround9B();          
  for (MonoculturePalm9B palm : plantation9B) palm.display();
  drawHighlyVisibleHeatWaves9B(); 
  drawIntenseYellowGlare9B();     
}

// =================================================================================
// SCENE 10: Perubahan Cuaca Ekstrem (Mendung, Petir, Banjir Tinggi)
// =================================================================================
ArrayList<MonoculturePalm10> plantation10 = new ArrayList<MonoculturePalm10>();
ArrayList<RainDrop10> rainDrops10 = new ArrayList<RainDrop10>();
float groundLevel10 = 500;
float floodLevel10 = 0;         
boolean isLightningActive10 = false;
int lightningTimer10 = 0;

void setup10() {
  int totalPalms = 7;
  for (int i = 0; i < totalPalms; i++) {
    float x = map(i, 0, totalPalms - 1, width * 0.05, width * 0.95);
    float y = groundLevel10 + 15;
    float scale = random(0.85, 1.0);
    plantation10.add(new MonoculturePalm10(x, y, scale));
  }
  for (int i = 0; i < 300; i++) {
    rainDrops10.add(new RainDrop10());
  }
}

void draw10() {
  float progress = min(1.0, (float)sceneTime / sceneDuration); 
  
  if (progress < 0.6 && random(100) < 2 && nowMs() - lightningTimer10 > 500) {
    isLightningActive10 = true;
    lightningTimer10 = nowMs();
  }
  if (isLightningActive10 && nowMs() - lightningTimer10 > 120) {
    isLightningActive10 = false;
  }
  
  if (progress > 0.4) {
    floodLevel10 = map(progress, 0.4, 1.0, 0, 550);
  }
  
  drawStormAtmosphere10(progress);
  drawWetGround10(progress);
  
  for (MonoculturePalm10 palm : plantation10) {
    palm.display(progress);
  }
  
  int activeDrops = (int) map(progress, 0.0, 0.5, 30, rainDrops10.size());
  activeDrops = constrain(activeDrops, 30, rainDrops10.size());
  strokeWeight(2);
  for (int i = 0; i < activeDrops; i++) {
    rainDrops10.get(i).updateAndRender(progress);
  }
  
  if (floodLevel10 > 0) {
    drawFloodWater10();
  }
}

// =================================================================================
// SCENE 11: Arus Deras, Tanah Longsor & Sawit Hanyut 
// =================================================================================
ArrayList<FloatingPalm11> floatingPalms11 = new ArrayList<FloatingPalm11>();
float floodLevel11 = 600;

void setup11() {
  int totalPalms = 4;
  for (int i = 0; i < totalPalms; i++) {
    floatingPalms11.add(new FloatingPalm11(random(width), random(150, 300), random(0.8, 1.0)));
  }
}

void draw11() {
  drawStormAtmosphere11(); 
  drawLandslideGround11(); 
  drawFastFloodWater11();  
  
  for (FloatingPalm11 palm : floatingPalms11) {
    palm.display();
  }
}

// =================================================================================
// SCENE 12: Pasca Bencana - Air Mengering, Tanah Pecah, Sawit Mati & Selamat
// =================================================================================
ArrayList<PostFloodPalm12> postFloodPalms12 = new ArrayList<PostFloodPalm12>();
ArrayList<Debris12> debrisList12 = new ArrayList<Debris12>();
float groundLevel12 = 500;

void setup12() {
  int totalPalms = 6;
  
  for (int i = 0; i < totalPalms; i++) {
    float x = map(i, 0, totalPalms - 1, width * 0.1, width * 0.9) + random(-20, 20);
    // Tentukan sawit mana yang selamat. Contoh: indeks 1 dan 4 berhasil bertahan hidup.
    boolean isDead = (i != 1 && i != 4);
    postFloodPalms12.add(new PostFloodPalm12(x, groundLevel12 + 15, random(0.85, 1.05), isDead));
  }
  
  // Puing-puing dan patahan pohon
  for (int i = 0; i < 20; i++) {
    debrisList12.add(new Debris12(random(width), groundLevel12 + random(10, 200)));
  }
}

void draw12() {
  float progress = min(1.0, (float)sceneTime / sceneDuration);
  
  // Logika air surut perlahan di 40% pertama durasi scene
  float waterRecedeProgress = min(1.0, progress / 0.4);
  float currentFloodLevel = map(waterRecedeProgress, 0, 1, 600, 0);

  drawDullAtmosphere12();
  drawMudCrackedGround12(waterRecedeProgress);
  
  for (Debris12 debris : debrisList12) {
    debris.display();
  }
  
  // Render pohon mati yang tumbang di tanah terlebih dahulu (di belakang)
  for (PostFloodPalm12 palm : postFloodPalms12) {
    if (palm.isDead) palm.display();
  }
  
  // Render pohon yang masih hidup/berdiri (di depan)
  for (PostFloodPalm12 palm : postFloodPalms12) {
    if (!palm.isDead) palm.display();
  }

  if (currentFloodLevel > 0) {
    drawRecedingWater12(currentFloodLevel);
  }
}

// =================================================================================
// SCENE 13 (BARU): Sawit yang Selamat Kembali ke Hutan & Meminta Maaf
// =================================================================================
// Alur singkat scene ini (mengikuti pola sceneTime/sceneDuration yang sama dengan
// scene-scene lain di Bagian 2):
//   - progress 0.0 - 0.5  : Sawit yang selamat (dari Scene 12) berjalan menyusuri
//                           lahan yang sudah rusak, mencari tempat tinggal baru,
//                           lalu menemukan kembali hutan alami yang dulu mereka usir.
//   - progress 0.5 - 0.75 : Mereka berhenti di depan hutan, lalu perlahan menunduk
//                           (setengah membungkuk hormat) sebagai tanda permintaan maaf.
//   - progress 0.75 - 1.0 : Tetap dalam posisi menunduk hormat; pohon-pohon hutan
//                           yang tadinya waspada mulai menunjukkan ekspresi memaafkan.
ArrayList<NativeTree13> forestTrees13 = new ArrayList<NativeTree13>();
OldBanyan13 wiseBanyan13;
ArrayList<SurvivorPalm13> survivorPalms13 = new ArrayList<SurvivorPalm13>();
float groundLevel13 = 520;

void setup13() {
  wiseBanyan13 = new OldBanyan13(width * 0.22, groundLevel13, 1.3);

  // Hutan asli (pohon-pohon yang dulu terusir di Scene 8) kini berdiri kembali
  int totalNative = 5;
  for (int i = 0; i < totalNative; i++) {
    float x = map(i, 0, totalNative - 1, width * 0.02, width * 0.42);
    if (abs(x - wiseBanyan13.x) < 70) x += 90;
    float scale = random(0.85, 1.1);
    color leafBaseColor = color(random(40, 60), random(140, 180), random(60, 90));
    forestTrees13.add(new NativeTree13(x, groundLevel13, scale, leafBaseColor));
  }

  // Hanya 2 sawit yang selamat dari bencana (sesuai Scene 12: indeks 1 dan 4 yang tidak "isDead")
  survivorPalms13.add(new SurvivorPalm13(width * 1.15, groundLevel13 + 15, 0.95, 0));
  survivorPalms13.add(new SurvivorPalm13(width * 1.30, groundLevel13 + 15, 0.90, 1));
}

void draw13() {
  float progress = min(1.0, (float) sceneTime / sceneDuration);

  drawJourneyAtmosphere13(progress);
  drawJourneyGround13(progress);

  for (NativeTree13 tree : forestTrees13) tree.display(progress);
  wiseBanyan13.display(progress);

  for (SurvivorPalm13 palm : survivorPalms13) palm.display(progress);
}

// ===================================================================================
// SCENE PENUTUP (BARU) — Seluruh pohon hutan & sawit kini hidup berdampingan dengan
// damai dan bahagia, melompat kegirangan bersama di bawah matahari yang cerah,
// dikelilingi bunga-bunga kecil yang bermekaran di atas rerumputan.
// Menggunakan pola sceneTime/sceneDuration yang sama dengan scene-scene lain di
// Bagian 2. Karena ini scene TERAKHIR (currentScene2 == targetMaxScene), scene ini
// tidak pernah fade-out lagi -> animasi bahagia ini terus berulang selamanya.
// ===================================================================================
ArrayList<HappyTree> endingTrees = new ArrayList<HappyTree>();
ArrayList<HappyPalm> endingPalms = new ArrayList<HappyPalm>();
ArrayList<Flower> endingFlowers = new ArrayList<Flower>();
float groundLevelEnding = 520;

void setupEnding() {
  // Pohon-pohon asli hutan, kini tersebar merata & hidup tenteram
  int totalNative = 6;
  for (int i = 0; i < totalNative; i++) {
    float x = map(i, 0, totalNative - 1, width * 0.05, width * 0.50) + random(-20, 20);
    float sc = random(0.85, 1.15);
    color leafBaseColor = color(random(40, 60), random(140, 180), random(60, 90));
    endingTrees.add(new HappyTree(x, groundLevelEnding, sc, leafBaseColor, false, i));
  }
  // Pohon beringin tua, sang penjaga hutan, kini ikut bersukacita
  endingTrees.add(new HappyTree(width * 0.28, groundLevelEnding, 1.3, color(30, 110, 55), true, 99));

  // Sawit yang dulu menyesal kini diterima & hidup berdampingan di sisi hutan
  int totalPalm = 3;
  for (int i = 0; i < totalPalm; i++) {
    float x = map(i, 0, totalPalm - 1, width * 0.62, width * 0.92) + random(-15, 15);
    float sc = random(0.85, 1.05);
    endingPalms.add(new HappyPalm(x, groundLevelEnding + 15, sc, i));
  }

  // Bunga-bunga kecil bertebaran di atas rerumputan
  int totalFlowers = 45;
  color[] petalPalette = { color(255, 140, 170), color(255, 225, 110), color(255, 255, 255), color(200, 160, 230) };
  for (int i = 0; i < totalFlowers; i++) {
    float x = random(width);
    float y = groundLevelEnding + random(3, 20);
    color petalColor = petalPalette[int(random(petalPalette.length))];
    endingFlowers.add(new Flower(x, y, petalColor, random(TWO_PI), random(0.7, 1.2)));
  }
}

void drawEnding() {
  drawSunnyAtmosphereEnding();
  drawGroundEnding();

  for (Flower f : endingFlowers) f.display();

  for (HappyTree tree : endingTrees) tree.display();
  for (HappyPalm palm : endingPalms) palm.display();
}
