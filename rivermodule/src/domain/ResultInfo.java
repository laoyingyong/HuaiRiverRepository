package domain;

public class ResultInfo
{

    private String msg;

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    @Override
    public String toString() {
        return "ResultInfo{" +
                "msg='" + msg + '\'' +
                '}';
    }
}
