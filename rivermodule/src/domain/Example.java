package domain;

/**
 * @author laoyingyong
 * @date: 2020-02-05 13:28
 */
public  class Example implements Comparable<Example>
{
    private Integer id;
    private String name;
    private String type;
    private String source;
    private Double multiple;
    private Integer distance;
    private String toxicity;
    private String danger;
    private String stability;
    private String solubility;
    private String volatility;
    private String technology;

    private Double sim;

    public Double getSim() {
        return sim;
    }

    public void setSim(Double sim) {
        this.sim = sim;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public Double getMultiple() {
        return multiple;
    }

    public void setMultiple(Double multiple) {
        this.multiple = multiple;
    }

    public Integer getDistance() {
        return distance;
    }

    public void setDistance(Integer distance) {
        this.distance = distance;
    }

    public String getToxicity() {
        return toxicity;
    }

    public void setToxicity(String toxicity) {
        this.toxicity = toxicity;
    }

    public String getDanger() {
        return danger;
    }

    public void setDanger(String danger) {
        this.danger = danger;
    }

    public String getStability() {
        return stability;
    }

    public void setStability(String stability) {
        this.stability = stability;
    }

    public String getSolubility() {
        return solubility;
    }

    public void setSolubility(String solubility) {
        this.solubility = solubility;
    }

    public String getVolatility() {
        return volatility;
    }

    public void setVolatility(String volatility) {
        this.volatility = volatility;
    }

    public String getTechnology() {
        return technology;
    }

    public void setTechnology(String technology) {
        this.technology = technology;
    }

    @Override
    public String toString() {
        return "Example{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", type='" + type + '\'' +
                ", source='" + source + '\'' +
                ", multiple=" + multiple +
                ", distance=" + distance +
                ", toxicity='" + toxicity + '\'' +
                ", danger='" + danger + '\'' +
                ", stability='" + stability + '\'' +
                ", solubility='" + solubility + '\'' +
                ", volatility='" + volatility + '\'' +
                ", technology='" + technology + '\'' +
                ", sim=" + sim +
                '}';
    }


    @Override
    public int compareTo(Example example)
    {
        return this.sim<example.sim?1:this.sim>example.sim?-1:0;
    }
}
