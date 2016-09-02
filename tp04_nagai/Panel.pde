public class Panel
{
	MainScreen m_parent;
	PVector    m_size;
	PVector    m_position;
	PanelState m_state;
	int        m_visibility;
	int        visib_fade_factor;
	int        m_paneltype;
	public Panel(MainScreen parent)
	{
		m_parent = parent;
		m_position = new PVector(50, 140);
		m_size = new PVector(width - 100, height - 260);
		m_state = PanelState.FADEIN;
		visib_fade_factor = 20;
	}
	
	public void update()
	{
		//increase to show, decrease to hide
		if(m_state == PanelState.FADEIN)
		{
			m_visibility += m_visibility < 229 ? 60 * visib_fade_factor / frameRate : 0;
			if(m_visibility >= 229) m_state = PanelState.IDLE;
		}
		else if(m_state == PanelState.FADEOUT)
		{
			m_visibility -= m_visibility > 0 ? 60 * visib_fade_factor / frameRate : 0;
			// If panel is 100% invisible, then let's dispose it.
			if(m_visibility <= 0) m_state = PanelState.DISPOSED;
		}

	}
	
	public void draw(float uiVisibilityPerc)
	{
		pushMatrix();
			fill(34, 44, 52, int(uiVisibilityPerc * m_visibility));
			noStroke();
			translate(m_position.x, m_position.y);
			rect(0, 0, m_size.x, m_size.y, 20, 20, 20, 20);
			strokeWeight(3);
			//stroke(0, int(uiVisibilityPerc * m_visibility));
			stroke(173, 145, 173, int(uiVisibilityPerc * m_visibility));
			line(m_size.x - 30, 10, m_size.x - 10, 30);
			line(m_size.x - 30, 30, m_size.x - 10, 10);
		popMatrix();
	}

	public CurrentScreen getType()
	{
		switch(m_paneltype)
		{
		case 0: return CurrentScreen.CONSOLE;
		case 1: return CurrentScreen.WEATHER;
		case 2: return CurrentScreen.CLOCK;
		case 3: return CurrentScreen.COMPUTER;
		default: println("oh boy what are you doing"); break;
		}
		return CurrentScreen.MAIN; // watwatwatwatwatwatwat
	}

	public PanelState getState() {
		return m_state;
	}

	public void removeMe() {
		m_state = PanelState.FADEOUT;
	}

	public void evalClick(PVector mousePosition)
	{
		PVector closeButtonPos = new PVector(width - 80, m_position.y + 10);
		if((mousePosition.x >= closeButtonPos.x && mousePosition.x <= closeButtonPos.x + 20)
		&& (mousePosition.y >= closeButtonPos.y && mousePosition.y <= closeButtonPos.y + 20))
			m_state = PanelState.FADEOUT;
	}
}

// 0: Console
// 1: Weather
// 2: Clock
// 3: Computer
// 4: Computer?

public class ConsolePanel extends Panel
{
	PFont font;
	public ConsolePanel(MainScreen parent)
	{
		super(parent);
		m_paneltype = 0;
		font = createFont("Lucida Console", 14);
	}

	@Override
	public void draw(float uiVisibilityPerc)
	{
		super.draw(uiVisibilityPerc);

		pushMatrix();
			translate(m_position.x, m_position.y);
			translate(10, 40);
			noStroke();
			fill(0, 0, 0, int(uiVisibilityPerc * 192));
			rect(0, 0, m_size.x - 20, m_size.y - 50);
			textFont(font);
			textAlign(LEFT, CENTER);
			translate(4, 16);
			stroke(255, 255, 255, int(uiVisibilityPerc * 255));
			fill(255, 255, 255, int(uiVisibilityPerc * 255));
			text("root@127.0.0.1:# :(){ :|:& };:_", 0, 0);
		popMatrix();
	}
}

public class WeatherPanel extends Panel
{
	PFont big, medium, small;
	Weather m_weather;
	public WeatherPanel(MainScreen parent, Weather w)
	{
		super(parent);
		m_paneltype = 1;
		big = createFont("Arial", 36);
		medium = createFont("Arial", 24);
		small = createFont("Arial", 14);
		m_weather = w;
	}

