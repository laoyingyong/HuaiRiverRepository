package domain;

/**
 * @author laoyingyong
 * @date: 2020-01-19 15:24
 */
public class WaterQuality
{
    private Integer id;
    private String belongStation;
    private String dateTime;
    private Double pH;
    private Double dO;
    private Double nH4;
    private Double cODMn;
    private Double tOC;
    private String level;


    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getBelongStation() {
        return belongStation;
    }

    public void setBelongStation(String belongStation) {
        this.belongStation = belongStation;
    }

    public String getDateTime() {
        return dateTime;
    }

    public void setDateTime(String dateTime) {
        this.dateTime = dateTime;
    }

    public Double getpH() {
        return pH;
    }

    public void setpH(Double pH) {
        this.pH = pH;
    }

    public Double getdO() {
        return dO;
    }

    public void setdO(Double dO) {
        this.dO = dO;
    }

    public Double getnH4() {
        return nH4;
    }

    public void setnH4(Double nH4) {
        this.nH4 = nH4;
    }

    public Double getcODMn() {
        return cODMn;
    }

    public void setcODMn(Double cODMn) {
        this.cODMn = cODMn;
    }

    public Double gettOC() {
        return tOC;
    }

    public void settOC(Double tOC) {
        this.tOC = tOC;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    @Override
    public String toString() {
        return "WaterQuality{" +
                "id=" + id +
                ", belongStation='" + belongStation + '\'' +
                ", dateTime='" + dateTime + '\'' +
                ", pH=" + pH +
                ", dO=" + dO +
                ", nH4=" + nH4 +
                ", cODMn=" + cODMn +
                ", tOC=" + tOC +
                ", level='" + level + '\'' +
                '}';
    }
}
