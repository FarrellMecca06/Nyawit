/**
 * =================================================================================
 * NYAWIT - TAB: CHARACTERS
 * =================================================================================
 * Berisi seluruh definisi class (karakter/objek): pohon hutan, beringin tua,
 * sawit (di berbagai scene/versi), partikel daun & hujan, genangan air,
 * partikel air, debris, bunga, dsb.
 * File ini adalah bagian dari sketch "nyawit" yang dipecah menjadi 4 tab:
 * characters.pde, environment.pde, sound.pde, scene.pde
 * Tidak ada isi/logika yang diubah dari file aslinya (nyawit.pde) - hanya
 * dipindahkan apa adanya ke tab ini.
 * =================================================================================
 */


// ==========================================
// KELAS UTAMA: POHON LOKAL
// ==========================================
class NativeTree {
  float x, y, scale, timeOffset;
  color leafColor;

  NativeTree(float x, float y, float scale, color leafColor) {
    this.x = x; this.y = y; this.scale = scale;
    this.leafColor = leafColor;
    this.timeOffset = random(1000);
  }

  void update() {}

  void display() {
    pushMatrix();
    translate(x, y);
    
    float windLean = 0;
    if (currentScene == 7) windLean = sin((nowMs() * 0.002) + timeOffset) * 0.01 - 0.01;
    if (currentScene == 8) windLean = sin((nowMs() * 0.003) + timeOffset) * 0.03 - 0.04;
    if (currentScene == 9 || currentScene == 10) windLean = sin((nowMs() * 0.001) + timeOffset) * 0.015;
    rotate(windLean);
    
    drawTrunk();
    draw3LayerLeaves();
    
    if (currentScene >= 6 && currentScene <= 8) {
      drawDeterminedFace();
    } else if (currentScene == 9) {
      drawRelievedFace();
    } else {
      drawPeacefulFace(); 
    }
    
    popMatrix();
  }
  
  color getSceneTrunkColor() {
    if (currentScene == 3) return color(85, 55, 35); 
    if (currentScene == 4) return color(45, 30, 20); 
    if (currentScene == 6) return color(90, 70, 50); 
    if (currentScene == 7) return color(80, 60, 45); 
    if (currentScene == 8) return color(70, 50, 40); 
    if (currentScene == 9) return color(100, 75, 50);
    if (currentScene == 10) return color(110, 80, 55);
    return color(110, 80, 55); 
  }

  void drawTrunk() {
    color tColor = getSceneTrunkColor();
    fill(tColor); noStroke();
    beginShape();
    vertex(-16 * scale, 0); vertex(-10 * scale, -110 * scale);
    vertex(10 * scale, -110 * scale); vertex(16 * scale, 0);
    endShape(CLOSE);
    
    stroke(tColor); strokeWeight(6 * scale);
    line(-6 * scale, -90 * scale, -25 * scale, -120 * scale);
    line(6 * scale, -90 * scale, 25 * scale, -120 * scale);
    noStroke();
  }

  void draw3LayerLeaves() {
    color cLeaf = leafColor;
    if (currentScene == 3) cLeaf = lerpColor(leafColor, color(180, 80, 20), 0.3);
    if (currentScene == 4) cLeaf = lerpColor(leafColor, color(10, 15, 25), 0.7);
    if (currentScene == 6) cLeaf = lerpColor(leafColor, color(40, 60, 50), 0.3);
    if (currentScene == 7) cLeaf = lerpColor(leafColor, color(20, 40, 25), 0.5);
    if (currentScene == 8) cLeaf = lerpColor(leafColor, color(10, 20, 10), 0.7);
    
    if (currentScene == 9) {
      float t = (nowMs() * 0.001) + timeOffset;
      fill(lerpColor(leafColor, color(10, 40, 15), 0.3), 240);
      float innerX = sin(t * 0.4) * 4; float innerY = cos(t * 0.3) * 2;
      drawLeafCluster(innerX, -120 * scale + innerY, 135 * scale, 95 * scale);

      fill(leafColor, 220);
      float midX = sin(t * 0.8 + 1.2) * 8; float midY = cos(t * 0.7 + 0.8) * 4;
      drawLeafCluster(midX, -140 * scale + midY, 115 * scale, 80 * scale);

      fill(lerpColor(leafColor, color(180, 240, 120), 0.15), 200);
      float outerX = sin(t * 1.4 + 2.0) * 12; float outerY = cos(t * 1.2 + 1.5) * 6;
      drawLeafCluster(outerX, -155 * scale + outerY, 90 * scale, 65 * scale);
    } else {
      float t = nowMs() * ((currentScene == 8) ? 0.0025 : 0.001) + timeOffset;
      
      fill(lerpColor(cLeaf, color(10, 45, 15), 0.35), 235);
      float innerX = (currentScene == 8) ? sin(t * 1.2) * 8 - 6 : sin(t * 0.4) * 5;
      float innerY = (currentScene == 8) ? cos(t * 1.0) * 4 : cos(t * 0.3) * 3;
      drawLeafCluster(innerX, -120 * scale + innerY, 135 * scale, 95 * scale);
      
      fill(cLeaf, 210);
      float midX = (currentScene == 8) ? sin(t * 2.2 + 1.5) * 15 - 14 : sin(t * 0.9 + 1.5) * 11;
      float midY = (currentScene == 8) ? cos(t * 1.8 + 1.0) * 8 : cos(t * 0.8 + 1.0) * 7;
      drawLeafCluster(midX, -140 * scale + midY, 115 * scale, 80 * scale);
      
      fill(lerpColor(cLeaf, (currentScene == 4 ? color(50, 70, 90) : color(210, 255, 140)), (currentScene >= 6 && currentScene <= 8) ? 0.05 : 0.25), 185);
      float outerX = (currentScene == 8) ? sin(t * 3.5 + 3.0) * 22 - 20 : sin(t * 1.7 + 3.0) * 16;
      float outerY = (currentScene == 8) ? cos(t * 2.8 + 2.5) * 12 : cos(t * 1.5 + 2.5) * 11;
      drawLeafCluster(outerX, -155 * scale + outerY, 90 * scale, 65 * scale);
    }
  }

  void drawLeafCluster(float cx, float cy, float w, float h) {
    ellipse(cx, cy, w, h);
    ellipse(cx - w * 0.25, cy + h * 0.15, w * 0.7, h * 0.7);
    ellipse(cx + w * 0.25, cy + h * 0.15, w * 0.7, h * 0.7);
    ellipse(cx, cy - h * 0.2, w * 0.75, h * 0.75);
  }

  void drawPeacefulFace() {
    pushMatrix(); translate(0, -55 * scale);
    noFill(); stroke(currentScene == 4 ? 150 : 40); 
    strokeWeight(2.5 * scale);
    arc(-7 * scale, 0, 8 * scale, 6 * scale, 0, PI);
    arc(7 * scale, 0, 8 * scale, 6 * scale, 0, PI);
    arc(0, 5 * scale, 10 * scale, 8 * scale, 0, PI);
    popMatrix(); noStroke();
  }

  void drawDeterminedFace() {
    pushMatrix(); translate(0, -55 * scale);
    stroke(25); strokeWeight(3 * scale);
    line(-10 * scale, -2 * scale, -3 * scale, 2 * scale);
    line(-10 * scale, 5 * scale, -3 * scale, 2 * scale);
    line(10 * scale, -2 * scale, 3 * scale, 2 * scale);
    line(10 * scale, 5 * scale, 3 * scale, 2 * scale);
    line(-6 * scale, 12 * scale, 6 * scale, 12 * scale);
    popMatrix(); noStroke();
  }

  void drawRelievedFace() {
    pushMatrix(); translate(0, -55 * scale);
    noFill(); stroke(40); strokeWeight(2.5 * scale);
    arc(-8 * scale, 0, 8 * scale, 6 * scale, PI, TWO_PI);
    arc(8 * scale, 0, 8 * scale, 6 * scale, PI, TWO_PI);
    arc(0, 4 * scale, 12 * scale, 8 * scale, 0, PI);
    popMatrix(); noStroke();
  }
}

// ==========================================
// SUBKELAS: POHON BERINGIN TUA
// ==========================================
class OldBanyan extends NativeTree {
  OldBanyan(float x, float y, float scale) {
    super(x, y, scale, color(25, 95, 50));
  }
  
  @Override
  color getSceneTrunkColor() {
    if (currentScene == 3) return color(70, 45, 35);
    if (currentScene == 4) return color(35, 25, 20);
    if (currentScene == 6) return color(75, 55, 45);
    if (currentScene == 7) return color(65, 45, 35);
    if (currentScene == 8) return color(55, 40, 30);
    if (currentScene == 9) return color(85, 65, 50);
    if (currentScene == 10) return color(90, 65, 50);
    return color(90, 65, 50);
  }

  @Override
  void drawTrunk() {
    fill(getSceneTrunkColor()); noStroke();
    beginShape();
    vertex(-50 * scale, 0); vertex(-25 * scale, -140 * scale);
    vertex(25 * scale, -140 * scale); vertex(50 * scale, 0);
    endShape(CLOSE);
  }

