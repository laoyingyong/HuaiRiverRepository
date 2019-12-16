package domain;

import java.sql.Date;

public class WaterLevel
{
    private int id;
    private String name;
    private Double waterLevel;
    private Double over;
    private String status;
    private Date collectionDate;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Double getWaterLevel() {
        return waterLevel;
    }

    public void setWaterLevel(Double waterLevel) {
        this.waterLevel = waterLevel;
    }

    public Double getOver() {
        return over;
    }

    public void setOver(Double over) {
        this.over = over;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCollectionDate() {
        return collectionDate;
    }

    public void setCollectionDate(Date collectionDtate) {
        this.collectionDate = collectionDtate;
    }

    @Override
    public String toString() {
        return "WaterLevel{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", waterLevel=" + waterLevel +
                ", over=" + over +
                ", status='" + status + '\'' +
                ", collectionDate=" + collectionDate +
                '}';
    }
}
