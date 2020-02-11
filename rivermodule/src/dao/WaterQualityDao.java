package dao;

import domain.StationAndQuality;
import domain.Statistics;
import domain.WaterQuality;

import java.util.List;

/**
 * @author laoyingyong
 * @date: 2020-01-20 15:03
 */
public interface WaterQualityDao
{
    public abstract boolean add(WaterQuality waterQuality);//添加一条记录
    public abstract List<WaterQuality> findByName(String stationName);
    public abstract boolean update(WaterQuality waterQuality);
    public abstract boolean del(int id);
    public abstract WaterQuality findNewestRecord(String stationName);
    public abstract List<WaterQuality> findPollutedWater();
    public abstract List<WaterQuality> findByNameAndTime(String name,String startTime,String endTime,String level);
    public abstract List<WaterQuality> findByStationName(String name);
    public abstract List<WaterQuality> findWeekData();


}
