package service.impl;

import dao.WaterQualityDao;
import dao.impl.WaterQualityDaoImpl;
import domain.Statistics;
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

    @Override
    public List<WaterQuality> findByName(String stationName)
    {
        List<WaterQuality>  list= dao.findByName(stationName);
        return list;
    }

    @Override
    public boolean update(WaterQuality waterQuality)
    {
        return dao.update(waterQuality);
    }

    @Override
    public boolean del(int id)
    {
        return dao.del(id);
    }

    @Override
    public Statistics count(String stationName)
    {
        int a=0;
        int b=0;
        int c=0;
        int d=0;
        int e=0;
        int f=0;
        int g=0;
        List<WaterQuality> list = dao.findByName(stationName);
        for (WaterQuality waterQuality : list)
        {
            String level = waterQuality.getLevel();
            if(level.equals("I"))
            {
                a++;
            }
            else if(level.equals("II"))
            {
                b++;
            }
            else if(level.equals("III"))
            {
                c++;
            }
            else if(level.equals("IV"))
            {
                d++;
            }
            else if(level.equals("V"))
            {
                e++;
            }
            else if(level.equals("劣V"))
            {
                f++;
            }
            else
            {
                g++;
            }

        }
        Statistics statistics=new Statistics();
        statistics.setA(a);
        statistics.setB(b);
        statistics.setC(c);
        statistics.setD(d);
        statistics.setE(e);
        statistics.setF(f);
        statistics.setG(g);

        return statistics;
    }

    @Override
    public WaterQuality findNewestRecord(String stationName)
    {
        return dao.findNewestRecord(stationName);
    }

    @Override
    public List<WaterQuality> findPollutedWater() {
        return dao.findPollutedWater();
    }

    @Override
    public List<WaterQuality> findByNameAndTime(String name, String startTime, String endTime,String level) {
        return dao.findByNameAndTime(name,startTime,endTime,level);
    }

    @Override
    public List<WaterQuality> findByStationName(String name)
    {
        return dao.findByStationName(name);
    }


}
