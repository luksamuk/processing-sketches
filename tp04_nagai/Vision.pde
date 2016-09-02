// NOTE TO SELF: Apparently, Processing 3 doesn't use Applet as
// base for its own class, so this stuff here needs to be
// rewritten.
// Someday.

import java.awt.Rectangle; 
import gab.opencv.*; 
import processing.video.*;
import java.util.concurrent.atomic.AtomicInteger;

public class Vision implements Runnable
{
	Capture capture;
	OpenCV  opencv;
	PApplet m_parent;
	Rectangle[] faces;
	Thread thread;
	boolean m_detecting;
	boolean m_debug;
	
	// Não vou arriscar uma thread lendo um número
	// enquanto eu estou escrevendo nele.
	// Pode não acontecer problema nenhum, mas o seguro
	// morreu de velho.
	AtomicInteger m_numberoffaces;
	
	
	public Vision(PApplet applet, boolean debug)
	{
		m_parent = applet;
		capture = new Capture(applet, 640, 480);
		opencv = new OpenCV(applet, 640, 480);
		opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
		applet.registerDispose(this);
		m_debug = debug;
		m_numberoffaces = new AtomicInteger(0);
	}
	
	public void start()
	{
		thread = new Thread(this);
		m_detecting = true;
		capture.start();
		thread.start();
	}
	
	public void dispose()
	{
		stop();
	}
	
	public void stop()
	{
		m_detecting = false;
		thread = null;
		capture.stop();
		output("Done.");
	}
	
	private void output(String s)
	{
		if(m_debug) println(s);
	}
	
	public PImage getImage()
	{
		return capture;
	}

	public int getNumberOfFaces()
	{
		return m_numberoffaces.get();
	}
	
	public void run()
	{
		while(m_detecting)
		{
			output("Reading.");
			capture.read();
			output("Loading onto OpenCV.");
			opencv.loadImage(capture);
			output("Detecting faces.");
			faces = opencv.detect();
			m_numberoffaces.set(faces.length);
			output("Detected " + faces.length + " faces.");
			output("Updated.");
			//delay(75);
		}
	}
	
}