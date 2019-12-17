package dao;

import domain.RainFall;

import java.util.List;
import java.util.Map;

public interface RainFallDao
{
    public abstract List<RainFall> findAll();
    public abstract boolean addRainFallInfo(RainFall rainFall);
    public abstract List<RainFall> conditonalQueryByPage(int start, int pageSize, Map<String,String[]> condition);
    public abstract int conditionalFindAllCount(Map<String, String[]> condition);
    public abstract boolean updateRainFallInfo(RainFall rainFall);


}
