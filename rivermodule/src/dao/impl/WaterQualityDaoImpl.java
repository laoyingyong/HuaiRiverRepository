package dao.impl;

import dao.WaterQualityDao;
import domain.WaterQuality;
import domain.WaterQualityStation;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import util.JDBCUtils;

import java.util.List;

public class WaterQualityDaoImpl implements WaterQualityDao
{
    JdbcTemplate template=new JdbcTemplate(JDBCUtils.getDataSource());
    @Override
    public List<WaterQuality> findAllByStationName(String stationName)
    {
        String sql="select * from water_quality where belongStation=?";
        List<WaterQuality> query = template.query(sql, new BeanPropertyRowMapper<WaterQuality>(WaterQuality.class),stationName);
        return query;
    }

    @Override
    public boolean addWaterQualityInfo(WaterQuality waterQuality)
    {
        int update=0;
        try {
            String sql="insert into water_quality " +
                    "(id,belongStation,ph,oxygen,nitrogen,permangan,orgacarbon,phquality,date,time) " +
                    "values (null,?,?,?,?,?,?,?,?,?)";
            update = template.update(sql,
                    waterQuality.getBelongStation(),
                    waterQuality.getPh(),
                    waterQuality.getOxygen(),
                    waterQuality.getNitrogen(),
                    waterQuality.getPermangan(),
                    waterQuality.getOrgacarbon(),
                    waterQuality.getPhquality(),
                    waterQuality.getDate(),
                    waterQuality.getTime());
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
    public boolean update(WaterQuality waterQuality)
    {
        int update=0;
        try
        {
            String sql="update water_quality" +
                    " set belongStation=?," +
                    "ph=?," +
                    "oxygen=?," +
                    "nitrogen=?," +
                    "permangan=?," +
                    "orgacarbon=?," +
                    "phquality=?," +
                    "date=?," +
                    "time=? where id=?";

            update = template.update(sql,
                    waterQuality.getBelongStation(),
                    waterQuality.getPh(),
                    waterQuality.getOxygen(),
                    waterQuality.getNitrogen(),
                    waterQuality.getPermangan(),
                    waterQuality.getOrgacarbon(),
                    waterQuality.getPhquality(),
                    waterQuality.getDate(),
                    waterQuality.getTime(),
                    waterQuality.getId());
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
    public boolean delete(int id)
    {
        int update=0;
        try
        {
            String sql="delete from water_quality where id=?";
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
}
