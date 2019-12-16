package domain;

import java.sql.Date;
import java.sql.Time;

public class WaterQuality
{
    private int id;
    private String belongStation;
    private Double ph;
    private String phquality;
    private Double oxygen;
    private String oxygenquality;
    private Double nitrogen;
    private String nitrogenquality;
    private Double permangan;
    private String permanganquality;
    private Double orgacarbon;
    private String orgacarbonquality;
    private Date date;
    private Time time;


    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getBelongStation() {
        return belongStation;
    }

    public void setBelongStation(String belongStation) {
        this.belongStation = belongStation;
    }

    public Double getPh() {
        return ph;
    }

    public void setPh(Double ph) {
        this.ph = ph;
    }

    public String getPhquality() {
        return phquality;
    }

    public void setPhquality(String phquality) {
        this.phquality = phquality;
    }

    public Double getOxygen() {
        return oxygen;
    }

    public void setOxygen(Double oxygen) {
        this.oxygen = oxygen;
    }

    public String getOxygenquality() {
        return oxygenquality;
    }

    public void setOxygenquality(String oxygenquality) {
        this.oxygenquality = oxygenquality;
    }

    public Double getNitrogen() {
        return nitrogen;
    }

    public void setNitrogen(Double nitrogen) {
        this.nitrogen = nitrogen;
    }

    public String getNitrogenquality() {
        return nitrogenquality;
    }

    public void setNitrogenquality(String nitrogenquality) {
        this.nitrogenquality = nitrogenquality;
    }

    public Double getPermangan() {
        return permangan;
    }

    public void setPermangan(Double permangan) {
        this.permangan = permangan;
    }

    public String getPermanganquality() {
        return permanganquality;
    }

    public void setPermanganquality(String permanganquality) {
        this.permanganquality = permanganquality;
    }

    public Double getOrgacarbon() {
        return orgacarbon;
    }

    public void setOrgacarbon(Double orgacarbon) {
        this.orgacarbon = orgacarbon;
    }

    public String getOrgacarbonquality() {
        return orgacarbonquality;
    }

    public void setOrgacarbonquality(String orgacarbonquality) {
        this.orgacarbonquality = orgacarbonquality;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public Time getTime() {
        return time;
    }

    public void setTime(Time time) {
        this.time = time;
    }

    @Override
    public String toString() {
        return "WaterQuality{" +
                "id=" + id +
                ", belongStation='" + belongStation + '\'' +
                ", ph=" + ph +
                ", phquality='" + phquality + '\'' +
                ", oxygen=" + oxygen +
                ", oxygenquality='" + oxygenquality + '\'' +
                ", nitrogen=" + nitrogen +
                ", nitrogenquality='" + nitrogenquality + '\'' +
                ", permangan=" + permangan +
                ", permanganquality='" + permanganquality + '\'' +
                ", orgacarbon=" + orgacarbon +
                ", orgacarbonquality='" + orgacarbonquality + '\'' +
                ", date=" + date +
                ", time=" + time +
                '}';
    }
}
