/**
 * =================================================================================
 * NYAWIT - TAB: ENVIRONMENT
 * =================================================================================
 * Berisi seluruh fungsi lingkungan/background: langit, atmosfer, matahari,
 * bintang, awan, petir, tanah/ground, kabut asap, banjir, air surut, dsb.
 * untuk setiap scene.
 * File ini adalah bagian dari sketch "nyawit" yang dipecah menjadi 4 tab:
 * characters.pde, environment.pde, sound.pde, scene.pde
 * Tidak ada isi/logika yang diubah dari file aslinya (nyawit.pde) - hanya
 * dipindahkan apa adanya ke tab ini.
 * =================================================================================
 */


// ==========================================
// FUNGSI LINGKUNGAN & BACKGROUND (SCENE 1-8, 10)
// ==========================================
void drawAtmosphere(int scene, int t) {
  color topC, botC, hill1, hill2;
  
  if (scene == 1) { // Terbit
    topC = color(255, 190, 150); botC = color(255, 230, 200);
    hill1 = color(165, 180, 160, 150); hill2 = color(140, 160, 140, 180);
  } else if (scene == 2 || scene == 5) { // Siang & Pagi
    topC = color(185, 225, 255); botC = color(225, 245, 255);
    hill1 = color(145, 195, 155, 150); hill2 = color(130, 185, 140, 180);
  } else if (scene == 3) { // Senja
    topC = color(160, 80, 120); botC = color(255, 170, 100);
    hill1 = color(110, 80, 90, 170); hill2 = color(90, 60, 70, 190);
  } else if (scene == 4) { // Malam
    topC = color(10, 15, 35); botC = color(30, 45, 75);
    hill1 = color(25, 35, 45, 200); hill2 = color(15, 25, 35, 220);
  } else if (scene == 6) { // Mendung
    topC = color(120, 135, 145); botC = color(160, 175, 185);
    hill1 = color(100, 130, 115, 160); hill2 = color(95, 125, 105, 180);
  } else if (scene == 7) { // Gerimis
    topC = color(70, 85, 95); botC = color(100, 115, 125);
    hill1 = color(90, 115, 100, 170); hill2 = color(80, 105, 90, 190);
  } else { // Badai (8)
    topC = color(40, 50, 65); botC = color(70, 80, 95);
    hill1 = color(85, 110, 95, 180); hill2 = color(75, 100, 85, 200);
  }

  for (int i = 0; i < groundLevel; i++) {
    stroke(lerpColor(topC, botC, map(i, 0, groundLevel, 0, 1)));
    line(0, i, width, i);
  }
  
  if ((scene >= 1 && scene <= 3) || scene == 5) {
    float progress;
    if (scene <= 3) {
      progress = map(t, 0, tSenja, 0, PI); 
    } else {
      // Scene 5 (Pagi): matahari naik penuh sampai titik puncak (PI/2), lalu
      // "clamp" waktunya di tPagiRise supaya matahari berhenti sejenak di puncak
      // (diam, tidak terus bergerak) sebelum langit berubah mendung di Scene 6.
      float clampedT = min(t, tPagiRise);
      progress = map(clampedT, tMalam, tPagiRise, 0, PI/2); 
    }
    
    float sunX = (width/2) - cos(progress) * (width/2 - 100);
    float sunY = (groundLevel + 50) - sin(progress) * (groundLevel - 100);
    
    noStroke(); fill(255, 235, 170, 45); ellipse(sunX, sunY, 260, 260); // soft outer halo for a gentler glow
    fill(255, 220, 100, 100); ellipse(sunX, sunY, 180, 180);
    fill(255, 240, 150, 220); ellipse(sunX, sunY, 120, 120);
  }
  
  // Jika berada di Scene 10 (kembali ke siang hari permanen), gambar matahari tetap di posisi atas/tengah
  if (currentScene == 10) {
    noStroke(); fill(255, 235, 170, 45); ellipse(width*0.5, height*0.2, 260, 260); // soft outer halo for a gentler glow
    fill(255, 220, 100, 100); ellipse(width*0.5, height*0.2, 180, 180);
    fill(255, 240, 150, 220); ellipse(width*0.5, height*0.2, 120, 120);
  }
  
  noStroke(); fill(hill1); ellipse(width * 0.2, groundLevel, width * 0.6, 250);
  fill(hill2); ellipse(width * 0.7, groundLevel, width * 0.7, 200);
}

