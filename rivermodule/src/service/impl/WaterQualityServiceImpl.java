package service.impl;

import dao.WaterQualityDao;
import dao.impl.WaterQualityDaoImpl;
import domain.WaterQuality;
import service.WaterQualityService;

import java.util.List;

/**
 * @author laoyingyong
 * @date: 2020-01-20 15:18
 */
public class WaterQualityServiceImpl implements WaterQualityService
{
    WaterQualityDao dao=new WaterQualityDaoImpl();

    @Override
    public int add(List<WaterQuality> waterQualityList)
    {
        int count=0;
        for (WaterQuality waterQuality : waterQualityList)
        {
            boolean flag = dao.add(waterQuality);
            if(flag)
            {
                count++;
            }

        }
        return count;//返回的是添加成功的记录数
    }

    @Override
    public boolean addOne(WaterQuality waterQuality)
    {
        boolean add = dao.add(waterQuality);
        return add;
    }


}
