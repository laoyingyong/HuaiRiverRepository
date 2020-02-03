package service;

import dao.WaterQualityDao;
import dao.impl.WaterQualityDaoImpl;
import domain.Statistics;
import domain.WaterQuality;

import java.util.List;

/**
 * @author laoyingyong
 * @date: 2020-01-20 15:15
 */
public interface WaterQualityService
{
    public abstract int add(List<WaterQuality> waterQualityList);

    public abstract boolean addOne(WaterQuality waterQuality);
    public abstract List<WaterQuality> findByName(String stationName);
    public abstract boolean update(WaterQuality waterQuality);
    public abstract boolean del(int id);
    public abstract Statistics count(String stationName);
    public abstract WaterQuality findNewestRecord(String stationName);
    public abstract List<WaterQuality> findPollutedWater();


}