void drawStars() {
  noStroke();
  for (int i = 0; i < starX.length; i++) {
    fill(255, 255, 255, random(100, 255)); 
    ellipse(starX[i], starY[i], starSize[i], starSize[i]);
  }
}

void drawStormClouds(int scene) {
  int cloudAlpha = (scene == 6) ? 90 : (scene == 7 ? 140 : 190);
  fill(30, 35, 45, cloudAlpha); noStroke();
  ellipse(150, 50, 320, 130); ellipse(450, 30, 420, 150);
  ellipse(800, 60, 460, 160); ellipse(1150, 40, 360, 140);
}

void drawLightning() {
  fill(255, 255, 255, 180); rect(0, 0, width, height);
}

void drawUndergroundBase(int scene) {
  noStroke(); color grass, dirt;
  if (scene == 1) { grass = color(105, 165, 115); dirt = color(115, 85, 65); }
  else if (scene == 2 || scene == 5) { grass = color(95, 155, 105); dirt = color(105, 75, 55); }
  else if (scene == 3) { grass = color(75, 120, 80); dirt = color(85, 55, 45); }
  else if (scene == 4) { grass = color(30, 55, 40); dirt = color(40, 25, 20); }
  else if (scene == 6) { grass = color(85, 140, 95); dirt = color(95, 65, 50); }
  else if (scene == 7) { grass = color(75, 125, 85); dirt = color(85, 60, 45); }
  else { grass = color(65, 115, 75); dirt = color(80, 55, 40); }
  
  fill(grass); rect(0, groundLevel, width, 25);
  fill(dirt); rect(0, groundLevel + 25, width, height - (groundLevel + 25));
}

// ==========================================
// VISUAL LINGKUNGAN KHUSUS SCENE 9 (PASCA-BADAI)
// ==========================================
void drawAtmosphereScene3() {
  for (int i = 0; i < groundLevel; i++) {
    float inter = map(i, 0, groundLevel, 0, 1);
    color c = lerpColor(color(120, 160, 205), color(205, 235, 250), inter);
    stroke(c); line(0, i, width, i);
  }
  noStroke();
  fill(255, 255, 200, 28); 
  quad(width * 0.15, 0, width * 0.65, 0, width * 1.1, groundLevel, width * -0.1, groundLevel);
  
  fill(125, 180, 140, 190); ellipse(width * 0.2, groundLevel, width * 0.6, 250);
  fill(110, 170, 125, 210); ellipse(width * 0.7, groundLevel, width * 0.7, 200);
}

void drawClearingClouds() {
  fill(235, 240, 245, 140);
  ellipse(100, -30, 280, 100); ellipse(500, -50, 380, 120); ellipse(950, -20, 400, 110);
}

