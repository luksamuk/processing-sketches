class LockScreen
{
	Weather w;
	boolean visibility;
	PFont big, medium, small;
	int visib_factor;
	int visib_fade_factor;


	public LockScreen(Weather w)
	{
		this.w = w;
		visibility = false;
		big = createFont("Arial", 72);
		medium = createFont("Arial", 24);
		small = createFont("Arial", 14);
		visib_factor = 255;
		visib_fade_factor = 20;
	}
	
	public void update()
	{
		visib_factor += 
		(60 * (visibility ? (visib_factor < 255 ? visib_fade_factor : 0) : (visib_factor > 0 ? -visib_fade_factor : 0))) / frameRate;
	}
	
	public void setVisibility(boolean b) {
		visibility = b;
	}
	
	public int getVisibility() {
		return visib_factor;
	}
	
	public void draw()
	{
		textAlign(CENTER, CENTER);
		pushMatrix();
			// Dim
			stroke(0, 3*visib_factor/4);
			fill(0, 3*visib_factor/4);
			rect(0, 0, width, height);
		
			// Text
			stroke(255, visib_factor);
			fill(255, visib_factor);
			translate(width/2, height/2);
			textFont(big);
			text(w.get(0, WeatherField.TEMPERATURE) + "°C", 0, -26);
			textFont(medium);
			text(w.get(0, WeatherField.CITY) + ", " + w.get(0, WeatherField.REGION), 0, 22);
			textFont(small);
			text("To unlock, let me see your face.", 0, 3*height/8);
			
			
			strokeWeight(10);
			noFill();
			ellipse(0, 0, 200 + (255 - visib_factor), 200 + (255 - visib_factor));
			strokeWeight(1);
		popMatrix();
	}
}