  @Override
  void draw3LayerLeaves() {
    if (currentScene == 9) {
      float t = (nowMs() * 0.001) + timeOffset;
      fill(color(10, 50, 20), 245);
      float innerX = sin(t * 0.3) * 3; float innerY = cos(t * 0.2) * 2;
      drawLeafCluster(innerX, -160 * scale + innerY, 340 * scale, 200 * scale);

      fill(leafColor, 225);
      float midX = sin(t * 0.7 + 1.0) * 7; float midY = cos(t * 0.6 + 0.8) * 4;
      drawLeafCluster(midX - 40 * scale, -190 * scale + midY, 230 * scale, 140 * scale);
      drawLeafCluster(midX + 40 * scale, -190 * scale + midY, 230 * scale, 140 * scale);

      fill(lerpColor(leafColor, color(200, 245, 140), 0.12), 185);
      float outerX = sin(t * 1.2 + 2.0) * 11; float outerY = cos(t * 1.0 + 1.5) * 6;
      drawLeafCluster(outerX, -220 * scale + outerY, 190 * scale, 115 * scale);
    } else {
      color baseCol = leafColor;
      if (currentScene == 3) baseCol = lerpColor(leafColor, color(160, 60, 20), 0.3);
      if (currentScene == 4) baseCol = lerpColor(leafColor, color(5, 10, 20), 0.8);
      if (currentScene == 6) baseCol = lerpColor(leafColor, color(20, 60, 40), 0.4);
      if (currentScene == 7) baseCol = lerpColor(leafColor, color(15, 40, 25), 0.6);
      if (currentScene == 8) baseCol = color(15, 75, 35);
      
      float t = nowMs() * ((currentScene == 8) ? 0.0018 : 0.001) + timeOffset;
      
      fill(lerpColor(baseCol, color(10, 40, 20), 0.5), 245);
      float innerX = (currentScene == 8) ? sin(t * 1.0) * 6 - 5 : sin(t * 0.3) * 4;
      float innerY = (currentScene == 8) ? cos(t * 0.8) * 3 : cos(t * 0.2) * 2;
      drawLeafCluster(innerX, -160 * scale + innerY, 340 * scale, 200 * scale);
      
      fill(baseCol, 220);
      float midX = (currentScene == 8) ? sin(t * 1.8 + 1.0) * 14 - 12 : sin(t * 0.7 + 1.0) * 9;
      float midY = (currentScene == 8) ? cos(t * 1.5 + 0.8) * 6 : cos(t * 0.6 + 0.8) * 5;
      drawLeafCluster(midX - 40 * scale, -190 * scale + midY, 230 * scale, 140 * scale);
      drawLeafCluster(midX + 40 * scale, -190 * scale + midY, 230 * scale, 140 * scale);
      
      fill(lerpColor(baseCol, (currentScene == 4 ? color(30, 50, 70) : color(215, 245, 150)), (currentScene >= 6 && currentScene <= 8) ? 0.05 : 0.2), 175);
      float outerX = (currentScene == 8) ? sin(t * 2.8 + 2.0) * 18 - 16 : sin(t * 1.3 + 2.0) * 14;
      float outerY = (currentScene == 8) ? cos(t * 2.3 + 1.5) * 10 : cos(t * 1.1 + 1.5) * 8;
      drawLeafCluster(outerX, -220 * scale + outerY, 190 * scale, 115 * scale);
    }
  }

  @Override
  void drawPeacefulFace() {
    pushMatrix(); translate(0, -75 * scale);
    stroke(currentScene == 4 ? 120 : 50); strokeWeight(3 * scale);
    line(-18 * scale, -8 * scale, -6 * scale, -4 * scale);
    line(6 * scale, -4 * scale, 18 * scale, -8 * scale);
    noFill();
    arc(-10 * scale, 0, 10 * scale, 6 * scale, 0, PI);
    arc(10 * scale, 0, 10 * scale, 6 * scale, 0, PI);
    arc(0, 8 * scale, 20 * scale, 12 * scale, 0, PI);
    popMatrix(); noStroke();
  }
  
  @Override
  void drawDeterminedFace() {
    pushMatrix(); translate(0, -75 * scale);
    stroke(30); strokeWeight(4 * scale);
    line(-20 * scale, -6 * scale, -6 * scale, -4 * scale);
    line(6 * scale, -4 * scale, 20 * scale, -6 * scale);
    line(-15 * scale, 2 * scale, -5 * scale, 2 * scale);
    line(5 * scale, 2 * scale, 15 * scale, 2 * scale);
    noFill();
    arc(0, 12 * scale, 16 * scale, 6 * scale, 0, PI);
    popMatrix(); noStroke();
  }

  @Override
  void drawRelievedFace() {
    pushMatrix(); translate(0, -75 * scale);
    stroke(50); strokeWeight(3 * scale);
    noFill();
    arc(-12 * scale, -4 * scale, 12 * scale, 6 * scale, PI, TWO_PI);
    arc(12 * scale, -4 * scale, 12 * scale, 6 * scale, PI, TWO_PI);
    arc(-10 * scale, 4 * scale, 10 * scale, 6 * scale, PI, TWO_PI);
    arc(10 * scale, 4 * scale, 10 * scale, 6 * scale, PI, TWO_PI);
    arc(0, 10 * scale, 22 * scale, 14 * scale, 0, PI);
    popMatrix(); noStroke();
  }
}

// ==========================================
// KELAS PARTIKEL (ANGIN & HUJAN)
// ==========================================
class WindLeaf {
  float x, y, speed, size, angle, amplitude;
  WindLeaf() { respawn(true); }
  void respawn(boolean f) {
    x = f ? random(width) : -30; y = random(50, groundLevel - 100);
    speed = random(1.8, 3.8); size = random(6, 11);
    angle = random(TWO_PI); amplitude = random(0.8, 2.0);
  }
  void update() {
    x += speed; y += sin(nowMs() * 0.0025 + angle) * amplitude;
    if (x > width + 30) respawn(false);
  }
  void display() {
    fill(135, 215, 125, currentScene == 3 ? 80 : 140); 
    noStroke(); pushMatrix(); translate(x, y);
    rotate(sin(nowMs() * 0.003 + angle) * 0.4);
    ellipse(0, 0, size * 1.6, size); popMatrix();
  }
}

class RainDrop {
  float x, y, baseSpeedY, baseSpeedX, len;
  RainDrop() { respawn(true); }
  void respawn(boolean f) {
    x = random(-100, width); 
    y = f ? random(-height, 0) : random(-40, 0);
    baseSpeedY = random(12, 18); baseSpeedX = random(-4, -2); len = random(20, 45);
  }
  void update(int scene) {
    float multiplier = (scene == 7) ? 0.4 : 1.2; 
    x += baseSpeedX * (scene == 7 ? 0.2 : 1.2); 
    y += baseSpeedY * multiplier;
    if (y > groundLevel + 30 || x < -50) respawn(false);
  }
  void display(int scene) {
    stroke(165, 200, 230, scene == 7 ? 100 : 160); 
    strokeWeight(scene == 7 ? random(0.8, 1.5) : random(1.5, 3.0));
    line(x, y, x + (baseSpeedX * (scene == 7 ? 0.2 : 1.2)), y + (len * (scene == 7 ? 0.5 : 1.0))); 
    noStroke();
  }
}

// ==========================================
// KELAS BARU: GENANGAN AIR & PARTIKEL SERAP
// ==========================================
class Puddle {
  float x, y, w, h, baseW;
  Puddle(float x, float y, float w) {
    this.x = x; this.y = y; this.baseW = w;
    this.h = w * 0.18; 
  }
  void display() {
    float waveW = baseW + sin(nowMs() * 0.002 + x) * 4;
    float waveH = h + cos(nowMs() * 0.002 + x) * 1.5;
    noStroke();
    fill(100, 165, 235, 130); 
    ellipse(x, y + 10, waveW, waveH);
    fill(80, 145, 215, 100);
    ellipse(x, y + 10, waveW * 0.7, waveH * 0.7);
  }
}

class WaterParticle {
  float pX, pY, targetX, targetY, speed, size, alpha;
  int targetTreeIndex;

  WaterParticle() { respawn(); }
  void respawn() {
    targetTreeIndex = int(random(-1, 8));
    if (targetTreeIndex == -1) {
      targetX = wiseBanyan.x + random(-20, 20);
      targetY = wiseBanyan.y - random(20, 60); 
    } else {
      int idx = constrain(targetTreeIndex, 0, forestTrees.size() - 1);
      NativeTree t = forestTrees.get(idx);
      targetX = t.x + random(-10, 10); targetY = t.y - random(20, 50);
    }
    pX = targetX + random(-80, 80); pY = groundLevel + random(5, 15);
    speed = random(0.015, 0.04); size = random(4, 8); alpha = 255;
  }
  void update() {
    pX = lerp(pX, targetX, speed); pY = lerp(pY, targetY, speed);
    float distance = dist(pX, pY, targetX, targetY);
    if (distance < 15) alpha -= 15;
    if (alpha <= 0 || distance < 2) respawn();
  }
  void display() {
    fill(130, 230, 255, alpha); noStroke();
    ellipse(pX, pY, size, size);
    fill(255, 255, 255, alpha);
    ellipse(pX, pY, size * 0.4, size * 0.4);
  }
}

class NativeTree4 {
  float x, y, scale, timeOffset; color leafColor, trunkColor;
  // PERBAIKAN SYNTAX: Menambahkan tipe data 'float' pada parameter y dan scale
  NativeTree4(float x, float y, float scale, color leafColor) {
    this.x = x; this.y = y; this.scale = scale; this.leafColor = leafColor; this.trunkColor = color(110, 85, 60); this.timeOffset = random(1000);
  }
  void display() {
    pushMatrix(); translate(x, y); rotate(sin((sceneTime * 0.0015) + timeOffset) * 0.03);
    drawTrunk(); draw3LayerLeaves(); drawFriendlyFace(); popMatrix();
  }
  void drawTrunk() { fill(trunkColor); noStroke(); rect(-12 * scale, -100 * scale, 24 * scale, 100 * scale); }
  void draw3LayerLeaves() {
    float t = (sceneTime * 0.001) + timeOffset;
    fill(lerpColor(leafColor, color(0, 30, 0), 0.3), 230); drawLeafCluster(sin(t*0.4)*5, -110*scale + cos(t*0.3)*3, 130*scale, 90*scale);
    fill(leafColor, 210); drawLeafCluster(sin(t*0.8+1)*10, -130*scale + cos(t*0.7+1)*6, 110*scale, 80*scale);
    fill(lerpColor(leafColor, color(255), 0.15), 180); drawLeafCluster(sin(t*1.5+2)*15, -145*scale + cos(t*1.2+2)*8, 90*scale, 60*scale);
  }
  void drawLeafCluster(float cx, float cy, float w, float h) { ellipse(cx, cy, w, h); ellipse(cx - w*0.3, cy + h*0.2, w*0.7, h*0.7); ellipse(cx + w*0.3, cy + h*0.2, w*0.7, h*0.7); }
  void drawFriendlyFace() {
    fill(40); ellipse(-7*scale, -60*scale, 5*scale, 7*scale); ellipse(7*scale, -60*scale, 5*scale, 7*scale);
    noFill(); stroke(40); strokeWeight(2); arc(0, -50*scale, 15*scale, 10*scale, 0, PI); noStroke();
  }
}