void drawUndergroundBaseScene3() {
  noStroke(); fill(80, 145, 90); rect(0, groundLevel, width, 25);
  fill(110, 80, 60); rect(0, groundLevel + 25, width, height - (groundLevel + 25));
}
void drawAtmosphere4() {
  for (int i = 0; i < groundLevel4; i++) { stroke(lerpColor(color(135, 210, 245), color(255), map(i, 0, groundLevel4, 0, 1))); line(0, i, width, i); }
  noStroke(); fill(255, 255, 180, 30); quad(width*0.1, 0, width*0.7, 0, width*0.9, groundLevel4, width*-0.2, groundLevel4);
  fill(130, 190, 140, 150); ellipse(width*0.2, groundLevel4, width*0.5, 200); fill(110, 170, 120, 180); ellipse(width*0.7, groundLevel4, width*0.6, 180);
}
void drawUndergroundBase4() { noStroke(); fill(70, 150, 45); rect(0, groundLevel4, width, 25); fill(120, 75, 35); rect(0, groundLevel4 + 25, width, height); }
void drawAtmosphere5() {
  for (int i = 0; i < groundLevel5; i++) { stroke(lerpColor(color(135, 210, 245), color(245), map(i, 0, groundLevel5, 0, 1))); line(0, i, width, i); }
  noStroke(); fill(255, 255, 170, 25); quad(width*0.1, 0, width*0.7, 0, width*0.9, groundLevel5, width*-0.2, groundLevel5);
  fill(120, 180, 130, 140); ellipse(width*0.2, groundLevel5, width*0.5, 200); fill(100, 160, 110, 170); ellipse(width*0.7, groundLevel5, width*0.6, 180);
}
void drawUndergroundBase5() { noStroke(); fill(70, 150, 45); rect(0, groundLevel5, width, 25); fill(120, 75, 35); rect(0, groundLevel5 + 25, width, height); }
void drawCloseUpCertificate6(float x, float y, float w, float h) {
  pushMatrix(); translate(x, y); rotate(radians(-3 + sin(sceneTime * 0.003) * 0.5));
  rectMode(CENTER); noStroke(); fill(0, 40); rect(8, 8, w, h, 10);
  fill(253, 250, 242); stroke(120, 105, 85); strokeWeight(5); rect(0, 0, w, h, 10);
  noFill(); stroke(185, 155, 105); strokeWeight(2); rect(0, 0, w - 28, h - 28, 6); rect(0, 0, w - 36, h - 36, 4);
  fill(30, 40, 30); textAlign(CENTER, CENTER); PFont font = createFont("Arial Bold", 36); textFont(font); text("LAND TITLE", 0, -h/2 + 70);
  stroke(30, 40, 30); strokeWeight(3); line(-w/3, -h/2 + 100, w/3, -h/2 + 100); strokeWeight(1); line(-w/4, -h/2 + 105, w/4, -h/2 + 105);
  stroke(70); strokeWeight(3); int textLines = 10;
  for (int i = 0; i < textLines; i++) {
    float yy = -h/2 + 150 + (i * 26); float lineLength = w - 80;
    if (i == 2 || i == 5 || i == 9) lineLength = w - 180; 
    line(-lineLength/2, yy, lineLength/2, yy);
  }
  float stampX = w/2 - 80, stampY = h/2 - 90;
  noFill(); stroke(30, 60, 160); strokeWeight(3);
  beginShape(); curveVertex(stampX - 35, stampY + 15); curveVertex(stampX - 25, stampY + 5); curveVertex(stampX - 5, stampY - 20); curveVertex(stampX + 15, stampY + 20); curveVertex(stampX + 35, stampY); curveVertex(stampX + 45, stampY + 10); endShape();
  stroke(50); strokeWeight(2); line(stampX - 50, stampY + 30, stampX + 50, stampY + 30);
  pushMatrix(); translate(stampX - 90, stampY - 10); rotate(radians(20)); 
  noFill(); stroke(210, 50, 50, 240); strokeWeight(4); ellipse(0, 0, 75, 75); strokeWeight(1.5); ellipse(0, 0, 63, 63);
  rectMode(CENTER); fill(210, 50, 50, 240); noStroke(); rect(0, -6, 36, 5); rect(0, 6, 26, 5); popMatrix();
  popMatrix(); rectMode(CORNER); 
}
void drawAtmosphere6() {
  for (int i = 0; i < groundLevel6; i++) { stroke(lerpColor(color(135, 210, 245), color(245), map(i, 0, groundLevel6, 0, 1))); line(0, i, width, i); }
  noStroke(); fill(255, 255, 170, 25); quad(width*0.1, 0, width*0.7, 0, width*0.9, groundLevel6, width*-0.2, groundLevel6);
  fill(120, 180, 130, 140); ellipse(width*0.2, groundLevel6, width*0.5, 200); fill(100, 160, 110, 170); ellipse(width*0.7, groundLevel6, width*0.6, 180);
}
void drawUndergroundBase6() { noStroke(); fill(70, 150, 45); rect(0, groundLevel6, width, 25); fill(120, 75, 35); rect(0, groundLevel6 + 25, width, height); }
void drawMountainAtmosphere7() {
  for (int i = 0; i < height; i++) { stroke(lerpColor(color(140, 195, 225), color(235, 230, 215), map(i, 0, height, 0, 1))); line(0, i, width, i); }
  noStroke(); fill(110, 155, 140, 120); triangle(-100, 450, 300, 150, 700, 450); fill(95, 140, 125, 160); triangle(150, 500, 600, 180, 1050, 500);
}
void drawSlopedGround7() {
  noStroke(); fill(65, 135, 45); beginShape(); vertex(0, 300); vertex(width, 520); vertex(width, 545); vertex(0, 325); endShape();
  fill(120, 75, 35); beginShape(); vertex(0, 325); vertex(width, 545); vertex(width, height); vertex(0, height); endShape();
}
void drawMountainAtmosphere8() {
  for (int i = 0; i < height; i++) { stroke(lerpColor(color(140, 195, 225), color(235, 230, 215), map(i, 0, height, 0, 1))); line(0, i, width, i); }
  noStroke(); fill(110, 155, 140, 120); triangle(-100, 450, 300, 150, 700, 450); fill(95, 140, 125, 160); triangle(150, 500, 600, 180, 1050, 500);
}
void drawSteepSlopedGround8() {
  noStroke(); fill(60, 125, 40); beginShape(); vertex(0, 240); vertex(width, 550); vertex(width, 575); vertex(0, 265); endShape();
  fill(110, 70, 30); beginShape(); vertex(0, 265); vertex(width, 575); vertex(width, height); vertex(0, height); endShape();
}
void drawBrightScorchingAtmosphere9A() {
  for (int i = 0; i < groundLevel9A; i++) {
    float inter = map(i, 0, groundLevel9A, 0, 1); color c = lerpColor(color(255, 255, 180), color(230, 180, 60), inter); stroke(c); line(0, i, width, i);
  }
  float sunX = width * 0.5, sunY = 90;
  noStroke(); fill(255, 240, 150, 25); ellipse(sunX, sunY, 350, 350); fill(255, 220, 80, 40); ellipse(sunX, sunY, 250, 250);
  fill(255, 255, 200); ellipse(sunX, sunY, 150, 150);
  fill(255, 255, 150, 20); pushMatrix(); translate(sunX, sunY); rotate(radians(sceneTime * 0.005)); 
  for (int i = 0; i < 12; i++) { rotate(radians(30)); triangle(-30, 0, 30, 0, 0, 850); }
  popMatrix();
}
void drawFlatGround9A() { noStroke(); fill(120, 150, 65); rect(0, groundLevel9A, width, 25); fill(135, 95, 55); rect(0, groundLevel9A + 25, width, height); }
void drawSunGlareOverlay9A() { noStroke(); fill(255, 230, 100, 25); rect(0, 0, width, height); }
void drawScorchingAtmosphere9B() {
  for (int i = 0; i < groundLevel9B; i++) {
    float inter = map(i, 0, groundLevel9B, 0, 1); color c = lerpColor(color(255, 255, 200), color(225, 70, 30), inter); stroke(c); line(0, i, width, i);
  }
  float sunX = width * 0.5, sunY = 90, pulse = sin(sceneTime * 0.006) * 15;
  noStroke(); fill(240, 60, 30, 20); ellipse(sunX, sunY, 550 + pulse, 550 + pulse);
  fill(255, 225, 50, 60); ellipse(sunX, sunY, 360 + pulse, 360 + pulse);
  fill(255, 255, 180); ellipse(sunX, sunY, 170, 170);
  fill(255, 235, 100, 20); pushMatrix(); translate(sunX, sunY); rotate(radians(sceneTime * 0.015)); 
  for (int i = 0; i < 12; i++) { rotate(radians(30)); triangle(-40, 0, 40, 0, 0, 900); }
  popMatrix();
}
void drawFlatGround9B() { noStroke(); fill(125, 120, 45); rect(0, groundLevel9B, width, 25); fill(120, 65, 35); rect(0, groundLevel9B + 25, width, height); }
void drawHighlyVisibleHeatWaves9B() {
  strokeWeight(5); noFill();
  for (int x = 10; x < width; x += 25) {
    stroke(255, 160, 50, 35); beginShape();
    for (int y = 0; y < groundLevel9B + 100; y += 15) { float xOffset = sin(y * 0.04 - sceneTime * 0.012 + x) * 9; vertex(x + xOffset, y); }
    endShape();
  }
}
void drawIntenseYellowGlare9B() {
  noStroke(); float pulse = sin(sceneTime * 0.003) * 18;
  fill(255, 220, 30, 25 + pulse); rect(0, 0, width, height);
  for (int r = 800; r > 100; r -= 150) { fill(255, 230, 80, map(r, 800, 100, 2, 12)); ellipse(width/2, 90, r, r); }
}

