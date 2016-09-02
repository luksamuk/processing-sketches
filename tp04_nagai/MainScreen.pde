import java.util.Stack;

public class MainScreen
{
	int m_visib;
	boolean MouseClicked;
	// I should've bothered about instantiating
	// more than one font at once, but, since
	// memory consumption is not a concern right now,
	// I guess it's forgivable
	PFont big, medium, small;
	CurrentScreen m_currentscreen;
	String m_currscr_caption,
	       m_currscr_subcaption;
	Dock dock;
	ArrayList<Panel> panels;
	Stack<Panel>     panelsAwaitingDisposal;
	boolean m_awaitpanelspawn;
	Weather          m_weather;

	public MainScreen(Weather w)
	{
		big = createFont("Arial", 72);
		medium = createFont("Arial", 24);
		small = createFont("Arial", 14);
		m_currentscreen = CurrentScreen.MAIN;
		dock = new Dock(this);
		MouseClicked = false;
		panels = new ArrayList<Panel>();
		panelsAwaitingDisposal = new Stack<Panel>();
		m_awaitpanelspawn = false;
		m_weather = w;
	}
	
	public void update()
	{
		switch(m_currentscreen)
		{
		case MAIN:
			m_currscr_caption = "hello";
			m_currscr_subcaption = "Welcome to N.A.G.A.I. v0.1b";
			if(m_awaitpanelspawn) {
				m_awaitpanelspawn = false;
			}
			break;
		case CONSOLE:
			m_currscr_caption = "ssh console";
			m_currscr_subcaption = "GNU bash, version 4.3.39(1)-release (x86_64-unknown-linux-gnu)";
			if(m_awaitpanelspawn) {
				m_awaitpanelspawn = false;
				panels.add(new ConsolePanel(this));
			}
			break;
		case WEATHER:
			m_currscr_caption = "weather forecast";
			m_currscr_subcaption = "Feed from Yahoo Weather";
			if(m_awaitpanelspawn) {
				m_awaitpanelspawn = false;
				panels.add(new WeatherPanel(this, m_weather));
			}
			break;
		case CLOCK:
			m_currscr_caption = "world clock";
			m_currscr_subcaption = "Check different timezones";
			if(m_awaitpanelspawn) {
				m_awaitpanelspawn = false;
				panels.add(new ClockPanel(this));
			}
			break;
		case COMPUTER:
			m_currscr_caption = "computer settings";
			m_currscr_subcaption = "Information regarding this machine";
			if(m_awaitpanelspawn) {
				m_awaitpanelspawn = false;
				panels.add(new ComputerPanel(this));
			}
			break;
		}
		
		for(Panel p : panels)
		{
			p.update();
			if(p.getState() == PanelState.IDLE && m_currentscreen != p.getType())
				p.removeMe();
			else if(p.getState() == PanelState.DISPOSED)
				panelsAwaitingDisposal.push(p);
		}
		while(!panelsAwaitingDisposal.empty()) {
			panels.remove(panelsAwaitingDisposal.pop());
		}

		if(panels.size() == 0)
			m_currentscreen = CurrentScreen.MAIN;

		dock.update(MouseClicked);
		MouseClicked = false;
	}
	
	public void evalClick() {
		MouseClicked = true;
		for(Panel p : panels)
			p.evalClick(new PVector(mouseX, mouseY));
	}
	
	public void draw()
	{
		pushMatrix();
			fill(255, m_visib);
			stroke(255, m_visib);
			textFont(big);
			textAlign(LEFT, CENTER);
			translate(50, 50);
			text(m_currscr_caption, 0, 0);
			translate(0, 40);
			textFont(small);
			text(m_currscr_subcaption, 5, 0);
		popMatrix();

		float uiVisibPerc = float(m_visib) / 255.0f;
		for(Panel p : panels)
			p.draw(uiVisibPerc);

		dock.draw(m_visib);
	}
	
	public void setCurrentScreen(CurrentScreen cscr)
	{
		if(m_currentscreen == cscr) return;
		m_currentscreen = cscr;
		m_awaitpanelspawn = true;
	}
	
	public void setVisibility(int visibility)
	{
		m_visib = visibility;
	}
}