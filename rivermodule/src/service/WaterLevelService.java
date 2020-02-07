package service;

import domain.PageBean;
import domain.WaterLevel;

import java.util.List;
import java.util.Map;

public interface WaterLevelService
{
    public abstract PageBean<WaterLevel> findAllByPage(int currentPage,int pageSize);
    public abstract int findAllCount();
    public abstract boolean addWaterLevelInfo(WaterLevel waterLevel);
    public abstract int addManyLevel(List<WaterLevel> levelList);
    public abstract boolean update(WaterLevel waterLevel);
    public abstract boolean deleteInfo(int id);
    public abstract PageBean<WaterLevel> conditionalQueryByPage(int currentPage,int pageSize, Map<String, String[]> condition);
    public abstract int conditionalFindAllCount(Map<String, String[]> condition);
    public abstract List<WaterLevel> findBySiteName(String siteName);

}