void drawStormAtmosphere10(float progress) {
  if (isLightningActive10) {
    background(210, 220, 235);
  } else {
    for (int i = 0; i < groundLevel10; i++) {
      float inter = map(i, 0, groundLevel10, 0, 1);
      color skyStart = lerpColor(color(70, 75, 85), color(25, 28, 35), progress);
      color skyEnd = lerpColor(color(45, 50, 60), color(15, 17, 22), progress);
      stroke(lerpColor(skyStart, skyEnd, inter));
      line(0, i, width, i);
    }
  }
  
  noStroke();
  fill(30, 32, 40, 200 + (progress * 55));
  ellipse(width * 0.2, 40, 500, 140);
  ellipse(width * 0.5, 20, 600, 160);
  ellipse(width * 0.8, 50, 450, 130);
  
  if (isLightningActive10) {
    stroke(255, 255, 230);
    strokeWeight(random(4, 8));
    float lx = random(width * 0.3, width * 0.7);
    line(lx, 0, lx + 40, 120);
    line(lx + 40, 120, lx - 10, 240);
    line(lx - 10, 240, lx + 20, 360);
    strokeWeight(2);
    line(lx + 40, 120, lx + 90, 180);
  }
}

void drawWetGround10(float progress) {
  noStroke();
  color grassColor = lerpColor(color(95, 100, 40), color(40, 45, 20), progress);
  color soilColor = lerpColor(color(90, 55, 30), color(40, 25, 15), progress);
  fill(grassColor); rect(0, groundLevel10, width, 25);
  fill(soilColor); rect(0, groundLevel10 + 25, width, height);
}

