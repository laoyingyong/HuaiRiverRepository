package dao;

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

}
