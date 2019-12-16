package domain;

public class WaterQualityStation
{
    private int id;
    private String stationName;
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

    @Override
    public String toString() {
        return "{" +
                "id:" + id +
                ", stationName:'" + stationName + '\'' +
                ", introduction:'" + introduction + '\'' +
                '}';
    }
}