void drawFloodWater10() {
  noStroke();
  fill(75, 85, 115, 215); 
  rect(0, height - floodLevel10, width, floodLevel10);
  
  stroke(110, 120, 140, 150);
  strokeWeight(2);
  for (int x = 0; x < width; x += 40) {
    float yWave = (height - floodLevel10) + sin(x * 0.05 + sceneTime * 0.003) * 4;
    line(x, yWave, x + 25, yWave);
  }
}

void drawStormAtmosphere11() {
  background(25, 28, 35); 
  noStroke();
  fill(30, 32, 40, 255);
  ellipse(width * 0.2, 40, 500, 140);
  ellipse(width * 0.5, 20, 600, 160);
  ellipse(width * 0.8, 50, 450, 130);
}

void drawLandslideGround11() {
  float splitProgress = constrain(map(sceneTime, 0, sceneDuration, 0, 1), 0, 1);
  float gap = splitProgress * 350; 
  float sink = splitProgress * 200; 
  noStroke();
  fill(40, 25, 15); 
  
  beginShape();
  vertex(0, groundLevel10 + sink);
  vertex(width/2 - gap/2, groundLevel10 + sink + gap/3);
  vertex(width/2 - gap/2 - 100, height);
  vertex(0, height);
  endShape();
  
  beginShape();
  vertex(width, groundLevel10 + sink);
  vertex(width/2 + gap/2, groundLevel10 + sink + gap/3);
  vertex(width/2 + gap/2 + 100, height);
  vertex(width, height);
  endShape();
}

void drawFastFloodWater11() {
  noStroke();
  fill(75, 85, 115, 230); 
  rect(0, height - floodLevel11, width, floodLevel11);
  
  stroke(110, 120, 140, 180);
  strokeWeight(3);
  float currentSpeed = sceneTime * 0.08;
  for (int i = 0; i < 70; i++) {
    float xBase = (i * 83) % width;
    float yBase = (height - floodLevel11) + ((i * 37) % floodLevel11);
    float len = 30 + (i * 11) % 50;
    float speedMult = 1.0 + (i % 5) * 0.2;
    float x = (xBase + currentSpeed * speedMult) % (width + len) - len;
    line(x, yBase, x + len, yBase);
  }
}

void drawDullAtmosphere12() {
  for (int i = 0; i < groundLevel12; i++) {
    float inter = map(i, 0, groundLevel12, 0, 1);
    color c = lerpColor(color(180, 175, 160), color(210, 200, 180), inter);
    stroke(c);
    line(0, i, width, i);
  }
  
  noStroke();
  fill(240, 230, 200, 150);
  ellipse(width * 0.5, 150, 200, 200);
  fill(255, 250, 220, 200);
  ellipse(width * 0.5, 150, 100, 100);
}

