package service;

import domain.PageBean;
import domain.WaterQualityStation;

import java.util.List;
import java.util.Map;

public interface WaterQualityStationService
{
    public abstract int findTotalCount();
    public abstract WaterQualityStation findIntroByName(String name);
    public abstract boolean addWaterQualityStation(WaterQualityStation station);
    public abstract PageBean<WaterQualityStation> getPageBean(int currentPage,int pageSize);
    public abstract WaterQualityStation findIntroById(int id);
    public abstract PageBean<WaterQualityStation> conditonalQueryByPage(int currentPage, int pageSize, Map<String,String[]> condition);
    public abstract int conditionalFindAllCount(Map<String, String[]> condition);
}
