package service;

import dao.WaterQualityDao;
import dao.impl.WaterQualityDaoImpl;
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
}
