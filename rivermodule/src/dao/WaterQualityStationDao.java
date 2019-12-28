package dao;


import domain.WaterQualityStation;

import java.util.List;
import java.util.Map;

public interface WaterQualityStationDao
{
    public abstract List<WaterQualityStation> findAll();
    public abstract WaterQualityStation findByName(String stationName);
    public abstract WaterQualityStation findIntroByName(String name);
    public abstract boolean addWaterQualityStation(WaterQualityStation station);
    public abstract List<WaterQualityStation> findByPage(int start,int pageSize);
    public abstract int findTotalCount();
    public abstract WaterQualityStation findIntroById(int id);
    public abstract List<WaterQualityStation> conditonalQueryByPage(int start, int pageSize, Map<String,String[]> condition);
    public abstract int conditionalFindAllCount(Map<String, String[]> condition);
    public abstract boolean update(WaterQualityStation station);
    public abstract boolean delete(int id);
}
