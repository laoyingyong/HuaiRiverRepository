package dao;

import domain.PageBean;
import domain.WaterLevel;

import java.util.List;
import java.util.Map;

public interface WaterLevelDao
{
    public abstract List<WaterLevel> findAllByPage(int start,int pageSize);
    public abstract int findAllCount();
    public abstract boolean addWaterLevelInfo(WaterLevel waterLevel);
    public abstract boolean update(WaterLevel waterLevel);
    public abstract boolean deleteInfo(int id);
    public abstract List<WaterLevel> conditionalQueryByPage(int start, int pageSize, Map<String,String[]> condition);
    public abstract int conditionalFindAllCount(Map<String, String[]> condition);
}
