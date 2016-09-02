public class IconPainter
{
	// I don't wanna use assets.
	// I know how it sounds, but I simply
	// don't. Just because I think it's
	// better than machine-generated
	// mipmaps and stuff.
	// If only I could use vector graphics...
	public void drawConsoleIcon(int visibility)
	{
		pushMatrix();
			translate(-24, -24);
			noFill();
			stroke(255, visibility);
			strokeWeight(5);
			rect(0, 0, 48, 48, 12, 12, 12, 12);
			translate(10, 10);
			strokeWeight(2);
			line(0, 0, 5, 2.5);
			line(5, 2.5, 0, 5);
			line(10, 5, 15, 5);
			strokeWeight(1);
		popMatrix();
	}
	
	public void drawWeatherIcon(int visibility)
	{
		pushMatrix();
			translate(8, -12);
			noFill();
			strokeWeight(2);
			stroke(255, visibility);
			// Cloud
			arc(0, 0, 12, 12, -HALF_PI - (QUARTER_PI*1.5), HALF_PI);
			translate(-8, -1);
			arc(0, 0, 16, 12, -PI, -QUARTER_PI);
			translate(-10, 2);
			arc(0, 0, 10, 10, -(3*PI/2), -QUARTER_PI);
			translate(0, 5);
			line(0, 0, 16, 0);
			// Ray
			line(0, 0, 8, 8);
			line(8, 8, 0, 24);
			line(16, 0, 18, 8);
			line(18, 8, 0, 24);
		popMatrix();
	}
	
	public void drawClockIcon(int visibility)
	{
		pushMatrix();
			noFill();
			stroke(255, visibility);
			strokeWeight(3);
			ellipse(0, 0, 48, 48);
			fill(255, visibility);
			noStroke();
			ellipse(0, 0, 3, 3);
			stroke(255, visibility);
			strokeWeight(2);
			line(0, -6, 0, -18);
			line(4, 0, 18, 0);
		popMatrix();
	}
	
	public void drawComputerIcon(int visibility)
	{
		pushMatrix();
			translate(-24, -24);
			noFill();
			stroke(255, visibility);
			strokeWeight(3);
			rect(0, 0, 48, 36, 12, 12, 12, 12);
			translate(24, 42);
			line(-12, 0, 12, 0);
			line(-24, 6, 24, 6);
			strokeWeight(1);
		popMatrix();
	}
}


public class DockButton
{
	int m_type;
	float m_zoomfactor;
	PVector m_position;
	boolean inPosition;
	public DockButton(int type, PVector position) {
		m_type = type;
		m_position = position;
		m_zoomfactor = 1.0f;
		inPosition = false;
	}
	
	public void update(PVector mousePosition)
	{
		PVector diff = PVector.sub(m_position, mousePosition);
		// In a range between -96 and +96, make a zoom effect.
		// Outside this range, abort.
		// Outside of dock, abort as well.
		if(abs(diff.x) > 96 || abs(diff.y) > 48) m_zoomfactor = 1.0f;
		else m_zoomfactor = 2.0f + (1.0f - (abs(diff.x) / 48.0f));
		
		if(PVector.dist(m_position, mousePosition) <= 48.0f)
			inPosition = true;
		else inPosition = false;
	}
	
	// 0: Console
	// 1: Weather
	// 2: Clock
	// 3: Computer
	// 4: Computer
	public void draw(IconPainter p, int visibility)
	{
		pushMatrix();
			translate(m_position.x, m_position.y);
			scale(m_zoomfactor);
			switch(m_type)
			{
			case 0:
				p.drawConsoleIcon(visibility);
				break;
			case 1:
				p.drawWeatherIcon(visibility);
				break;
			case 2:
				p.drawClockIcon(visibility);
				break;
			case 3:
				p.drawComputerIcon(visibility);
				break;
			default:
				p.drawComputerIcon(visibility);
				break;
			}
		popMatrix();
	}
	
	public boolean IsMouseInPosition() {
		return inPosition;
	}
	
	public CurrentScreen getMyScreen() {
		switch(m_type)
		{
			case 0: return CurrentScreen.CONSOLE;
			case 1:	return CurrentScreen.WEATHER;
			case 2: return CurrentScreen.CLOCK;
			case 3:	return CurrentScreen.COMPUTER;
			default: return CurrentScreen.MAIN;
		}
	}
}

public class Dock
{
	MainScreen m_parent;
	IconPainter p;
	DockButton[] buttons;
	
	public Dock(MainScreen parent)
	{
		m_parent = parent;
		p = new IconPainter();
		buttons = new DockButton[4];
		float initialPos = (width/2.0f) - 144.0f;
		for(int i = 0; i < 4; i++) {
			buttons[i] = new DockButton(i, new PVector(initialPos, height - 60.0f));
			initialPos += (48 + 48);
		}
	}
	
	public void update(boolean MouseClicked)
	{
		PVector mousePos = new PVector(mouseX, mouseY);
		for(DockButton b : buttons)
			b.update(mousePos);
			
		if(MouseClicked) {
			for(DockButton b: buttons)
				if(b.IsMouseInPosition()) {
					m_parent.setCurrentScreen(b.getMyScreen());
					break;
				}
		}
	}
	
	public void draw(int visibility)
	{
		pushMatrix();
			for(DockButton b : buttons)
				b.draw(p, visibility);
		popMatrix();
	}
}