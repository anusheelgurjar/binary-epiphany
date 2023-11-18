# binary-epiphany

Binary Epiphany Beta v1.0

Binary Epiphany is a tool made with Processing that adds a captivating twist to image processing. This tool takes two images and employs a Bayer Matrix order system to dither them before applying the Difference blendMode(), resulting in a surprising series of patterns, tessellations, and moiré effects. Users have the flexibility to experiment with settings such as Matrix Size, Pixel Size, Contrast, Threshold, and Rotation to explore various iterations and creative possibilities.

Hi there!

> Along with the tool is a folder named "Sample Images", containing some gradient maps to play around with.

> The imported images can be either be in colour or grayscale. Both works, however the output is only in grayscale.

> Feel free to share feedback or any other concerns on anusheel1625@gmail.com

> If you produce any artwork with the tool, please share it to @anusheel.gurjar on Instagram.

> If the tool doesn't work, download and install OpenJDK17 from this url https://adoptium.net/
  and try running it again

> Currently, output size is limited to 800 x 800 px. If you wish to scale the output:
  	1. Import the render in Photoshop
	2. Go to Image > Image Size and choose Resample: Nearest Neighbor (hard edges)
	3. Input desired size into width and height and it's done

> The output naming also stores the data. This is how to read it:
  "output" + threshold + contrast + pixel_size_x + pixel_size_y + matrix_size_x + matrix_size_y + rotate + image 1 scale + image 2 scale
