package domain;

import java.sql.Timestamp;

public class WaterLevel
{
   private Integer id;
   private String riverName;
   private String siteName;
   private Timestamp collectionDate;
   private Double waterLevel;
   private Double flow;
   private Double over;


    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getRiverName() {
        return riverName;
    }

    public void setRiverName(String riverName) {
        this.riverName = riverName;
    }

    public String getSiteName() {
        return siteName;
    }

    public void setSiteName(String siteName) {
        this.siteName = siteName;
    }

    public Timestamp getCollectionDate() {
        return collectionDate;
    }

    public void setCollectionDate(Timestamp collectionDate) {
        this.collectionDate = collectionDate;
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
        return "WaterLevel{" +
                "id=" + id +
                ", riverName='" + riverName + '\'' +
                ", siteName='" + siteName + '\'' +
                ", collectionDate=" + collectionDate +
                ", waterLevel=" + waterLevel +
                ", flow=" + flow +
                ", over=" + over +
                '}';
    }
}
