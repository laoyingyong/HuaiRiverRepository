package service;

import domain.WaterQuality;
import domain.WaterQualityStation;

import java.util.List;

public interface WaterQualityService
{
    public abstract List<WaterQuality> findAllByStationName(String stationName);
    public abstract boolean addWaterQualityInfo(WaterQuality waterQuality);

}