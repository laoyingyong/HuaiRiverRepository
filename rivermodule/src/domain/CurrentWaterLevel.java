package domain;

import java.util.Date;

/**
 * @author laoyingyong
 * @date: 2020-01-13 14:59
 */
public class CurrentWaterLevel
{
   private String riverName;
   private String stationName;
   private String date;
   private Double waterLevel;
   private Double flow;
   private Double over;

    public String getRiverName() {
        return riverName;
    }

    public void setRiverName(String riverName) {
        this.riverName = riverName;
    }

    public String getStationName() {
        return stationName;
    }

    public void setStationName(String stationName) {
        this.stationName = stationName;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public Double getWaterLevel() {
        return waterLevel;
    }

    public void setWaterLevel(Double waterLevel) {
        this.waterLevel = waterLevel;
    }

    public Double getFlow() {
        return flow;
    }

    public void setFlow(Double flow) {
        this.flow = flow;
    }

    public Double getOver() {
        return over;
    }

    public void setOver(Double over) {
        this.over = over;
    }

    @Override
    public String toString() {
        return "CurrentWaterLevel{" +
                "riverName='" + riverName + '\'' +
                ", stationName='" + stationName + '\'' +
                ", date='" + date + '\'' +
                ", waterLevel=" + waterLevel +
                ", flow=" + flow +
                ", over=" + over +
                '}';
    }
}