class OldBanyan4 extends NativeTree4 {
  OldBanyan4(float x, float y, float scale) { super(x, y, scale, color(30, 100, 50)); }
  @Override void drawTrunk() { fill(trunkColor); rect(-40 * scale, -140 * scale, 80 * scale, 140 * scale); }
  @Override void drawFriendlyFace() {
    fill(40); ellipse(-12*scale, -80*scale, 8*scale, 10*scale); ellipse(12*scale, -80*scale, 8*scale, 10*scale);
    noFill(); stroke(40); strokeWeight(3); arc(0, -65*scale, 30*scale, 20*scale, 0, PI); noStroke();
  }
}

class PalmTree4 {
  float x, y, scale;
  PalmTree4(float x, float y, float scale) { this.x = x; this.y = y; this.scale = scale; }
  void display() {
    pushMatrix(); translate(x + sin(sceneTime * 0.002 + x) * 3, y); scale(scale);
    fill(120, 75, 35); stroke(80, 45, 20); strokeWeight(2);
    for (int i = 0; i < 7; i++) { float yy = -i * 18; ellipse(0, yy, 90 - i * 6, 32); }
    stroke(70, 40, 20); strokeWeight(3);
    for (int i = 0; i < 8; i++) { line(-35, -i * 15, 0, -i * 15 - 18); line(35, -i * 15, 0, -i * 15 - 18); }
    float topX = 0, topY = -125;
    drawCurvedLeaf(topX, topY, 70, -220); drawCurvedLeaf(topX, topY, 40, -230); drawCurvedLeaf(topX, topY, 15, -220);
    drawCurvedLeaf(topX, topY, -70, 230); drawCurvedLeaf(topX, topY, -40, 220); drawCurvedLeaf(topX, topY, -15, 210);
    drawFriendlyFace(topX, topY + 25); popMatrix();
  }
  void drawCurvedLeaf(float lx, float ly, float angle, float len) {
    pushMatrix(); translate(lx, ly); rotate(radians(angle)); stroke(80, 120, 35); strokeWeight(8); noFill(); bezier(0, 0, len * 0.35, -45, len * 0.7, -45, len, 25);
    stroke(25, 120, 35); strokeWeight(3); float step = (len > 0) ? 14 : -14;
    for (float i = (len > 0 ? 20 : -20); (len > 0) ? i < len : i > len; i += step) {
      float t = abs(i)/abs(len); float px = bezierPoint(0, len * 0.35, len * 0.7, len, t); float py = bezierPoint(0, -45, -45, 25, t);
      line(px, py, px - 10, py - 35); line(px, py, px + 10, py + 35);
    }
    popMatrix();
  }
  void drawFriendlyFace(float fx, float fy) {
    pushMatrix(); translate(fx, fy); fill(20, 80, 20); noStroke(); ellipse(-5, 0, 4, 6); ellipse(5, 0, 4, 6);
    noFill(); stroke(20, 80, 20); strokeWeight(2); arc(0, 8, 14, 10, 0, PI);
    if (sin(sceneTime * 0.005 + x) > 0.97) { fill(120, 75, 35); noStroke(); rect(-7, -4, 14, 7); }
    popMatrix();
  }
}

class PalmTree5 {
  float x, y, scale; boolean holdsDeed;
  PalmTree5(float x, float y, float scale, boolean holdsDeed) { this.x = x; this.y = y; this.scale = scale; this.holdsDeed = holdsDeed; }
  void display() {
    pushMatrix(); translate(x, y); scale(scale);
    fill(120, 75, 35); stroke(80, 45, 20); strokeWeight(2);
    for (int i = 0; i < 7; i++) { float yy = -i * 18; ellipse(0, yy, 90 - i * 6, 32); }
    stroke(70, 40, 20); strokeWeight(3);
    for (int i = 0; i < 8; i++) { line(-35, -i * 15, 0, -i * 15 - 18); line(35, -i * 15, 0, -i * 15 - 18); }
    float topX = 0, topY = -125;
    drawCustomCurvedLeaf(topX, topY, 70, -220); drawCustomCurvedLeaf(topX, topY, 40, -230); drawCustomCurvedLeaf(topX, topY, 15, -220);
    drawCustomCurvedLeaf(topX, topY, -70, 230); drawCustomCurvedLeaf(topX, topY, -40, 220); drawCustomCurvedLeaf(topX, topY, -15, 210);
    drawArrogantFace(topX, topY + 25);
    if (holdsDeed) { drawLandDeed(topX + 45, topY + 60); }
    popMatrix();
  }
  void drawCustomCurvedLeaf(float x, float y, float angle, float len) {
    pushMatrix(); translate(x, y); rotate(radians(angle)); stroke(80, 120, 35); strokeWeight(8); noFill(); bezier(0, 0, len * 0.35, -45, len * 0.7, -45, len, 25);
    stroke(25, 120, 35); strokeWeight(3); float step = (len > 0) ? 14 : -14;
    for (float i = (len > 0 ? 20 : -20); (len > 0) ? i < len : i > len; i += step) {
      float t = abs(i)/abs(len); float px = bezierPoint(0, len * 0.35, len * 0.7, len, t); float py = bezierPoint(0, -45, -45, 25, t);
      line(px, py, px - 10, py - 35); line(px, py, px + 10, py + 35);
    }
    popMatrix();
  }
  void drawArrogantFace(float fx, float fy) {
    pushMatrix(); translate(fx, fy); stroke(20, 50, 20); strokeWeight(2.5); line(-8, -6, -2, -1); line(8, -6, 2, -1);
    fill(20, 50, 20); noStroke(); ellipse(-5, 2, 4, 4); ellipse(5, 2, 4, 4);
    noFill(); stroke(20, 50, 20); strokeWeight(2.5); bezier(-6, 14, -2, 16, 4, 9, 8, 12); popMatrix(); noStroke();
  }
  void drawLandDeed(float lx, float ly) {
    pushMatrix(); translate(lx, ly); rotate(radians(-10)); fill(255); stroke(150); strokeWeight(1.5); rect(0, 0, 35, 48, 2);
    stroke(60); strokeWeight(1); line(5, 10, 30, 10); line(5, 18, 24, 18); line(5, 26, 30, 26);
    fill(230, 50, 50); noStroke(); ellipse(25, 36, 7, 7); popMatrix();
  }
}

class NativeTree5 {
  float x, y, scale, timeOffset; color leafColor, trunkColor;
  NativeTree5(float x, float y, float scale, color leafColor) {
    this.x = x; this.y = y; this.scale = scale; this.leafColor = leafColor; this.trunkColor = color(110, 85, 60); this.timeOffset = random(1000);
  }
  void display() {
    pushMatrix(); translate(x, y); translate(sin(sceneTime * 0.05) * 0.6, 0);
    drawTrunk(); draw3LayerLeaves(); drawShockedFace(); popMatrix();
  }
  void drawTrunk() { fill(trunkColor); noStroke(); rect(-12 * scale, -100 * scale, 24 * scale, 100 * scale); }
  void draw3LayerLeaves() {
    float t = (sceneTime * 0.001) + timeOffset;
    fill(lerpColor(leafColor, color(0, 30, 0), 0.3), 230); drawLeafCluster(sin(t*0.4)*3, -110*scale + cos(t*0.3)*2, 130*scale, 90*scale);
    fill(leafColor, 210); drawLeafCluster(sin(t*0.8+1)*6, -130*scale + cos(t*0.7+1)*4, 110*scale, 80*scale);
    fill(lerpColor(leafColor, color(255), 0.1), 180); drawLeafCluster(sin(t*1.5+2)*9, -145*scale + cos(t*1.2+2)*5, 90*scale, 60*scale);
  }
  void drawLeafCluster(float cx, float cy, float w, float h) { ellipse(cx, cy, w, h); ellipse(cx - w*0.3, cy + h*0.2, w*0.7, h*0.7); ellipse(cx + w*0.3, cy + h*0.2, w*0.7, h*0.7); }
  void drawShockedFace() {
    fill(40); ellipse(-8 * scale, -60 * scale, 7 * scale, 7 * scale); ellipse(8 * scale, -60 * scale, 7 * scale, 7 * scale);
    noFill(); stroke(40); strokeWeight(2.5 * scale); ellipse(0, -46 * scale, 8 * scale, 12 * scale); noStroke();
  }
}

class OldBanyan5 extends NativeTree5 {
  OldBanyan5(float x, float y, float scale) { super(x, y, scale, color(30, 100, 50)); }
  @Override void drawTrunk() { fill(trunkColor); rect(-40 * scale, -140 * scale, 80 * scale, 140 * scale); }
  @Override void drawShockedFace() {
    fill(40); ellipse(-14 * scale, -85 * scale, 11 * scale, 11 * scale); ellipse(14 * scale, -85 * scale, 11 * scale, 11 * scale);
    noFill(); stroke(40); strokeWeight(3); arc(-14 * scale, -98 * scale, 14 * scale, 6 * scale, 0, PI); arc(14 * scale, -98 * scale, 14 * scale, 6 * scale, 0, PI);
    ellipse(0, -62 * scale, 16 * scale, 24 * scale); noStroke();
  }
}

