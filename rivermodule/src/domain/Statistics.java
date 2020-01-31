package domain;

/**
 * @author laoyingyong
 * @date: 2020-01-30 12:47
 */
public class Statistics
{
    private int a;//I类水质的数量
    private int b;//II类水质的数量
    private int c;//III类水质的数量
    private int d;//IV类水质的数量
    private int e;//V类水质的数量
    private int f;//劣V类水质的数量
    private int g;//其他

    public int getA() {
        return a;
    }

    public void setA(int a) {
        this.a = a;
    }

    public int getB() {
        return b;
    }

    public void setB(int b) {
        this.b = b;
    }

    public int getC() {
        return c;
    }

    public void setC(int c) {
        this.c = c;
    }

    public int getD() {
        return d;
    }

    public void setD(int d) {
        this.d = d;
    }

    public int getE() {
        return e;
    }

    public void setE(int e) {
        this.e = e;
    }

    public int getF() {
        return f;
    }

    public void setF(int f) {
        this.f = f;
    }

    public int getG() {
        return g;
    }

    public void setG(int g) {
        this.g = g;
    }

    @Override
    public String toString() {
        return "Statistics{" +
                "a=" + a +
                ", b=" + b +
                ", c=" + c +
                ", d=" + d +
                ", e=" + e +
                ", f=" + f +
                ", g=" + g +
                '}';
    }
}
