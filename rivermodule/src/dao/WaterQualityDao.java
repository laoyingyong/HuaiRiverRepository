package dao;

import domain.WaterQuality;
import domain.WaterQualityStation;

import java.util.List;

public interface WaterQualityDao
{
    public abstract List<WaterQuality> findAllByStationName(String stationName);
    public abstract boolean addWaterQualityInfo(WaterQuality waterQuality);
    public abstract boolean update(WaterQuality waterQuality);
    public abstract boolean delete(int id);
}