class PalmTree6 {
  float x, y, scale;
  PalmTree6(float x, float y, float scale) { this.x = x; this.y = y; this.scale = scale; }
  void display() {
    pushMatrix(); translate(x, y); scale(scale);
    fill(120, 75, 35); stroke(80, 45, 20); strokeWeight(2);
    for (int i = 0; i < 7; i++) { float yy = -i * 18; ellipse(0, yy, 90 - i * 6, 32); }
    stroke(70, 40, 20); strokeWeight(3);
    for (int i = 0; i < 8; i++) { line(-35, -i * 15, 0, -i * 15 - 18); line(35, -i * 15, 0, -i * 15 - 18); }
    float topX = 0, topY = -125;
    drawCustomCurvedLeaf(topX, topY, 70, -220); drawCustomCurvedLeaf(topX, topY, 40, -230); drawCustomCurvedLeaf(topX, topY, 15, -220);
    drawCustomCurvedLeaf(topX, topY, -70, 230); drawCustomCurvedLeaf(topX, topY, -40, 220); drawCustomCurvedLeaf(topX, topY, -15, 210);
    drawArrogantFace(topX, topY + 25); popMatrix();
  }
  void drawCustomCurvedLeaf(float lx, float ly, float angle, float len) {
    pushMatrix(); translate(lx, ly); rotate(radians(angle)); stroke(80, 120, 35); strokeWeight(8); noFill(); bezier(0, 0, len * 0.35, -45, len * 0.7, -45, len, 25);
    stroke(25, 120, 35); strokeWeight(3); float step = (len > 0) ? 14 : -14;
    for (float i = (len > 0 ? 20 : -20); (len > 0) ? i < len : i > len; i += step) {
      float t = abs(i)/abs(len); float px = bezierPoint(0, len * 0.35, len * 0.7, len, t); float py = bezierPoint(0, -45, -45, 25, t);
      line(px, py, px - 10, py - 35); line(px, py, px + 10, py + 35);
    }
    popMatrix();
  }
  void drawArrogantFace(float fx, float fy) {
    pushMatrix(); translate(fx, fy); stroke(20, 50, 20); strokeWeight(2.5); line(-8, -6, -2, -1); line(8, -6, 2, -1);
    fill(20, 50, 20); noStroke(); ellipse(-5, 2, 4, 4); ellipse(5, 2, 4, 4);
    noFill(); stroke(20, 50, 20); strokeWeight(2.5); bezier(-6, 14, -2, 16, 4, 9, 8, 12); popMatrix(); noStroke();
  }
}

class MigratingTree7 {
  float startX, targetY, scale, currentX, currentY, walkOffset; color leafColor, trunkColor;
  MigratingTree7(float x, float y, float scale, color leafColor, float walkOffset) {
    this.startX = x; this.targetY = y; this.scale = scale; this.leafColor = leafColor; this.trunkColor = color(95, 75, 55); this.walkOffset = walkOffset;
  }
  void updateAndDisplay() {
    float time = sceneTime * 0.002 + walkOffset; 
    float walkCycle = sin(time);
    currentX = startX - (sceneTime * 0.015 % 150); 
    currentY = map(currentX, 0, width, 300, 520) + abs(walkCycle) * -8 * scale;
    pushMatrix(); translate(currentX, currentY); rotate(walkCycle * 0.04);
    drawTrunk(); draw3LayerLeaves(); drawSadFace(); popMatrix();
  }
  void drawTrunk() { fill(trunkColor); noStroke(); rect(-12 * scale, -100 * scale, 24 * scale, 100 * scale); }
  void draw3LayerLeaves() {
    float t = (sceneTime * 0.001) + walkOffset;
    fill(lerpColor(leafColor, color(0, 20, 0), 0.3), 220); drawLeafCluster(sin(t*0.3)*2, -110*scale, 130*scale, 90*scale);
    fill(leafColor, 200); drawLeafCluster(sin(t*0.5)*4, -130*scale, 110*scale, 80*scale);
    fill(lerpColor(leafColor, color(200), 0.05), 180); drawLeafCluster(sin(t*0.8)*5, -145*scale, 90*scale, 60*scale);
  }
  void drawLeafCluster(float cx, float cy, float w, float h) { ellipse(cx, cy, w, h); ellipse(cx - w*0.3, cy + h*0.2, w*0.7, h*0.7); ellipse(cx + w*0.3, cy + h*0.2, w*0.7, h*0.7); }
  void drawSadFace() {
    fill(50); noStroke(); ellipse(-7 * scale, -58 * scale, 5 * scale, 5 * scale); ellipse(7 * scale, -58 * scale, 5 * scale, 5 * scale);
    stroke(50); strokeWeight(1.5 * scale); noFill(); arc(-7 * scale, -64 * scale, 8 * scale, 4 * scale, 0, PI); arc(7 * scale, -64 * scale, 8 * scale, 4 * scale, 0, PI);
    arc(0, -42 * scale, 12 * scale, 8 * scale, PI, TWO_PI); noStroke();
  }
}

class MigratingBanyan7 extends MigratingTree7 {
  MigratingBanyan7(float x, float y, float scale, float walkOffset) { super(x, y, scale, color(40, 85, 45), walkOffset); }
  @Override void drawTrunk() { fill(trunkColor); rect(-40 * scale, -140 * scale, 80 * scale, 140 * scale); }
  @Override void drawSadFace() {
    fill(50); ellipse(-12 * scale, -80 * scale, 8 * scale, 8 * scale); ellipse(12 * scale, -80 * scale, 8 * scale, 8 * scale);
    stroke(50); strokeWeight(2.5 * scale); noFill(); arc(-12 * scale, -90 * scale, 12 * scale, 6 * scale, 0, PI); arc(12 * scale, -90 * scale, 12 * scale, 6 * scale, 0, PI);
    arc(0, -58 * scale, 24 * scale, 14 * scale, PI, TWO_PI); noStroke();
  }
}

class StaticPalm7 {
  float x, y, scale;
  StaticPalm7(float x, float y, float scale) { this.x = x; this.y = y; this.scale = scale; }
  void display() {
    pushMatrix(); translate(x, y); scale(scale);
    fill(110, 70, 30); stroke(70, 40, 15); strokeWeight(2);
    for (int i = 0; i < 7; i++) { float yy = -i * 18; ellipse(0, yy, 90 - i * 6, 32); }
    stroke(60, 35, 15); strokeWeight(3);
    for (int i = 0; i < 8; i++) { line(-35, -i * 15, 0, -i * 15 - 18); line(35, -i * 15, 0, -i * 15 - 18); }
    float topX = 0, topY = -125;
    drawCustomCurvedLeaf(topX, topY, 70, -220); drawCustomCurvedLeaf(topX, topY, 40, -230); drawCustomCurvedLeaf(topX, topY, 15, -220);
    drawCustomCurvedLeaf(topX, topY, -70, 230); drawCustomCurvedLeaf(topX, topY, -40, 220); drawCustomCurvedLeaf(topX, topY, -15, 210);
    drawSternFace(topX, topY + 25); popMatrix();
  }
  void drawCustomCurvedLeaf(float lx, float ly, float angle, float len) {
    pushMatrix(); translate(lx, ly); rotate(radians(angle)); stroke(75, 110, 30); strokeWeight(8); noFill(); bezier(0, 0, len * 0.35, -45, len * 0.7, -45, len, 25);
    stroke(25, 110, 30); strokeWeight(3); float step = (len > 0) ? 14 : -14;
    for (float i = (len > 0 ? 20 : -20); (len > 0) ? i < len : i > len; i += step) {
      float t = abs(i)/abs(len); float px = bezierPoint(0, len * 0.35, len * 0.7, len, t); float py = bezierPoint(0, -45, -45, 25, t);
      line(px, py, px - 10, py - 35); line(px, py, px + 10, py + 35);
    }
    popMatrix();
  }
  void drawSternFace(float fx, float fy) {
    pushMatrix(); translate(fx, fy); stroke(20, 40, 20); strokeWeight(2.5); line(-8, -6, -2, -2); line(8, -6, 2, -2);
    fill(20, 40, 20); noStroke(); ellipse(-5, 2, 4, 4); ellipse(5, 2, 4, 4);
    noFill(); stroke(20, 40, 20); strokeWeight(2.5); line(-6, 14, 6, 12); popMatrix(); noStroke();
  }
}