	@Override
	public void draw(float uiVisibilityPerc)
	{
		super.draw(uiVisibilityPerc);
		pushMatrix();
			stroke(255, 255, 255, int(uiVisibilityPerc * 192));
			fill(255, 255, 255, int(uiVisibilityPerc * 192));
			textAlign(CENTER, CENTER);
			translate(m_position.x, m_position.y);
			
			// Itabira
			textFont(big);
			translate(m_size.x / 2.0f, 58);
			text(w.get(0, WeatherField.TEMPERATURE)
				+ "°C | " + w.get(0, WeatherField.CITY)
				+ ", " + w.get(0, WeatherField.REGION)
				+ ", " + w.get(0, WeatherField.COUNTRY), 0, 0);
			textFont(medium);
			translate(0, 32);
			text(w.get(0, WeatherField.CONDITION)
				+ " | " + w.get(0, WeatherField.WIND_SPEED) + "mph,"
				+ w.get(0, WeatherField.PRESSURE) + "in", 0, 0);
			textFont(small);
			translate(0, 21);
			text("Tomorrow: " + w.get(0, WeatherField.TEMPERATURE_LOW_TOMORROW)
				+ "°C ~ " + w.get(0, WeatherField.TEMPERATURE_HIGH_TOMORROW)
				+ "°C", 0, 0);

			// Separators
			translate((-m_size.x / 2.0f) + 10, 20);
			strokeWeight(3);
			line(0, 0, m_size.x - 20, 0);
			translate(0, 20);

			float separatorJump = (m_size.x - 20) / 3.0f;
			line(separatorJump, 0, separatorJump, m_size.y - 180);
			line(m_size.x - separatorJump - 10, 0,
				m_size.x - separatorJump - 10,  m_size.y - 180);
			strokeWeight(1);
			translate(0, 50);

			// Belo Horizonte
			textFont(medium);
			translate(separatorJump / 2.0f, 0);
			text(w.get(1, WeatherField.CITY) + ", " + w.get(1, WeatherField.REGION)
				+ "\n" + w.get(1, WeatherField.TEMPERATURE) + "°C"
				+ "\n" + w.get(1, WeatherField.CONDITION), 0, 0);
			pushMatrix();
				textFont(small);
				translate(-(separatorJump/2.0f) + 40, 170);
				textAlign(LEFT, CENTER);
				text("Latitude: " + w.get(1, WeatherField.LATITUDE)
					+ "\nLongitude: " + w.get(1, WeatherField.LONGITUDE)
					+ "\nTomorrow: " + w.get(1, WeatherField.TEMPERATURE_LOW_TOMORROW)
					  + "°C ~ " + w.get(1, WeatherField.TEMPERATURE_HIGH_TOMORROW) + "°C"
					+ "\nWind Temperature: " + w.get(1, WeatherField.WIND_TEMPERATURE) + "°C"
					+ "\nWind Speed: " + w.get(1, WeatherField.WIND_SPEED) + "mph"
					+ "\nWind Direction: " + w.get(1, WeatherField.WIND_DIRECTION)
					+ "\nPressure: " + w.get(1, WeatherField.PRESSURE) + "in"
					+ "\nHumidity: " + w.get(1, WeatherField.HUMIDITY) + "%"
					+ "\nVisibility: " + w.get(1, WeatherField.VISIBILITY) + "mi"
					+ "\nSunrise: " + w.get(1, WeatherField.SUNRISE)
					+ "\nSunset: " + w.get(1, WeatherField.SUNSET)
					+ "\n" + w.get(1, WeatherField.RISING), 0, 0);
				textAlign(CENTER, CENTER);
			popMatrix();
			
			// Diamantina
			textFont(medium);
			translate(-(separatorJump/2.0f) - 10, 0);
			translate(m_size.x / 2.0f, 0);
			text(w.get(2, WeatherField.CITY) + ", " + w.get(2, WeatherField.REGION)
				+ "\n" + w.get(2, WeatherField.TEMPERATURE) + "°C"
				+ "\n" + w.get(2, WeatherField.CONDITION), 0, 0);
			pushMatrix();
				textFont(small);
				translate(-(separatorJump/2.0f) + 40, 170);
				textAlign(LEFT, CENTER);
				text("Latitude: " + w.get(2, WeatherField.LATITUDE)
					+ "\nLongitude: " + w.get(2, WeatherField.LONGITUDE)
					+ "\nTomorrow: " + w.get(2, WeatherField.TEMPERATURE_LOW_TOMORROW)
					  + "°C ~ " + w.get(2, WeatherField.TEMPERATURE_HIGH_TOMORROW) + "°C"
					+ "\nWind Temperature: " + w.get(2, WeatherField.WIND_TEMPERATURE) + "°C"
					+ "\nWind Speed: " + w.get(2, WeatherField.WIND_SPEED) + "mph"
					+ "\nWind Direction: " + w.get(2, WeatherField.WIND_DIRECTION)
					+ "\nPressure: " + w.get(2, WeatherField.PRESSURE) + "in"
					+ "\nHumidity: " + w.get(2, WeatherField.HUMIDITY) + "%"
					+ "\nVisibility: " + w.get(2, WeatherField.VISIBILITY) + "mi"
					+ "\nSunrise: " + w.get(2, WeatherField.SUNRISE)
					+ "\nSunset: " + w.get(2, WeatherField.SUNSET)
					+ "\n" + w.get(2, WeatherField.RISING), 0, 0);
				textAlign(CENTER, CENTER);
			popMatrix();

			// Montes Claros
			textFont(medium);
			translate(m_size.x / 2.0f, 0);
			translate(-(separatorJump/2.0f) - 10, 0);
			text(w.get(3, WeatherField.CITY) + ", " + w.get(3, WeatherField.REGION)
				+ "\n" + w.get(3, WeatherField.TEMPERATURE) + "°C"
				+ "\n" + w.get(3, WeatherField.CONDITION), 0, 0);
			pushMatrix();
				textFont(small);
				translate(-(separatorJump/2.0f) + 40, 170);
				textAlign(LEFT, CENTER);
				text("Latitude: " + w.get(3, WeatherField.LATITUDE)
					+ "\nLongitude: " + w.get(3, WeatherField.LONGITUDE)
					+ "\nTomorrow: " + w.get(3, WeatherField.TEMPERATURE_LOW_TOMORROW)
					  + "°C ~ " + w.get(3, WeatherField.TEMPERATURE_HIGH_TOMORROW) + "°C"
					+ "\nWind Temperature: " + w.get(3, WeatherField.WIND_TEMPERATURE) + "°C"
					+ "\nWind Speed: " + w.get(3, WeatherField.WIND_SPEED) + "mph"
					+ "\nWind Direction: " + w.get(3, WeatherField.WIND_DIRECTION)
					+ "\nPressure: " + w.get(3, WeatherField.PRESSURE) + "in"
					+ "\nHumidity: " + w.get(3, WeatherField.HUMIDITY) + "%"
					+ "\nVisibility: " + w.get(3, WeatherField.VISIBILITY) + "mi"
					+ "\nSunrise: " + w.get(3, WeatherField.SUNRISE)
					+ "\nSunset: " + w.get(3, WeatherField.SUNSET)
					+ "\n" + w.get(3, WeatherField.RISING), 0, 0);
				textAlign(CENTER, CENTER);
			popMatrix();
		popMatrix();
	}
}

