package domain;

public class WaterQualityStation
{
    private int id;
    private String stationName;
    private Double longitude;
    private Double latitude;
    private String section;
    private String introduction;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getStationName() {
        return stationName;
    }

    public void setStationName(String stationName) {
        this.stationName = stationName;
    }

    public String getIntroduction() {
        return introduction;
    }

    public void setIntroduction(String introduction) {
        this.introduction = introduction;
    }

    public String getSection() {
        return section;
    }

    public void setSection(String section) {
        this.section = section;
    }

    public Double getLongitude() {
        return longitude;
    }

    public void setLongitude(Double longitude) {
        this.longitude = longitude;
    }

    public Double getLatitude() {
        return latitude;
    }

    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }


    @Override
    public String toString() {
        return "WaterQualityStation{" +
                "id=" + id +
                ", stationName='" + stationName + '\'' +
                ", longitude=" + longitude +
                ", latitude=" + latitude +
                ", section='" + section + '\'' +
                ", introduction='" + introduction + '\'' +
                '}';
    }
}
