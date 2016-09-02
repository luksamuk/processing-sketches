// 0: Brasília UTC-3
// 1: GMT      
// 2: PST      UTC-8
// 3: Sydney   UTC+10
public class Clock
{
	public String getClock(int timezone) {
		StringBuilder sb = new StringBuilder();
		// I'm gonna assume you're on Brazil.
		// Because yes.
		int desiredHour = hour() + adjustTime(timezone);
		if(desiredHour >= 24) desiredHour -= 24;
		else if(desiredHour < 0) desiredHour += 24;
		if(desiredHour < 10) sb.append("0");
		sb.append(desiredHour);
		sb.append(":");
		if(minute() < 10) sb.append("0");
		sb.append(minute());
		sb.append(":");
		if(second() < 10) sb.append("0");
		sb.append(second());
		return sb.toString();
	}
	
	private int adjustTime(int timezone) {
		switch(timezone)
		{
		case 0: break;
		case 1: return 3;
		case 2: return -5;
		case 3: return 13;
		default: println("oh boy what are you doing"); break;
		}
		return 0;
	}
}