class ContinuousMigratingTree8 {
  float startX, scale, currentX, currentY, walkOffset; color leafColor, trunkColor;
  ContinuousMigratingTree8(float x, float scale, color leafColor, float walkOffset) {
    this.startX = x; this.scale = scale; this.leafColor = leafColor; this.trunkColor = color(90, 70, 50); this.walkOffset = walkOffset;
  }
  void updateAndDisplay() {
    float time = sceneTime * 0.0018 + walkOffset; 
    float walkCycle = sin(time);
    currentX = startX - (sceneTime * 0.012 % 150); 
    currentY = map(currentX, 0, width, 240, 550) + abs(walkCycle) * -7 * scale;
    pushMatrix(); translate(currentX, currentY); rotate(-0.05 + walkCycle * 0.03);
    drawTrunk(); draw3LayerLeaves(); drawExhaustedSadFace(); popMatrix();
  }
  void drawTrunk() { fill(trunkColor); noStroke(); rect(-12 * scale, -100 * scale, 24 * scale, 100 * scale); }
  void draw3LayerLeaves() {
    float t = (sceneTime * 0.0008) + walkOffset;
    fill(lerpColor(leafColor, color(0, 15, 0), 0.35), 210); drawLeafCluster(sin(t)*1 - 2, -110*scale, 130*scale, 90*scale);
    fill(leafColor, 190); drawLeafCluster(sin(t*1.2)*2 - 4, -130*scale, 110*scale, 80*scale);
    fill(lerpColor(leafColor, color(180), 0.05), 170); drawLeafCluster(sin(t*1.5)*2 - 5, -145*scale, 90*scale, 60*scale);
  }
  void drawLeafCluster(float cx, float cy, float w, float h) { ellipse(cx, cy, w, h); ellipse(cx - w*0.3, cy + h*0.2, w*0.7, h*0.7); ellipse(cx + w*0.3, cy + h*0.2, w*0.7, h*0.7); }
  void drawExhaustedSadFace() {
    fill(55); noStroke(); ellipse(-7 * scale, -58 * scale, 5 * scale, 4 * scale); ellipse(7 * scale, -58 * scale, 5 * scale, 4 * scale);
    stroke(55); strokeWeight(1.5 * scale); noFill(); arc(-7 * scale, -63 * scale, 7 * scale, 3 * scale, 0, PI); arc(7 * scale, -63 * scale, 7 * scale, 3 * scale, 0, PI);
    arc(0, -44 * scale, 10 * scale, 6 * scale, PI, TWO_PI); noStroke();
  }
}

class ContinuousMigratingBanyan8 extends ContinuousMigratingTree8 {
  ContinuousMigratingBanyan8(float x, float scale, float walkOffset) { super(x, scale, color(35, 75, 40), walkOffset); }
  @Override void drawTrunk() { fill(trunkColor); rect(-40 * scale, -140 * scale, 80 * scale, 140 * scale); }
  @Override void drawExhaustedSadFace() {
    fill(55); ellipse(-12 * scale, -80 * scale, 8 * scale, 7 * scale); ellipse(12 * scale, -80 * scale, 8 * scale, 7 * scale);
    stroke(55); strokeWeight(2.5 * scale); noFill(); arc(-12 * scale, -88 * scale, 11 * scale, 5 * scale, 0, PI); arc(12 * scale, -88 * scale, 11 * scale, 5 * scale, 0, PI);
    arc(0, -60 * scale, 22 * scale, 10 * scale, PI, TWO_PI); noStroke();
  }
}

class MonoculturePalm9A {
  float x, y, scale; boolean expressionPuas;
  MonoculturePalm9A(float x, float y, float scale, boolean expressionPuas) { this.x = x; this.y = y; this.scale = scale; this.expressionPuas = expressionPuas; }
  void display() {
    pushMatrix(); translate(x, y); scale(scale);
    fill(120, 75, 35); stroke(80, 45, 20); strokeWeight(2);
    for (int i = 0; i < 7; i++) { float yy = -i * 18; ellipse(0, yy, 90 - i * 6, 32); }
    stroke(70, 40, 20); strokeWeight(3);
    for (int i = 0; i < 8; i++) { line(-35, -i * 15, 0, -i * 15 - 18); line(35, -i * 15, 0, -i * 15 - 18); }
    float topX = 0, topY = -125;
    drawCustomCurvedLeaf(topX, topY, 70, -220); drawCustomCurvedLeaf(topX, topY, 40, -230); drawCustomCurvedLeaf(topX, topY, 15, -220);
    drawCustomCurvedLeaf(topX, topY, -70, 230); drawCustomCurvedLeaf(topX, topY, -40, 220); drawCustomCurvedLeaf(topX, topY, -15, 210);
    if (expressionPuas) { drawArrogantFace(topX, topY + 25); } else { drawFlatExpressionFace(topX, topY + 25); }
    popMatrix();
  }
  void drawCustomCurvedLeaf(float lx, float ly, float angle, float len) {
    pushMatrix(); translate(lx, ly); rotate(radians(angle)); stroke(85, 125, 35); strokeWeight(8); noFill(); bezier(0, 0, len * 0.35, -45, len * 0.7, -45, len, 25);
    stroke(25, 125, 35); strokeWeight(3); float step = (len > 0) ? 14 : -14;
    for (float i = (len > 0 ? 20 : -20); (len > 0) ? i < len : i > len; i += step) {
      float t = abs(i)/abs(len); float px = bezierPoint(0, len * 0.35, len * 0.7, len, t); float py = bezierPoint(0, -45, -45, 25, t);
      line(px, py, px - 10, py - 35); line(px, py, px + 10, py + 35);
    }
    popMatrix();
  }
  void drawArrogantFace(float fx, float fy) {
    pushMatrix(); translate(fx, fy); stroke(20, 50, 20); strokeWeight(2.5); line(-8, -6, -2, -1); line(8, -6, 2, -1);
    fill(20, 50, 20); noStroke(); ellipse(-5, 2, 4, 4); ellipse(5, 2, 4, 4);
    noFill(); stroke(20, 50, 20); strokeWeight(2.5); bezier(-7, 10, -3, 16, 3, 16, 7, 10); popMatrix(); noStroke();
  }
  void drawFlatExpressionFace(float fx, float fy) {
    pushMatrix(); translate(fx, fy); fill(20, 50, 20); noStroke(); ellipse(-5, 0, 4, 5); ellipse(5, 0, 4, 5);
    stroke(20, 50, 20); strokeWeight(2.5); line(-6, 12, 6, 12); popMatrix(); noStroke();
  }
}

class MonoculturePalm9B {
  float x, y, scale;
  MonoculturePalm9B(float x, float y, float scale) { this.x = x; this.y = y; this.scale = scale; }
  void display() {
    pushMatrix(); translate(x, y); scale(scale);
    fill(100, 60, 25); stroke(65, 35, 15); strokeWeight(2);
    for (int i = 0; i < 7; i++) { float yy = -i * 18; ellipse(0, yy, 90 - i * 6, 32); }
    stroke(55, 30, 10); strokeWeight(3);
    for (int i = 0; i < 8; i++) { line(-35, -i * 15, 0, -i * 15 - 18); line(35, -i * 15, 0, -i * 15 - 18); }
    float topX = 0, topY = -125;
    drawCustomCurvedLeaf(topX, topY, 70, -220); drawCustomCurvedLeaf(topX, topY, 40, -230); drawCustomCurvedLeaf(topX, topY, 15, -220);
    drawCustomCurvedLeaf(topX, topY, -70, 230); drawCustomCurvedLeaf(topX, topY, -40, 220); drawCustomCurvedLeaf(topX, topY, -15, 210);
    drawArrogantFace(topX, topY + 25); popMatrix();
  }
  void drawCustomCurvedLeaf(float lx, float ly, float angle, float len) {
    pushMatrix(); translate(lx, ly); rotate(radians(angle)); stroke(80, 115, 30); strokeWeight(8); noFill(); bezier(0, 0, len * 0.35, -45, len * 0.7, -45, len, 25);
    stroke(20, 105, 25); strokeWeight(3); float step = (len > 0) ? 14 : -14;
    for (float i = (len > 0 ? 20 : -20); (len > 0) ? i < len : i > len; i += step) {
      float t = abs(i)/abs(len); float px = bezierPoint(0, len * 0.35, len * 0.7, len, t); float py = bezierPoint(0, -45, -45, 25, t);
      line(px, py, px - 10, py - 35); line(px, py, px + 10, py + 35);
    }
    popMatrix();
  }
  void drawArrogantFace(float fx, float fy) {
    pushMatrix(); translate(fx, fy); stroke(20, 40, 10); strokeWeight(2.5); line(-8, -6, -2, -1); line(8, -6, 2, -1);
    fill(20, 40, 10); noStroke(); ellipse(-5, 2, 4, 4); ellipse(5, 2, 4, 4);
    noFill(); stroke(20, 40, 10); strokeWeight(2.5); bezier(-7, 10, -3, 16, 3, 16, 7, 10); popMatrix(); noStroke();
  }
}

class MonoculturePalm10 {
  float x, y, scale;
  MonoculturePalm10(float x, float y, float scale) { this.x = x; this.y = y; this.scale = scale; }
  void display(float progress) {
    pushMatrix(); 
    float windSway = sin(sceneTime * 0.003 + x) * (2 + progress * 5);
    translate(x + windSway, y); 
    scale(scale);
    
    color trunkColor = lerpColor(color(100, 60, 25), color(45, 30, 15), progress);
    fill(trunkColor); 
    stroke(35, 20, 10); 
    strokeWeight(2);
    for (int i = 0; i < 7; i++) { float yy = -i * 18; ellipse(0, yy, 90 - i * 6, 32); }
    
    color vColor = lerpColor(color(70, 40, 20), color(25, 15, 5), progress);
    stroke(vColor); 
    strokeWeight(3);
    for (int i = 0; i < 8; i++) { 
      line(-35, -i * 15, 0, -i * 15 - 18); 
      line(35, -i * 15, 0, -i * 15 - 18); 
    }
    
    float topX = 0, topY = -125;
    color leafColor = lerpColor(color(80, 115, 30), color(35, 55, 15), progress);
    drawCustomCurvedLeaf(topX, topY, 70, -220, leafColor); 
    drawCustomCurvedLeaf(topX, topY, 40, -230, leafColor); 
    drawCustomCurvedLeaf(topX, topY, 15, -220, leafColor);
    drawCustomCurvedLeaf(topX, topY, -70, 230, leafColor); 
    drawCustomCurvedLeaf(topX, topY, -40, 220, leafColor); 
    drawCustomCurvedLeaf(topX, topY, -15, 210, leafColor);
    
    drawDynamicFace(topX, topY + 25, progress); 
    popMatrix();
  }
  
