Vision v;
Weather w;
LockScreen lscr;
MainScreen mscr;

void setup()
{
	smooth();
	size(1024, 768);
	frameRate(60);
	
	fill(255);
	
	v = new Vision(this, false);
	v.start();
	w = new Weather(this);

	lscr = new LockScreen(w);
	mscr = new MainScreen(w);
}

void draw()
{
	w.update();
	lscr.setVisibility(v.getNumberOfFaces() == 0);
	lscr.update();
	mscr.setVisibility(255 - lscr.getVisibility());
	mscr.update();

	background(100, 149, 237);
	image(v.getImage(), 0, 0, width, height);
	mscr.draw();
	lscr.draw();
}

void mouseClicked()
{
	mscr.evalClick();
}