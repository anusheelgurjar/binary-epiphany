//binary_epiphany_beta
import controlP5.*;
ControlP5 gui;

int ox=0;
int oy=0;
float threshold=64;
float contrast=0;
int pix_size_x=8;
int pix_size_y=8;
int matrix_size_x=8;
int matrix_size_y=8;
float rot=0;
PImage img1, img2;
int gui_width=300;
int img1scl=800;
int img2scl=1600;


void setup() {
  size(1100, 800);
  frameRate(60);
  gui = new ControlP5(this);

  gui.addSlider("threshold")
    .setPosition(20, 20)
    .setRange(0, 255)
    .setValue(threshold)
    .setWidth(200)
    .setLabel("Threshold");

  gui.addSlider("contrast")
    .setPosition(20, 60)
    .setRange(0.0, 100.0)
    .setValue(contrast)
    .setWidth(200)
    .setLabel("Contrast");

  gui.addSlider("pix_size_x")
    .setPosition(20, 100)
    .setRange(1, 8)
    .setValue(pix_size_x)
    .setWidth(200)
    .setLabel("Pixel Size X");

  gui.addSlider("pix_size_y")
    .setPosition(20, 140)
    .setRange(1, 8)
    .setValue(pix_size_y)
    .setWidth(200)
    .setLabel("Pixel Size Y");

  gui.addSlider("matrix_size_x")
    .setPosition(20, 180)
    .setRange(1, 8)
    .setValue(matrix_size_x)
    .setWidth(200)
    .setLabel("Matrix Size X");

  gui.addSlider("matrix_size_y")
    .setPosition(20, 220)
    .setRange(1, 8)
    .setValue(matrix_size_y)
    .setWidth(200)
    .setLabel("Matrix Size Y");

  gui.addSlider("rot")
    .setPosition(20, 260)
    .setRange(0, 360)
    .setValue(rot)
    .setWidth(200)
    .setLabel("Rotate");

  gui.addButton("saveButton")
    .setPosition(20, 300)
    .setSize(200, 30)
    .setLabel("Save")
    .onChange(new CallbackListener() {
    void controlEvent(CallbackEvent event) {
      saveFrame();
    }
  }
  );

  gui.addButton("Import Image 1")
    .setPosition(20, 620)
    .setSize(200, 30);

  gui.addSlider("img1scl")
    .setPosition(20, 660)
    .setRange(0, 800)
    .setValue(img1scl)
    .setWidth(200)
    .setLabel("Scale");

  gui.addButton("Import Image 2")
    .setPosition(20, 700)
    .setSize(200, 30);

  gui.addSlider("img2scl")
    .setPosition(20, 740)
    .setRange(0, 1600)
    .setValue(img2scl)
    .setWidth(200)
    .setLabel("Scale");

  gui.getController("Import Image 1").plugTo(this, "loadImage1");
  gui.getController("Import Image 2").plugTo(this, "loadImage2");
}

void draw() {
  background(0);
  blendMode(DIFFERENCE);
  if (gui.isMouseOver()) {
    if (threshold != gui.get("threshold").getValue() ||
      pix_size_x != gui.get("pix_size_x").getValue() ||
      pix_size_y != gui.get("pix_size_y").getValue() ||
      contrast != gui.get("contrast").getValue() ||
      matrix_size_x != gui.get("matrix_size_x").getValue() ||
      matrix_size_y != gui.get("matrix_size_y").getValue() ||
      rot != gui.get("rot").getValue() ||
      img1scl != gui.get("img1scl").getValue() ||
      img2scl != gui.get("img2scl").getValue()) {

      threshold = gui.get("threshold").getValue();
      pix_size_x = int(gui.get("pix_size_x").getValue());
      pix_size_y = int(gui.get("pix_size_y").getValue());
      contrast = gui.get("contrast").getValue();
      matrix_size_x = int(gui.get("matrix_size_x").getValue());
      matrix_size_y = int(gui.get("matrix_size_y").getValue());
      rot = gui.get("rot").getValue();
      img1scl = int(gui.get("img1scl").getValue());
      img2scl = int(gui.get("img2scl").getValue());
    }
  }
  if (img1 != null) {
    push();
    ox=width/2+(gui_width/2);
    oy=height/2;
    img1.resize(int(img1scl),0);
    PImage outputImage = applyBayerDithering(img1, threshold, contrast, 0, ox, oy, pix_size_x, pix_size_y, matrix_size_x, matrix_size_y);
    image(outputImage, -outputImage.width/2, -outputImage.height/2);
    pop();
  }
  if (img2 != null) {
    push();
    ox=width/2+(gui_width/2);
    oy=height/2;
    img2.resize(int(img2scl), 0);
    PImage outputImage2 = applyBayerDithering(img2, threshold, contrast, rot, ox, oy, pix_size_x, pix_size_y, matrix_size_x, matrix_size_y);
    image(outputImage2, -outputImage2.width/2, -outputImage2.height/2);
    pop();
  }
  blendMode(NORMAL);
  fill(0);
  rect(0, 0, 300, height);
}


PImage applyBayerDithering(PImage image, float t, float contrast, float rot, int ox, int oy, int pix_size_x, int pix_size_y, int matrix_size_x, int matrix_size_y) {
  int[][] bayerMatrix = {
    { 0, 48, 12, 60, 3, 51, 15, 63 },
    { 32, 16, 44, 28, 35, 19, 47, 31 },
    { 8, 56, 4, 52, 11, 59, 7, 55 },
    { 40, 24, 36, 20, 43, 27, 39, 23 },
    { 2, 50, 14, 62, 1, 49, 13, 61 },
    { 34, 18, 46, 30, 33, 17, 45, 29 },
    { 10, 58, 6, 54, 9, 57, 5, 53 },
    { 42, 26, 38, 22, 41, 25, 37, 21 }
  };

  translate(ox, oy);
  rotate(radians(rot));
  PImage outputImage = createImage(image.width, image.height, RGB);
  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      color oldCol = image.get(x, y);
      float oldPix = (red(oldCol) + green(oldCol) + blue(oldCol)) / 3.0; 
      int bayerValue = bayerMatrix[x/pix_size_x % matrix_size_x][y/pix_size_y % matrix_size_y];
      float threshold = (bayerValue * 255) / t + contrast;
      int newPix = oldPix < threshold ? 0 : 255;
      color newColor = color(newPix, newPix, newPix);
      outputImage.set(x, y, newColor); 
    }
  }

  return outputImage;
}

void saveFrame() {
  PImage saveImage = createImage(width-gui_width, height, RGB);
  for (int y = 0; y < height; y++) {
    for (int x = gui_width; x < width; x++) {
      color col = get(x, y);
      saveImage.set(x-gui_width, y, col);
    }
  }
  saveImage.save("output_" +threshold+ "_" +contrast+ "_" +pix_size_x+ "_" +pix_size_y+ "_" +matrix_size_x+ "_" +matrix_size_y+"_"+rot+"_"+img1scl+"_"+img2scl+".jpg");
}

void loadImage1() {
  selectInput("Select Image 1:", "image1Selected");
}

void loadImage2() {
  selectInput("Select Image 2:", "image2Selected");
}

void image1Selected(File selection) {
  if (selection == null) {
    println("Image 1 selection canceled.");
  } else {
    img1 = loadImage(selection.getAbsolutePath());
    println("Image 1 loaded: " + selection.getName());
  }
}

void image2Selected(File selection) {
  if (selection == null) {
    println("Image 2 selection canceled.");
  } else {
    img2 = loadImage(selection.getAbsolutePath());
    println("Image 2 loaded: " + selection.getName());
  }
}