  void drawCustomCurvedLeaf(float lx, float ly, float angle, float len, color lc) {
    pushMatrix(); translate(lx, ly); rotate(radians(angle)); 
    stroke(lc); strokeWeight(8); noFill(); 
    bezier(0, 0, len * 0.35, -45, len * 0.7, -45, len, 25);
    stroke(lerpColor(lc, color(0), 0.2)); strokeWeight(3); 
    float step = (len > 0) ? 14 : -14;
    for (float i = (len > 0 ? 20 : -20); (len > 0) ? i < len : i > len; i += step) {
      float t = abs(i)/abs(len); 
      float px = bezierPoint(0, len * 0.35, len * 0.7, len, t); 
      float py = bezierPoint(0, -45, -45, 25, t);
      line(px, py, px - 10, py - 35); 
      line(px, py, px + 10, py + 35);
    }
    popMatrix();
  }
  
  void drawDynamicFace(float fx, float fy, float progress) {
    pushMatrix(); translate(fx, fy);
    if (progress < 0.4) {
      stroke(15, 25, 10); strokeWeight(2.5); line(-8, -5, -2, -2); line(8, -5, 2, -2);
      fill(15, 25, 10); noStroke(); ellipse(-5, 2, 4, 4); ellipse(5, 2, 4, 4);
      noFill(); stroke(15, 25, 10); strokeWeight(2.5); line(-6, 12, 6, 12);
    } else {
      stroke(15, 25, 10); strokeWeight(2);
      line(-8, -2, -2, -6); line(8, -2, 2, -6);
      fill(15, 25, 10); noStroke(); 
      ellipse(-5, 1, 5, 5); ellipse(5, 1, 5, 5);
      noFill(); stroke(15, 25, 10); strokeWeight(2.5);
      arc(0, 15, 12, 10, PI, TWO_PI);
    }
    popMatrix(); noStroke();
  }
}

class RainDrop10 {
  float x, y, speed, len;
  RainDrop10() { initRandomPosition(); y = random(-height, 0); }
  void initRandomPosition() {
    x = random(0, width); y = random(-50, -10);
    speed = random(12, 22); len = random(14, 28);
  }
  void updateAndRender(float progress) {
    y += speed; x += map(progress, 0, 1, 1, -4);
    float currentAlpha = map(progress, 0.0, 0.5, 70, 170);
    stroke(175, 195, 220, currentAlpha);
    line(x, y, x - (progress * 2), y + len);
    if (y > height - floodLevel10) { initRandomPosition(); }
  }
}

class FloatingPalm11 {
  float x, y, scale, rot, driftSpeed;
  FloatingPalm11(float x, float y, float scale) {
    this.x = x; this.y = y; this.scale = scale;
    this.driftSpeed = random(0.8, 1.8); 
    this.rot = random(-PI/3, PI/3);
  }
  void display() {
    x += driftSpeed;
    if (x > width + 150) x = -150; 
    float bob = sin(sceneTime * 0.0015 + x * 0.01) * 20; 
    float currentRot = rot + sin(sceneTime * 0.001 + x * 0.01) * 0.15; 
    
    pushMatrix(); translate(x, y + bob); rotate(currentRot); scale(scale);
    
    color trunkColor = color(45, 30, 15);
    fill(trunkColor); stroke(35, 20, 10); strokeWeight(2);
    for (int i = 0; i < 7; i++) { float yy = -i * 18; ellipse(0, yy, 90 - i * 6, 32); }
    
    color vColor = color(25, 15, 5);
    stroke(vColor); strokeWeight(3);
    for (int i = 0; i < 8; i++) { line(-35, -i * 15, 0, -i * 15 - 18); line(35, -i * 15, 0, -i * 15 - 18); }
    
    float topX = 0, topY = -125;
    color leafColor = color(35, 55, 15);
    drawCustomCurvedLeaf(topX, topY, 70, -220, leafColor); 
    drawCustomCurvedLeaf(topX, topY, 40, -230, leafColor); 
    drawCustomCurvedLeaf(topX, topY, 15, -220, leafColor);
    drawCustomCurvedLeaf(topX, topY, -70, 230, leafColor); 
    drawCustomCurvedLeaf(topX, topY, -40, 220, leafColor); 
    drawCustomCurvedLeaf(topX, topY, -15, 210, leafColor);
    
    drawPanickedFace(topX, topY + 25); popMatrix();
  }
  
  void drawCustomCurvedLeaf(float lx, float ly, float angle, float len, color lc) {
    pushMatrix(); translate(lx, ly); rotate(radians(angle)); stroke(lc); strokeWeight(8); noFill(); bezier(0, 0, len * 0.35, -45, len * 0.7, -45, len, 25);
    stroke(lerpColor(lc, color(0), 0.2)); strokeWeight(3); float step = (len > 0) ? 14 : -14;
    for (float i = (len > 0 ? 20 : -20); (len > 0) ? i < len : i > len; i += step) {
      float t = abs(i)/abs(len); float px = bezierPoint(0, len * 0.35, len * 0.7, len, t); float py = bezierPoint(0, -45, -45, 25, t);
      line(px, py, px - 10, py - 35); line(px, py, px + 10, py + 35);
    }
    popMatrix();
  }
  void drawPanickedFace(float fx, float fy) {
    pushMatrix(); translate(fx, fy); stroke(15, 25, 10); strokeWeight(2);
    line(-8, -6, -2, -10); line(8, -6, 2, -10);
    fill(15, 25, 10); noStroke(); ellipse(-5, 0, 6, 6); ellipse(5, 0, 6, 6);
    noFill(); stroke(15, 25, 10); strokeWeight(3); ellipse(0, 12, 8, 14);
    popMatrix(); noStroke();
  }
}

class Debris12 {
  float x, y, rot, w, h;
  int type; color col;
  
  Debris12(float x, float y) {
    this.x = x; this.y = y;
    this.rot = random(TWO_PI);
    this.w = random(30, 90);
    this.h = random(8, 15);
    this.type = (int)random(2);
    this.col = color(random(40, 60), random(30, 40), random(20, 30));
  }
  
  void display() {
    pushMatrix();
    translate(x, y);
    rotate(rot);
    fill(col);
    noStroke();
    if (type == 0) {
      rect(-w/2, -h/2, w, h, 3); // Patahan kayu panjang
    } else {
      ellipse(0, 0, w * 0.6, h * 1.5); // Gumpalan akar/kayu
    }
    popMatrix();
  }
}

class PostFloodPalm12 {
  float x, y, scale;
  boolean isDead;
  float fallAngle;
  
  PostFloodPalm12(float x, float y, float scale, boolean isDead) {
    this.x = x; 
    this.y = y; 
    this.scale = scale; 
    this.isDead = isDead;
    // Jika mati, tentukan arah tumbang (kanan atau kiri) secara acak
    this.fallAngle = random(1) > 0.5 ? HALF_PI : -HALF_PI; 
  }
  
  void display() {
    pushMatrix(); 
    if (isDead) {
      // Tumbang/tertidur dan posisi disesuaikan agar menempel di tanah
      translate(x, y - (25 * scale)); 
      rotate(fallAngle + radians(random(-5, 5)));
    } else {
      // Selamat, berdiri tapi posisi agak miring 
      translate(x, y);
      rotate(radians(random(-5, 5))); 
    }
    scale(scale);
    
    fill(45, 35, 30); 
    stroke(20, 15, 10); 
    strokeWeight(2);
    for (int i = 0; i < 7; i++) { 
      float yy = -i * 18; 
      ellipse(0, yy, 90 - i * 6, 32); 
    }
    
    stroke(15, 10, 5); 
    strokeWeight(3);
    for (int i = 0; i < 8; i++) { 
      line(-35, -i * 15, 0, -i * 15 - 18); 
      line(35, -i * 15, 0, -i * 15 - 18); 
    }
    
    float topX = 0, topY = -125;
    
    if (isDead) {
      color deadLeafCol = color(160, 140, 80);
      drawWitheredLeaf(topX, topY, 140, 150, deadLeafCol);
      drawWitheredLeaf(topX, topY, 160, 180, deadLeafCol);
      drawWitheredLeaf(topX, topY, 180, 140, deadLeafCol);
      drawWitheredLeaf(topX, topY, 200, 190, deadLeafCol);
      drawWitheredLeaf(topX, topY, 220, 160, deadLeafCol);
      drawDeadFace(topX, topY + 25); 
    } else {
      color sadLeafCol = color(100, 110, 45); // Masih ada sisa-sisa hijau tapi agak layu
      drawWitheredLeaf(topX, topY, 120, 150, sadLeafCol);
      drawWitheredLeaf(topX, topY, 150, 180, sadLeafCol);
      drawWitheredLeaf(topX, topY, 180, 140, sadLeafCol);
      drawWitheredLeaf(topX, topY, 210, 190, sadLeafCol);
      drawWitheredLeaf(topX, topY, 240, 160, sadLeafCol);
      drawSurvivingSadFace(topX, topY + 25);
    }
    
    popMatrix();
  }
  
  void drawWitheredLeaf(float lx, float ly, float angle, float len, color lc) {
    pushMatrix(); 
    translate(lx, ly); 
    rotate(radians(angle)); 
    
    stroke(lc); 
    strokeWeight(5); 
    noFill(); 
    bezier(0, 0, 20, len * 0.4, -10, len * 0.7, 0, len);
    
    stroke(lerpColor(lc, color(50, 40, 20), 0.5)); 
    strokeWeight(2); 
    for (float i = 20; i < len; i += 12) {
      float t = i/len; 
      float px = bezierPoint(0, 20, -10, 0, t); 
      float py = bezierPoint(0, len * 0.4, len * 0.7, len, t);
      line(px, py, px - random(5, 15), py - random(10, 20)); 
      line(px, py, px + random(5, 15), py - random(10, 20));
    }
    popMatrix();
  }
  
