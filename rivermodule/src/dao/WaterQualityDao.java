package dao;

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
}
