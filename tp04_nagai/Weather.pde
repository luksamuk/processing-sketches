import com.onformative.yahooweather.*;
import java.util.Date;

public class Weather
{
	// City 1: Itabira
	// City 2: Belo Horizonte
	// City 3: Diamantina
	// City 4: Montes Claros
	YahooWeather[] weather;
	int updateTimeMs = 30000;
	
	public Weather(PApplet p)
	{
		weather = new YahooWeather[4];
		// Funciona basicamente da mesma forma que o conky do Linux. Forneça o
		// WOEID, receba os detalhes.
		weather[0] = new YahooWeather(p, 455957, "c", updateTimeMs);
		weather[1] = new YahooWeather(p, 455821, "c", updateTimeMs);
		weather[2] = new YahooWeather(p, 457121, "c", updateTimeMs);
		weather[3] = new YahooWeather(p, 455886, "c", updateTimeMs);
	}
	
	public void update()
	{
		for(YahooWeather w : weather)
			w.update();
	}
	
	public void setUnitCelsius(boolean b) {
		String unit;
		if(b) unit = "c"; else unit = "f";
		for(YahooWeather w : weather) w.setTempertureUnit(unit);
	}
	
	public String get(int cityID, WeatherField f)
	{
		if(cityID < 0 || cityID > 4) return "UNKNOWN_ID";
		
		StringBuilder sb = new StringBuilder();
		YahooWeather w = weather[cityID];
		Date date;
		long timeDiff;
		
		switch(f)
		{
		case CITY:
			return w.getCityName();
		case REGION:
			return w.getRegionName();
		case COUNTRY:
			return w.getCountryName();
		case LAST_UPDATED:
			// This needs a bit of a thought...
			// w.getLastUpdated() returns a Date, but what I actually
			// wanted was something telling me HOW LONG AGO did I check
			// for weather updates.
			// Needless to say, as I'll probably check this info each
			// frame, it can be a bit messy with the CPU, considering
			// it's Java, but I won't care too much.
			// I'll only add a delay or a cap if I find this specific thing
			// is consuming way more CPU than it should.
			date = new Date();
			// We'll get only seconds.
			timeDiff = (date.getTime() - w.getLastUpdated().getTime()) / 1000;
			
			// If I just fetched it, no reason to display a fancy
			// output.
			if(timeDiff == 0) { sb.append("now"); break; }
			
			// Days
			if(timeDiff / 86400 > 0) {
				sb.append((timeDiff / 86400) + "d ");
				timeDiff -= (timeDiff / 86400) * 86400;
			}
			
			// Hours
			if(timeDiff / 3600 > 0) {
				sb.append((timeDiff / 3600) + "h ");
				timeDiff -= (timeDiff / 3600) * 3600;
			}
			
			// Minutes
			if(timeDiff / 60 > 0) {
				sb.append((timeDiff / 60) + "m ");
				timeDiff -= (timeDiff / 60) * 60;
			}
			
			// Seconds
			sb.append(timeDiff + "s ");
			sb.append("ago");
			break;
		case LONGITUDE:
			sb.append(w.getLongitude());
			break;
		case LATITUDE:
			sb.append(w.getLatitude());
			break;
		case WIND_TEMPERATURE:
			sb.append(w.getWindTemperature());
			break;
		case WIND_SPEED:
			sb.append(w.getWindSpeed());
			break;
		case WIND_DIRECTION:
			// TODO: Should I parse this? It returns an int,
			// maybe I should look into Yahoo itself to know
			// how I should parse wind direction.
			sb.append(w.getWindDirection());
			break;
		case HUMIDITY:
			sb.append(w.getHumidity());
			break;
		case VISIBILITY:
			sb.append(w.getVisibleDistance());
			break;
		case PRESSURE:
			sb.append(w.getPressure());
			break;
		case RISING:
			// Needs parsing, of course
			switch(w.getRising()) {
				case 0: sb.append("Steady");   break;
				case 1: sb.append("Rising");   break;
				case 2: sb.append("Falling");  break;
				default: sb.append("Unknown"); break;
			}
			break;
		case SUNRISE:
			return w.getSunrise();
		case SUNSET:
			return w.getSunset();
		case TEMPERATURE:
			sb.append(w.getTemperature());
			break;
		case TEMPERATURE_LOW_TOMORROW:
			sb.append(w.getTemperatureLowTomorrow());
			break;
		case TEMPERATURE_HIGH_TOMORROW:
			sb.append(w.getTemperatureHighTomorrow());
			break;
		case CONDITION:
			return w.getWeatherCondition();
		};
		
		return sb.toString();
	}
}