  void drawDeadFace(float fx, float fy) {
    pushMatrix(); translate(fx, fy);
    stroke(15, 10, 5); strokeWeight(2.5);
    
    // Mata x x
    line(-8, -4, -3, 0); line(-3, -4, -8, 0); // Kiri
    line(8, -4, 3, 0); line(3, -4, 8, 0);    // Kanan
    
    // Mulut mangap / murung total
    noFill(); stroke(15, 10, 5); strokeWeight(2.5);
    arc(0, 12, 10, 12, PI, TWO_PI);
    
    popMatrix(); noStroke();
  }
  
  void drawSurvivingSadFace(float fx, float fy) {
    pushMatrix(); translate(fx, fy);
    stroke(15, 10, 5); strokeWeight(2.5);
    
    // Alis sedih turun ke bawah
    line(-8, -2, -2, -6); 
    line(8, -2, 2, -6);
    
    // Mata sayu bulat
    fill(15, 10, 5); noStroke(); 
    ellipse(-5, 1, 5, 5); 
    ellipse(5, 1, 5, 5);
    
    // Mulut sangat sedih melengkung ke bawah
    noFill(); stroke(15, 10, 5); strokeWeight(3);
    arc(0, 16, 12, 10, PI, TWO_PI);
    
    popMatrix(); noStroke();
  }
}

// ---------------------------------------------------------------------------------
// Pohon hutan (penerima permintaan maaf): dari waspada menjadi memaafkan
// ---------------------------------------------------------------------------------
class NativeTree13 {
  float x, y, scale, timeOffset;
  color leafColor, trunkColor;

  NativeTree13(float x, float y, float scale, color leafColor) {
    this.x = x; this.y = y; this.scale = scale;
    this.leafColor = leafColor;
    this.trunkColor = color(110, 85, 60);
    this.timeOffset = random(1000);
  }

  void display(float progress) {
    pushMatrix();
    translate(x, y);
    rotate(sin((sceneTime * 0.0012) + timeOffset) * 0.02);
    drawTrunk();
    draw3LayerLeaves();
    if (progress < 0.55) drawWatchfulFace();
    else drawForgivingFace(progress);
    popMatrix();
  }

  void drawTrunk() {
    fill(trunkColor); noStroke();
    rect(-12 * scale, -100 * scale, 24 * scale, 100 * scale);
  }

  void draw3LayerLeaves() {
    float t = (sceneTime * 0.001) + timeOffset;
    fill(lerpColor(leafColor, color(0, 30, 0), 0.3), 230);
    drawLeafCluster(sin(t * 0.4) * 5, -110 * scale + cos(t * 0.3) * 3, 130 * scale, 90 * scale);
    fill(leafColor, 210);
    drawLeafCluster(sin(t * 0.8 + 1) * 10, -130 * scale + cos(t * 0.7 + 1) * 6, 110 * scale, 80 * scale);
    fill(lerpColor(leafColor, color(255), 0.15), 180);
    drawLeafCluster(sin(t * 1.5 + 2) * 15, -145 * scale + cos(t * 1.2 + 2) * 8, 90 * scale, 60 * scale);
  }

  void drawLeafCluster(float cx, float cy, float w, float h) {
    ellipse(cx, cy, w, h);
    ellipse(cx - w * 0.3, cy + h * 0.2, w * 0.7, h * 0.7);
    ellipse(cx + w * 0.3, cy + h * 0.2, w * 0.7, h * 0.7);
  }

  void drawWatchfulFace() {
    fill(40); noStroke();
    ellipse(-7 * scale, -60 * scale, 5 * scale, 7 * scale);
    ellipse(7 * scale, -60 * scale, 5 * scale, 7 * scale);
    stroke(40); strokeWeight(2); noFill();
    line(-10 * scale, -66 * scale, -4 * scale, -63 * scale); // alis tegang, waspada
    line(10 * scale, -66 * scale, 4 * scale, -63 * scale);
    arc(0, -50 * scale, 12 * scale, 6 * scale, 0, PI);
    noStroke();
  }

  void drawForgivingFace(float progress) {
    float warmth = constrain(map(progress, 0.55, 0.85, 0, 1), 0, 1);
    fill(40); noStroke();
    ellipse(-7 * scale, -60 * scale, 5 * scale, 7 * scale);
    ellipse(7 * scale, -60 * scale, 5 * scale, 7 * scale);
    stroke(40); strokeWeight(2); noFill();
    // Senyum yang perlahan melebar seiring sawit menunduk minta maaf
    arc(0, -50 * scale, 14 * scale, 8 * scale + (warmth * 4), 0, PI);
    noStroke();
  }
}

class OldBanyan13 extends NativeTree13 {
  OldBanyan13(float x, float y, float scale) {
    super(x, y, scale, color(30, 100, 50));
  }

  @Override
  void drawTrunk() {
    fill(trunkColor); noStroke();
    rect(-40 * scale, -140 * scale, 80 * scale, 140 * scale);
  }

  @Override
  void drawWatchfulFace() {
    fill(40); noStroke();
    ellipse(-12 * scale, -80 * scale, 8 * scale, 10 * scale);
    ellipse(12 * scale, -80 * scale, 8 * scale, 10 * scale);
    stroke(40); strokeWeight(3); noFill();
    line(-18 * scale, -92 * scale, -6 * scale, -86 * scale);
    line(18 * scale, -92 * scale, 6 * scale, -86 * scale);
    arc(0, -65 * scale, 26 * scale, 14 * scale, 0, PI);
    noStroke();
  }

  @Override
  void drawForgivingFace(float progress) {
    float warmth = constrain(map(progress, 0.55, 0.85, 0, 1), 0, 1);
    fill(40); noStroke();
    ellipse(-12 * scale, -80 * scale, 8 * scale, 10 * scale);
    ellipse(12 * scale, -80 * scale, 8 * scale, 10 * scale);
    stroke(40); strokeWeight(3); noFill();
    arc(0, -65 * scale, 30 * scale, 16 * scale + (warmth * 6), 0, PI);
    noStroke();
  }
}

// ---------------------------------------------------------------------------------
// Sawit yang selamat: berjalan mencari tempat tinggal baru, lalu menunduk hormat
// (setengah membungkuk) sebagai wujud permintaan maaf kepada hutan
// ---------------------------------------------------------------------------------
class SurvivorPalm13 {
  float startX, endX, y, scale;
  int order; // urutan berjalan supaya posisi akhir tidak saling tumpang tindih

  SurvivorPalm13(float startX, float y, float scale, int order) {
    this.startX = startX;
    this.endX = width * (0.55 + order * 0.08);
    this.y = y;
    this.scale = scale;
    this.order = order;
  }

  void display(float progress) {
    // Tahap berjalan: mencari tempat tinggal baru hingga akhirnya tiba di hutan
    float walkProgress = constrain(map(progress, 0.0, 0.5, 0, 1), 0, 1);
    float x = lerp(startX, endX, walkProgress);
    float bob = sin(sceneTime * 0.006 + order) * 6 * (1 - walkProgress);

    // Tahap menunduk hormat (permintaan maaf): membungkuk sebagian, bukan rebah penuh
    float bowProgress = constrain(map(progress, 0.5, 0.75, 0, 1), 0, 1);
    float bowAngle = bowProgress * radians(38);
    float breathe = (bowProgress >= 1.0) ? sin(sceneTime * 0.0015 + order) * radians(2) : 0;

    pushMatrix();
    translate(x, y + bob);
    // Dibalik (negatif) supaya sawit menunduk hormat MENGARAH ke hutan di sisi kiri
    // (forestTrees13 & wiseBanyan13 berada di sekitar x = 0.02-0.42*width),
    // bukan malah membungkuk menjauhi hutan seperti sebelumnya.
    rotate(-(bowAngle + breathe));
    scale(scale);

    fill(90, 60, 30); stroke(60, 35, 15); strokeWeight(2);
    for (int i = 0; i < 7; i++) {
      float yy = -i * 18;
      ellipse(0, yy, 90 - i * 6, 32);
    }

    stroke(50, 30, 10); strokeWeight(3);
    for (int i = 0; i < 8; i++) {
      line(-35, -i * 15, 0, -i * 15 - 18);
      line(35, -i * 15, 0, -i * 15 - 18);
    }

    float topX = 0, topY = -125;
    color leafColor = color(75, 115, 45); // hijau yang berangsur pulih, tanda harapan baru
    drawCurvedLeaf13(topX, topY, 70, -220, leafColor);
    drawCurvedLeaf13(topX, topY, 40, -230, leafColor);
    drawCurvedLeaf13(topX, topY, 15, -220, leafColor);
    drawCurvedLeaf13(topX, topY, -70, 230, leafColor);
    drawCurvedLeaf13(topX, topY, -40, 220, leafColor);
    drawCurvedLeaf13(topX, topY, -15, 210, leafColor);

    if (bowProgress < 0.1) drawTiredFace13(topX, topY + 25);
    else drawApologeticFace13(topX, topY + 25);

    popMatrix();
  }

  void drawCurvedLeaf13(float lx, float ly, float angle, float len, color lc) {
    pushMatrix();
    translate(lx, ly);
    rotate(radians(angle));
    stroke(lc); strokeWeight(8); noFill();
    bezier(0, 0, len * 0.35, -45, len * 0.7, -45, len, 25);
    stroke(lerpColor(lc, color(0), 0.2)); strokeWeight(3);
    float step = (len > 0) ? 14 : -14;
    for (float i = (len > 0 ? 20 : -20); (len > 0) ? i < len : i > len; i += step) {
      float t = abs(i) / abs(len);
      float px = bezierPoint(0, len * 0.35, len * 0.7, len, t);
      float py = bezierPoint(0, -45, -45, 25, t);
      line(px, py, px - 10, py - 35);
      line(px, py, px + 10, py + 35);
    }
    popMatrix();
  }