public class ClockPanel extends Panel
{
	PFont big, small;
	Clock c;
	public ClockPanel(MainScreen parent)
	{
		super(parent);
		m_paneltype = 2;
		big = createFont("Arial", 72);
		small = createFont("Arial", 14);
		c = new Clock();
	}

	@Override
	public void draw(float uiVisibilityPerc)
	{
		super.draw(uiVisibilityPerc);
		pushMatrix();
			translate(m_position.x, m_position.y);
			textFont(big);
			textAlign(CENTER, CENTER);
			translate(m_size.x / 2.0f, 50);
			stroke(255, 255, 255, int(uiVisibilityPerc * 192));
			fill(255, 255, 255, int(uiVisibilityPerc * 192));
			
			text(c.getClock(0), 0, 0);
			textFont(small);
			translate(0, 38);
			text("Brasília (Current)", 0, 0);

			translate(-m_size.x / 2.0f, 0);
			translate(m_size.x / 6.0f, 100);
			textFont(big);
			text(c.getClock(1), 0, 0);
			textFont(small);
			translate(0, 38);
			text("Greenwich Meridian Time", 0, 0);

			translate(-m_size.x / 6.0f, 0);
			translate(m_size.x / 2.0f, 100);
			textFont(big);
			text(c.getClock(2), 0, 0);
			textFont(small);
			translate(0, 38);
			text("Pacific Standard Time", 0, 0);

			translate(m_size.x / 2.0f, 0);
			translate(-m_size.x / 6.0f, 90);
			textFont(big);
			text(c.getClock(3), 0, 0);
			textFont(small);
			translate(0, 38);
			text("Sydney", 0, 0);

		popMatrix();
	}
}

public class ComputerPanel extends Panel
{
	ComputerData computerData;
	PFont medium;
	public ComputerPanel(MainScreen parent)
	{
		super(parent);
		m_paneltype = 3;
		medium = createFont("Arial", 24);
		computerData = new ComputerData();
	}

	@Override
	public void draw(float uiVisibilityPerc)
	{
		super.draw(uiVisibilityPerc);

		pushMatrix();
			translate(m_position.x, m_position.y);
			stroke(255, 255, 255, int(uiVisibilityPerc * 192));
			fill(255, 255, 255, int(uiVisibilityPerc * 192));
			translate(m_size.x / 2.0f, m_size.y / 2.0f);
			translate(0, -26);
			textAlign(CENTER, CENTER);
			textFont(medium);
			text(computerData.getOS(), 0, 0);
			translate(0, 26);
			text("System Architecture: " + computerData.getArchitecture(), 0, 0);
			translate(0, 26);
			text("System CPU Load: " + computerData.getSystemLoad() + "%", 0, 0);
		popMatrix();
	}

	@Override
	public void evalClick(PVector mousePosition)
	{
		super.evalClick(mousePosition);
	}
}