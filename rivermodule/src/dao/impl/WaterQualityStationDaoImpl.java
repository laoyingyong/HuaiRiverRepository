package dao.impl;

import dao.WaterQualityStationDao;
import domain.StationAndQuality;
import domain.WaterQuality;
import domain.WaterQualityStation;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import util.JDBCUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class WaterQualityStationDaoImpl implements WaterQualityStationDao
{
    private JdbcTemplate template=new JdbcTemplate(JDBCUtils.getDataSource());

    @Override
    public List<WaterQualityStation> findAll()
    {
        //定义sql
        String sql="select * from water_quality_station";
        //执行sql
        List<WaterQualityStation> station = template.query(sql, new BeanPropertyRowMapper<WaterQualityStation>(WaterQualityStation.class));
        return station;
    }

    @Override
    public WaterQualityStation findByName(String stationName)
    {
        WaterQualityStation station = null;
        try
        {
            String sql="select * from water_quality_station where stationName=?";
            station = template.queryForObject(sql, new BeanPropertyRowMapper<WaterQualityStation>(WaterQualityStation.class), stationName);
        } catch (DataAccessException e)
        {
            System.out.println(e);
        }
        return station;
    }

    @Override
    public WaterQualityStation findIntroByName(String name) {
        String sql="select * from water_quality_station where stationName=?";
        WaterQualityStation waterQualityStation = template.queryForObject(sql, new BeanPropertyRowMapper<WaterQualityStation>(WaterQualityStation.class),name);
        return waterQualityStation;
    }

    @Override
    public boolean addWaterQualityStation(WaterQualityStation station)
    {
        int update = 0;
        try {
            String sql="insert into water_quality_station values(null,?,?,?,?,?)";
            update = template.update(sql,station.getStationName(),station.getLongitude(),station.getLatitude(),station.getSection(),station.getIntroduction());
        } catch (DataAccessException e) {
            System.out.println(e);;
        }
        System.out.println(update);
        if(update!=0)
        {
            return true;
        }
        else
        {
            return false;
        }


    }

    @Override
    public List<WaterQualityStation> findByPage(int start, int pageSize)
    {
        List<WaterQualityStation> list=null;
        try {
            String sql="select * from water_quality_station limit ?,?";
          list = template.query(sql,
                    new BeanPropertyRowMapper<WaterQualityStation>(WaterQualityStation.class), start, pageSize);
        } catch (DataAccessException e) {
            System.out.println(e);
        }

        return list;
    }

    @Override
    public int findTotalCount()
    {
        String sql="select count(*) from water_quality_station";
        Integer integer = template.queryForObject(sql, Integer.class);
        return integer;
    }

    @Override
    public WaterQualityStation findIntroById(int id)
    {
        WaterQualityStation station = null;
        try {
            String sql="select * from water_quality_station where id=?";
            station = template.queryForObject(sql, new BeanPropertyRowMapper<WaterQualityStation>(WaterQualityStation.class), id);
        } catch (DataAccessException e) {
            System.out.println(e);
        }
        return station;
    }

    @Override
    public List<WaterQualityStation> conditonalQueryByPage(int start, int pageSize, Map<String, String[]> condition)
    {
        StringBuilder builder=new StringBuilder();//代表整个sql语句
        String starStr="select * from water_quality_station where 1=1 ";
        builder.append(starStr);

        List<Object> valueList=new ArrayList<>();

        //遍历map集合
        for(String key:condition.keySet())
        {

            //排除分页条件参数
            if("currentPage".equals(key) || "pageSize".equals(key))
            {
                continue;
            }


            String value = condition.get(key)[0];
            if(value!=null&&!"".equals(value))
            {
                builder.append(" and "+key+" like ? ");
                valueList.add("%"+value+"%");

            }
        }


        builder.append(" limit ?,? ");
        valueList.add(start);
        valueList.add(pageSize);
        String sql = builder.toString();

        System.out.println(sql);
        System.out.println(valueList);

        //执行sql
        List<WaterQualityStation> objList = null;
        try {
            objList = template.query(sql, new BeanPropertyRowMapper<WaterQualityStation>(WaterQualityStation.class), valueList.toArray());
        } catch (DataAccessException e) {
            System.out.println(e);
        }

        return objList;
    }

    @Override
    public int conditionalFindAllCount(Map<String, String[]> condition)
    {
        StringBuilder builder=new StringBuilder();//代表整个sql语句
        String starStr="select count(*) from water_quality_station where 1=1 ";
        builder.append(starStr);

        List<Object> valueList=new ArrayList<>();

        //遍历map集合
        for(String key:condition.keySet())
        {

            //排除分页条件参数
            if("currentPage".equals(key) || "pageSize".equals(key))
            {
                continue;
            }


            String value = condition.get(key)[0];
            if(value!=null&&!"".equals(value))
            {
                builder.append(" and "+key+" like ? ");
                valueList.add("%"+value+"%");

            }
        }
        String sql = builder.toString();
        System.out.println(sql);
        System.out.println(valueList);

        int integer = 0;
        try {
            integer = template.queryForObject(sql, Integer.class, valueList.toArray());
        } catch (DataAccessException e)
        {
            System.out.println(e);
        }


        return integer;
    }

    @Override
    public boolean update(WaterQualityStation station)
    {
        int update=0;
        try {
            String sql="update water_quality_station set stationName=?,longitude=?,latitude=?,section=?,introduction=? where id=?";
            update = template.update(sql,
                    station.getStationName(),
                    station.getLongitude(),
                    station.getLatitude(),
                    station.getSection(),
                    station.getIntroduction(),
                    station.getId());
        } catch (DataAccessException e) {
            System.out.println(e);
        }
        if(update!=0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    @Override
    public boolean delete(int id)
    {
        int update=0;
        try {
            String sql="delete from water_quality_station where id=?";
            update = template.update(sql, id);
        } catch (DataAccessException e)
        {
            System.out.println(e);
        }
        if(update!=0)
        {
            return true;
        }
        else
        {
            return false;
        }

    }

    @Override
    public List<WaterQualityStation> findPollutedSite()
    {
        List<WaterQualityStation> list=null;
        try
        {
            String sql="SELECT * FROM water_quality_station WHERE stationName IN\n" +
                    "(SELECT DISTINCT belongStation FROM water_quality WHERE (LEVEL='IV' OR LEVEL='V' OR LEVEL='劣V') \n" +
                    "AND TO_DAYS(NOW())-TO_DAYS(DATETIME)<=1)";
            list = template.query(sql, new BeanPropertyRowMapper<WaterQualityStation>(WaterQualityStation.class));
        } catch (Exception e)
        {
            System.out.println(e);
        }
        return list;
    }

    @Override
    public WaterQualityStation findIntro(double longitude, double latitude)
    {
        WaterQualityStation station= null;
        try {
            String sql="SELECT * FROM water_quality_station WHERE ABS(longitude-?)<0.1 AND ABS(latitude-?)<0.1;";
            List<WaterQualityStation> list = template.query(sql, new BeanPropertyRowMapper<WaterQualityStation>(WaterQualityStation.class), longitude, latitude);
            if(list!=null)
            {station = list.get(0);}
        } catch (Exception e) {
            System.out.println(e);
        }
        return station;
    }

    @Override
    public StationAndQuality findStationAndQuality(double longitude, double latitude)
    {
        StationAndQuality stationAndQuality= null;
        try {
            String sql1="SELECT * FROM water_quality_station WHERE ABS(longitude-?)<0.1 AND ABS(latitude-?)<0.1";
            String sql2="SELECT * FROM water_quality WHERE belongStation IN\n" +
                    " (SELECT stationName FROM water_quality_station WHERE ABS(longitude-?)<0.1 AND ABS(latitude-?)<0.1)\n" +
                    "  ORDER BY DATETIME DESC LIMIT 1;";
            List<WaterQualityStation> list = template.query(sql1, new BeanPropertyRowMapper<WaterQualityStation>(WaterQualityStation.class),longitude,latitude);

            WaterQualityStation station=null;
            if(list.size()!=0&&list!=null)
            {
               station=list.get(0);
            }

            List<WaterQuality> list2 = template.query(sql2, new BeanPropertyRowMapper<WaterQuality>(WaterQuality.class), longitude, latitude);

            WaterQuality waterQuality=null;
            if(list2!=null&&list2.size()!=0)
            {
                waterQuality=list2.get(0);
            }

            stationAndQuality = new StationAndQuality();
            if(list!=null&&list2!=null)
            {
                stationAndQuality.setStation(station);
                stationAndQuality.setQuality(waterQuality);
            }

        } catch (Exception e) {
            System.out.println(e);
        }
        return stationAndQuality;
    }
}