  void drawTiredFace13(float fx, float fy) {
    pushMatrix(); translate(fx, fy);
    stroke(20, 20, 10); strokeWeight(2); noFill();
    line(-8, -2, -2, -6); line(8, -2, 2, -6); // alis lelah, masih mencari tempat
    fill(20, 20, 10); noStroke();
    ellipse(-5, 1, 5, 5); ellipse(5, 1, 5, 5);
    stroke(20, 20, 10); strokeWeight(2.5); noFill();
    arc(0, 14, 10, 8, PI, TWO_PI); // mulut sedikit menurun
    popMatrix(); noStroke();
  }

  void drawApologeticFace13(float fx, float fy) {
    pushMatrix(); translate(fx, fy);
    stroke(20, 20, 10); strokeWeight(2); noFill();
    // Mata terpejam (menyesal), digambar sebagai lengkungan menurun
    arc(-5, 0, 6, 5, 0, PI);
    arc(5, 0, 6, 5, 0, PI);
    // Mulut kecil merapat, ekspresi rendah hati dan tulus
    line(-5, 13, 5, 13);
    popMatrix(); noStroke();
  }
}

// ---------------------------------------------------------------------------------
// Bunga kecil di rerumputan, bergoyang pelan tertiup angin
// ---------------------------------------------------------------------------------
class Flower {
  float x, y, phase, speed;
  color petalColor;

  Flower(float x, float y, color petalColor, float phase, float speed) {
    this.x = x; this.y = y; this.petalColor = petalColor;
    this.phase = phase; this.speed = speed;
  }

  void display() {
    pushMatrix();
    translate(x, y);
    float sway = sin(sceneTime * 0.002 * speed + phase) * radians(8);
    rotate(sway);

    noStroke();
    fill(petalColor, 230);
    for (int i = 0; i < 5; i++) {
      float ang = i * (TWO_PI / 5);
      ellipse(cos(ang) * 4.5, sin(ang) * 4.5, 5, 5);
    }
    fill(255, 235, 90);
    ellipse(0, 0, 4, 4);

    stroke(70, 120, 60); strokeWeight(1.5);
    line(0, 2, 0, 9);
    noStroke();
    popMatrix();
  }
}

// ---------------------------------------------------------------------------------
// Pohon-pohon hutan yang kini bahagia: melompat kegirangan dengan wajah ceria,
// memakai efek "squash & stretch" khas animasi supaya lompatannya terasa hidup
// ---------------------------------------------------------------------------------
class HappyTree {
  float x, y, scale, timeOffset;
  color leafColor;
  boolean isBanyan;
  int order;

  HappyTree(float x, float y, float scale, color leafColor, boolean isBanyan, int order) {
    this.x = x; this.y = y; this.scale = scale;
    this.leafColor = leafColor;
    this.isBanyan = isBanyan;
    this.order = order;
    this.timeOffset = order * 137.0 + random(200);
  }

  void display() {
    float jumpHeight = (isBanyan ? 14 : 20);
    float bounce = abs(sin(sceneTime * 0.0028 + timeOffset));
    float jump = bounce * jumpHeight;
    float squashX = map(bounce, 0, 1, 1.08, 0.92);
    float squashY = map(bounce, 0, 1, 0.92, 1.1);

    pushMatrix();
    translate(x, y - jump * scale);
    scale(scale * squashX, scale * squashY);

    if (isBanyan) drawBanyanTrunk(); else drawTrunk();
    if (isBanyan) drawBanyanLeaves(); else drawLeaves();
    drawJoyfulFace(isBanyan ? -75 : -55);

    popMatrix();
  }

  void drawLeafCluster(float cx, float cy, float w, float h) {
    ellipse(cx, cy, w, h);
    ellipse(cx - w * 0.25, cy + h * 0.15, w * 0.7, h * 0.7);
    ellipse(cx + w * 0.25, cy + h * 0.15, w * 0.7, h * 0.7);
    ellipse(cx, cy - h * 0.2, w * 0.75, h * 0.75);
  }

  void drawTrunk() {
    fill(115, 85, 60); noStroke();
    beginShape();
    vertex(-16, 0); vertex(-10, -110);
    vertex(10, -110); vertex(16, 0);
    endShape(CLOSE);
  }

  void drawLeaves() {
    float t = (sceneTime * 0.001) + timeOffset;
    fill(lerpColor(leafColor, color(10, 45, 15), 0.35), 235);
    drawLeafCluster(sin(t * 0.4) * 5, -120 + cos(t * 0.3) * 3, 135, 95);
    fill(leafColor, 220);
    drawLeafCluster(sin(t * 0.9 + 1.5) * 11, -140 + cos(t * 0.8 + 1) * 7, 115, 80);
    fill(lerpColor(leafColor, color(215, 250, 150), 0.25), 195);
    drawLeafCluster(sin(t * 1.7 + 3) * 16, -155 + cos(t * 1.5 + 2.5) * 11, 90, 65);
  }

  void drawBanyanTrunk() {
    fill(95, 70, 55); noStroke();
    beginShape();
    vertex(-50, 0); vertex(-25, -140);
    vertex(25, -140); vertex(50, 0);
    endShape(CLOSE);
  }

  void drawBanyanLeaves() {
    float t = (sceneTime * 0.001) + timeOffset;
    fill(lerpColor(leafColor, color(10, 40, 20), 0.4), 240);
    drawLeafCluster(sin(t * 0.3) * 4, -160 + cos(t * 0.2) * 2, 340, 200);
    fill(leafColor, 220);
    float midX = sin(t * 0.7 + 1) * 8; float midY = cos(t * 0.6 + 0.8) * 4;
    drawLeafCluster(midX - 40, -190 + midY, 230, 140);
    drawLeafCluster(midX + 40, -190 + midY, 230, 140);
    fill(lerpColor(leafColor, color(220, 250, 160), 0.2), 190);
    drawLeafCluster(sin(t * 1.3 + 2) * 12, -220 + cos(t * 1.1 + 1.5) * 6, 190, 115);
  }

  void drawJoyfulFace(float centerY) {
    pushMatrix(); translate(0, centerY);
    stroke(35); strokeWeight(2.5);
    noFill();
    // Mata melengkung ke atas (^_^), tanda bahagia
    arc(-9, 3, 10, 10, PI, TWO_PI);
    arc(9, 3, 10, 10, PI, TWO_PI);
    // Senyum lebar
    arc(0, 6, 18, 14, 0, PI);
    // Semburat pipi kecil, kesan riang
    noStroke(); fill(255, 150, 140, 150);
    ellipse(-15, 10, 8, 5);
    ellipse(15, 10, 8, 5);
    popMatrix(); noStroke();
  }
}

// ---------------------------------------------------------------------------------
// Sawit yang kini hidup berdampingan dengan hutan, ikut melompat kegirangan
// (berdiri tegak, bukan menunduk lagi — tanda permintaan maafnya sudah diterima)
// ---------------------------------------------------------------------------------
class HappyPalm {
  float x, y, scale, timeOffset;
  int order;

  HappyPalm(float x, float y, float scale, int order) {
    this.x = x; this.y = y; this.scale = scale;
    this.order = order;
    this.timeOffset = order * 211.0 + random(200);
  }

  void display() {
    float jumpHeight = 24;
    float bounce = abs(sin(sceneTime * 0.003 + timeOffset));
    float jump = bounce * jumpHeight;
    float squashX = map(bounce, 0, 1, 1.1, 0.9);
    float squashY = map(bounce, 0, 1, 0.9, 1.12);

    pushMatrix();
    translate(x, y - jump * scale);
    scale(scale * squashX, scale * squashY);

    fill(100, 70, 40); stroke(70, 45, 20); strokeWeight(2);
    for (int i = 0; i < 7; i++) {
      float yy = -i * 18;
      ellipse(0, yy, 90 - i * 6, 32);
    }

    float topX = 0, topY = -125;
    color leafColor = color(70, 190, 80); // hijau segar & cerah, penuh sukacita
    drawFrond(topX, topY, 70, -220, leafColor);
    drawFrond(topX, topY, 40, -230, leafColor);
    drawFrond(topX, topY, 15, -220, leafColor);
    drawFrond(topX, topY, -70, 230, leafColor);
    drawFrond(topX, topY, -40, 220, leafColor);
    drawFrond(topX, topY, -15, 210, leafColor);

    drawJoyfulPalmFace(topX, topY + 25);

    popMatrix();
  }

  void drawFrond(float lx, float ly, float angle, float len, color lc) {
    pushMatrix();
    translate(lx, ly);
    rotate(radians(angle));
    stroke(lc); strokeWeight(8); noFill();
    bezier(0, 0, len * 0.35, -45, len * 0.7, -45, len, 25);
    stroke(lerpColor(lc, color(0), 0.15)); strokeWeight(3);
    float step = (len > 0) ? 14 : -14;
    for (float i = (len > 0 ? 20 : -20); (len > 0) ? i < len : i > len; i += step) {
      float tt = abs(i) / abs(len);
      float px = bezierPoint(0, len * 0.35, len * 0.7, len, tt);
      float py = bezierPoint(0, -45, -45, 25, tt);
      line(px, py, px - 10, py - 35);
      line(px, py, px + 10, py + 35);
    }
    popMatrix();
  }

  void drawJoyfulPalmFace(float fx, float fy) {
    pushMatrix(); translate(fx, fy);
    stroke(20, 20, 10); strokeWeight(2); noFill();
    arc(-5, 1, 7, 7, PI, TWO_PI);
    arc(5, 1, 7, 7, PI, TWO_PI);
    arc(0, 5, 14, 11, 0, PI);
    noStroke(); fill(255, 150, 140, 150);
    ellipse(-9, 9, 6, 4);
    ellipse(9, 9, 6, 4);
    popMatrix(); noStroke();
  }
}
