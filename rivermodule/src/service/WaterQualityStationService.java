package service;

import domain.PageBean;
import domain.StationAndQuality;
import domain.WaterQualityStation;

import java.util.List;
import java.util.Map;

public interface WaterQualityStationService
{
    public abstract List<WaterQualityStation> findAll();
    public abstract WaterQualityStation findByName(String stationName);
    public abstract int findTotalCount();
    public abstract WaterQualityStation findIntroByName(String name);
    public abstract boolean addWaterQualityStation(WaterQualityStation station);
    public abstract PageBean<WaterQualityStation> getPageBean(int currentPage,int pageSize);
    public abstract WaterQualityStation findIntroById(int id);
    public abstract PageBean<WaterQualityStation> conditonalQueryByPage(int currentPage, int pageSize, Map<String,String[]> condition);
    public abstract int conditionalFindAllCount(Map<String, String[]> condition);
    public abstract boolean update(WaterQualityStation station);
    public abstract boolean delete(int id);
    public abstract List<WaterQualityStation> findPollutedSite();
    public  abstract WaterQualityStation findIntro(double longitude,double latitude);
    public abstract StationAndQuality findStationAndQuality(double longitude, double latitude);
}