void drawMudCrackedGround12(float recedeProgress) {
  noStroke();
  color wetMud = color(60, 45, 30);
  color dryMud = color(140, 115, 90);
  color currentMudColor = lerpColor(wetMud, dryMud, recedeProgress);
  
  fill(currentMudColor);
  rect(0, groundLevel12, width, height - groundLevel12);
  
  if (recedeProgress > 0.5) {
    float crackAlpha = map(recedeProgress, 0.5, 1.0, 0, 200);
    stroke(70, 50, 35, crackAlpha);
    noFill();
    randomSeed(12345); // Seed statis agar retakan tidak berkedip
    for (int i = 0; i < 40; i++) {
      float startX = random(width);
      float startY = random(groundLevel12 + 20, height);
      strokeWeight(random(1, 3));
      beginShape();
      vertex(startX, startY);
      float currX = startX;
      float currY = startY;
      for (int j = 0; j < random(3, 7); j++) {
        currX += random(-30, 30);
        currY += random(10, 40);
        vertex(currX, currY);
      }
      endShape();
    }
  }
}

void drawRecedingWater12(float level) {
  noStroke();
  fill(75, 80, 95, 180); 
  rect(0, height - level, width, level);
}

// ---------------------------------------------------------------------------------
// Latar Scene 13: langit & tanah berangsur dari suasana suram pasca-bencana
// menjadi lebih hangat dan hijau saat sawit yang selamat mendekati hutan
// ---------------------------------------------------------------------------------
void drawJourneyAtmosphere13(float progress) {
  color dullSky = color(195, 185, 165);
  color hopeSky = color(180, 220, 235);
  color topC = lerpColor(dullSky, hopeSky, progress);
  color botC = lerpColor(color(215, 205, 185), color(225, 240, 245), progress);

  for (int i = 0; i < groundLevel13; i++) {
    stroke(lerpColor(topC, botC, map(i, 0, groundLevel13, 0, 1)));
    line(0, i, width, i);
  }

  noStroke();
  float sunAlpha = lerp(90, 170, progress);
  fill(255, 235, 190, sunAlpha);
  ellipse(width * 0.5, 110, 190, 190);
  fill(255, 250, 220, sunAlpha + 40);
  ellipse(width * 0.5, 110, 120, 120);
}

void drawJourneyGround13(float progress) {
  noStroke();
  // Tanah beralih dari kering/gersang (sisa bencana) menjadi subur (tanah hutan)
  color dryGrass = color(150, 140, 90);
  color lushGrass = color(95, 155, 105);
  color dryDirt = color(120, 95, 70);
  color lushDirt = color(105, 75, 55);

  fill(lerpColor(dryGrass, lushGrass, progress));
  rect(0, groundLevel13, width, 25);
  fill(lerpColor(dryDirt, lushDirt, progress));
  rect(0, groundLevel13 + 25, width, height - (groundLevel13 + 25));
}

// ---------------------------------------------------------------------------------
// Latar scene penutup: langit cerah cemerlang dengan matahari besar yang
// memancarkan sinar hangat berputar perlahan, awan-awan putih ringan
// ---------------------------------------------------------------------------------
void drawSunnyAtmosphereEnding() {
  color topC = color(140, 200, 255);
  color botC = color(210, 240, 255);
  for (int i = 0; i < groundLevelEnding; i++) {
    stroke(lerpColor(topC, botC, map(i, 0, groundLevelEnding, 0, 1)));
    line(0, i, width, i);
  }

  noStroke();
  float sunX = width * 0.5;
  float sunY = 130;

  pushMatrix();
  translate(sunX, sunY);
  rotate(sceneTime * 0.0004);
  stroke(255, 235, 150, 150); strokeWeight(6);
  for (int i = 0; i < 12; i++) {
    float ang = i * (TWO_PI / 12);
    float rayLen = 110 + sin(sceneTime * 0.003 + i) * 15;
    line(cos(ang) * 90, sin(ang) * 90, cos(ang) * rayLen, sin(ang) * rayLen);
  }
  noStroke();
  popMatrix();

  fill(255, 225, 120, 130); ellipse(sunX, sunY, 190, 190);
  fill(255, 245, 180); ellipse(sunX, sunY, 130, 130);

  fill(255, 255, 255, 200);
  ellipse(width * 0.15, 90, 160, 55);
  ellipse(width * 0.15 + 50, 100, 120, 45);
  ellipse(width * 0.82, 70, 180, 60);
  ellipse(width * 0.82 - 55, 85, 130, 45);
}

void drawGroundEnding() {
  noStroke();
  fill(110, 180, 100); rect(0, groundLevelEnding, width, 25);
  fill(120, 90, 65); rect(0, groundLevelEnding + 25, width, height - (groundLevelEnding + 25));
}
