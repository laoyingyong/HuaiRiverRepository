package domain;

/**
 * @author laoyingyong
 * @date: 2020-02-03 16:55
 */
public class StationAndQuality
{
    private WaterQualityStation station;
    private WaterQuality quality;

    public WaterQualityStation getStation() {
        return station;
    }

    public void setStation(WaterQualityStation station) {
        this.station = station;
    }

    public WaterQuality getQuality() {
        return quality;
    }

    public void setQuality(WaterQuality quality) {
        this.quality = quality;
    }

    @Override
    public String toString() {
        return "StationAndQuality{" +
                "station=" + station +
                ", quality=" + quality +
                '}';
    }
}
