package domain;

import java.sql.Date;

public class RainFall
{
    private int id;
    private String area;
    private Double precipitation;
    private Integer month;
    private Date releaseDate;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getArea() {
        return area;
    }

    public void setArea(String area) {
        this.area = area;
    }

    public Double getPrecipitation() {
        return precipitation;
    }

    public void setPrecipitation(Double precipitation) {
        this.precipitation = precipitation;
    }

    public Integer getMonth() {
        return month;
    }

    public void setMonth(Integer month) {
        this.month = month;
    }

    public Date getReleaseDate() {
        return releaseDate;
    }

    public void setReleaseDate(Date releaseDate) {
        this.releaseDate = releaseDate;
    }

    @Override
    public String toString() {
        return "RainFall{" +
                "id=" + id +
                ", area='" + area + '\'' +
                ", precipitation=" + precipitation +
                ", month=" + month +
                ", releaseDate=" + releaseDate +
                '}';
    }
}
