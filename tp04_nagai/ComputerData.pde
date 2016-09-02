import java.lang.management.ManagementFactory;
import java.lang.management.OperatingSystemMXBean;

// Originally I intended to retrieve much more info from the OS,
// but then I realized Java will not give you things like
// RAM usage because of the JVM. This can be easier to retrieve
// in a native language.
public class ComputerData
{
	OperatingSystemMXBean osmxb;
	
	public ComputerData()
	{
		osmxb = ManagementFactory.getOperatingSystemMXBean();
	}
	
	public String getArchitecture() {
		return osmxb.getArch();
	}
	
	public String getOS() {
		return osmxb.getName() + " version " + osmxb.getVersion();
	}
	
	public double getSystemLoad() {
		return osmxb.getSystemLoadAverage();
	}
}